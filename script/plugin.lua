local config = require 'config'
local util   = require 'utility'
local client = require 'client'
local lang   = require 'language'

---@class plugin
local m = {}

function m.showError(err)
    if m._hasShowedError then
        return
    end
    m._hasShowedError = true
    client.showMessage('Error', lang.script('PLUGIN_RUNTIME_ERROR', m.pluginPath, err))
end

function m.dispatch(event, ...)
    if not m.interface then
        return false
    end
    local method = m.interface[event]
    if type(method) ~= 'function' then
        return false
    end
    local clock = os.clock()
    tracy.ZoneBeginN('plugin dispatch:' .. event)
    local suc, res1, res2 = xpcall(method, log.error, ...)
    tracy.ZoneEnd()
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('Call plugin event [%s] takes [%.3f] sec'):format(event, passed))
    end
    if suc then
        return true, res1, res2
    else
        m.showError(res1)
    end
    return false, res1
end

function m.isReady()
    return m.interface ~= nil
end

local function resetFiles()
    local files = require 'files'
    for uri in files.eachFile() do
        files.resetText(uri)
    end
end

function m.init()
    local ws    = require 'workspace'
    m.interface = {}

    local pluginPath = ws.getAbsolutePath(config.get 'Lua.runtime.plugin')
    log.info('plugin path:', pluginPath)
    if not pluginPath then
        return
    end
    local pluginLua = util.loadFile(pluginPath)
    if not pluginLua then
        return
    end
    m.pluginPath = pluginPath
    local env = setmetatable(m.interface, { __index = _ENV })
    local f, err = load(pluginLua, '@'..pluginPath, "t", env)
    if not f then
        log.error(err)
        m.showError(err)
        return
    end
    local suc, err = xpcall(f, log.error, f)
    if not suc then
        m.showError(err)
        return
    end

    resetFiles()
end

return m
