local config = require 'config'
local util   = require 'utility'
local client = require 'client'
local lang   = require 'language'
local await  = require 'await'
local scope  = require 'workspace.scope'
local ws     = require 'workspace'
local fs = require 'bee.filesystem'

---@class pluginInterfaces
local pluginConfigs = {
    -- create plugin for vm module
    VM = {
        OnCompileFunctionParam = function (next, func, source)
        end
    }
}

---@class plugin
local m = {}

function m.showError(scp, err)
    if m._hasShowedError then
        return
    end
    m._hasShowedError = true
    client.showMessage('Error', lang.script('PLUGIN_RUNTIME_ERROR', scp:get('pluginPath'), err))
end

---@alias plugin.event 'OnSetText' | 'OnTransformAst' | 'ResolveRequire'

---@param event plugin.event
function m.dispatch(event, uri, ...)
    local scp = scope.getScope(uri)
    local interfaces = scp:get('pluginInterfaces')
    if not interfaces then
        return false
    end
    local failed = 0
    local res1, res2
    for i, interface in ipairs(interfaces) do
        local method = interface[event]
        if type(method) ~= 'function' then
            return false
        end
        local clock = os.clock()
        tracy.ZoneBeginN('plugin dispatch:' .. event)
        local suc
        suc, res1, res2 = xpcall(method, log.error, uri, ...)
        tracy.ZoneEnd()
        local passed = os.clock() - clock
        if passed > 0.1 then
            log.warn(('Call plugin event [%s] takes [%.3f] sec'):format(event, passed))
        end
        if not suc then
            m.showError(scp, res1)
            failed = failed + 1
        end
    end
    return failed == 0, res1, res2
end

function m.getVmPlugin(uri)
    local scp = scope.getScope(uri)
    ---@type pluginInterfaces
    local interfaces = scp:get('pluginInterfaces')
    if not interfaces then
        return
    end
    return interfaces.VM
end

---@async
---@param scp scope
local function checkTrustLoad(scp)
	if TRUST_ALL_PLUGINS then
		return true
	end
    local pluginPath = scp:get('pluginPath')
    local filePath = LOGPATH .. '/trusted'
    local trusted = util.loadFile(filePath)
    local lines = {}
    if trusted then
        for line in util.eachLine(trusted) do
            lines[#lines+1] = line
            if line == pluginPath then
                return true
            end
        end
    end
    local _, index = client.awaitRequestMessage('Warning', lang.script('PLUGIN_TRUST_LOAD', pluginPath), {
        lang.script('PLUGIN_TRUST_YES'),
        lang.script('PLUGIN_TRUST_NO'),
    })
    if not index then
        return false
    end
    lines[#lines+1] = pluginPath
    util.saveFile(filePath, table.concat(lines, '\n'))
    return true
end

local function createMethodGroup(interfaces, key, methods)
    local methodGroup = {}

    for method in pairs(methods) do
        local funcs = setmetatable({}, {
            __call = function (t, next, ...)
                if #t == 0 then
                    return next(...)
                else
                    local result
                    for _, fn in ipairs(t) do
                        result = fn(next, ...)
                    end
                    return result
                end
            end
        })
        for _, interface in ipairs(interfaces) do
            local func = interface[method]
            if not func then
                local namespace = interface[key]
                if namespace then
                    func = namespace[method]
                end
            end
            if func then
                funcs[#funcs+1] = func
            end
        end
        methodGroup[method] = funcs
    end
    return #methodGroup>0 and methodGroup or nil
end

---@param uri uri
local function initPlugin(uri)
    await.call(function () ---@async
        local scp = scope.getScope(uri)
        local interfaces = {}
        scp:set('pluginInterfaces', interfaces)

        if not scp.uri then
            return
        end
        ---@type string[]|string
        local pluginConfigPaths = config.get(scp.uri, 'Lua.runtime.plugin')
        if not pluginConfigPaths then
            return
        end
        local args = config.get(scp.uri, 'Lua.runtime.pluginArgs')
        if args == nil then args = {} end
        if type(pluginConfigPaths) == 'string' then
            pluginConfigPaths = { pluginConfigPaths }
        end
        for i, pluginConfigPath in ipairs(pluginConfigPaths) do
            local myArgs = args
            if args then
                for k, v in pairs(args) do
                    if pluginConfigPath:find(k, 1, true) then
                        myArgs = v
                        break
                    end
                end
            end

            local pluginPath = ws.getAbsolutePath(scp.uri, pluginConfigPath)
            log.info('plugin path:', pluginPath)
            if not pluginPath then
                return
            end

            --Adding the plugins path to package.path allows for requires in files
            --to find files relative to itself.
            local oldPath = package.path
            local path = fs.path(pluginPath):parent_path() / '?.lua'
            if not package.path:find(path:string(), 1, true) then
                package.path = package.path .. ';' .. path:string()
            end

            local pluginLua = util.loadFile(pluginPath)
            if not pluginLua then
                log.warn('plugin not found:', pluginPath)
                package.path = oldPath
                return
            end

            scp:set('pluginPath', pluginPath)

            local interface = setmetatable({}, { __index = _ENV })
            local f, err = load(pluginLua, '@' .. pluginPath, "t", interface)
            if not f then
                log.error(err)
                m.showError(scp, err)
                return
            end
            if not client.isVSCode() and not checkTrustLoad(scp) then
                return
            end
            local suc, err = xpcall(f, log.error, f, uri, myArgs)
            if not suc then
                m.showError(scp, err)
                return
            end
            interfaces[#interfaces+1] = interface
        end

        for key, config in pairs(pluginConfigs) do
            interfaces[key] = createMethodGroup(interfaces, key, config)
        end

        ws.resetFiles(scp)
    end)
end

ws.watch(function (ev, uri)
    if ev == 'startReload' then
        require 'plugins'
        initPlugin(uri)
    end
end)

return m
