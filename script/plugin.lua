local config = require 'config'
local util   = require 'utility'
local client = require 'client'
local lang   = require 'language'
local await  = require 'await'
local scope  = require 'workspace.scope'
local ws     = require 'workspace'
local fs = require 'bee.filesystem'

---@class plugin
local m = {}

function m.showError(scp, err)
    if m._hasShowedError then
        return
    end
    m._hasShowedError = true
    client.showMessage('Error', lang.script('PLUGIN_RUNTIME_ERROR', scp:get('pluginPath'), err))
end

function m.dispatch(event, uri, ...)
    local scp = scope.getScope(uri)
    local interface = scp:get('pluginInterface')
    if not interface then
        return false
    end
    local method = interface[event]
    if type(method) ~= 'function' then
        return false
    end
    local clock = os.clock()
    tracy.ZoneBeginN('plugin dispatch:' .. event)
    local suc, res1, res2 = xpcall(method, log.error, uri, ...)
    tracy.ZoneEnd()
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('Call plugin event [%s] takes [%.3f] sec'):format(event, passed))
    end
    if suc then
        return true, res1, res2
    else
        m.showError(scp, res1)
    end
    return false, res1
end

---@async
---@param scp scope
local function checkTrustLoad(scp)
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

---@param uri uri
local function initPlugin(uri)
    await.call(function () ---@async
        local scp = scope.getScope(uri)
        local interface = {}
        scp:set('pluginInterface', interface)

        if not scp.uri then
            return
        end

        local pluginPath = ws.getAbsolutePath(scp.uri, config.get(scp.uri, 'Lua.runtime.plugin'))
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

        local env = setmetatable(interface, { __index = _ENV })
        local f, err = load(pluginLua, '@'..pluginPath, "t", env)
        if not f then
            log.error(err)
            m.showError(scp, err)
            return
        end
        if not client.isVSCode() and not checkTrustLoad(scp) then
            return
        end
        local pluginArgs = config.get(scp.uri, 'Lua.runtime.pluginArgs')
        local suc, err = xpcall(f, log.error, f, uri, pluginArgs)
        if not suc then
            m.showError(scp, err)
            return
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
