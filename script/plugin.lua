local config = require 'config'
local util   = require 'utility'

---@class plugin
local m = {}

function m.dispatch(event, ...)
    if not m.interface then
        return false
    end
    local method = m.interface[event]
    if type(method) ~= 'function' then
        return false
    end
    tracy.ZoneBeginN('plugin dispatch:' .. event)
    local suc, res1, res2 = xpcall(method, log.error, ...)
    tracy.ZoneEnd()
    if suc then
        return true, res1, res2
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
    local env = setmetatable(m.interface, { __index = _ENV })
    local f, err = load(pluginLua, '@'..pluginPath, "t", env)
    if not f then
        log.error(err)
        return
    end
    xpcall(f, log.error, f)

    resetFiles()
end

return m
