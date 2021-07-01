local config = require 'config'
local fs     = require 'bee.filesystem'
local fsu    = require 'fs-utility'
local await  = require "await"

---@class plugin
local m = {}
m.waitingReady = {}

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

function m.awaitReady()
    if m.isReady() then
        return
    end
    await.wait(function (waker)
        m.waitingReady[#m.waitingReady+1] = waker
    end)
end

function m.init()
    local ws    = require 'workspace'
    m.interface = {}

    local _ <close> = function ()
        local waiting = m.waitingReady
        m.waitingReady = {}
        for _, waker in ipairs(waiting) do
            waker()
        end
    end

    if not config.get 'Lua.runtime.plugin' or config.get 'Lua.runtime.plugin' == '' then
        return
    end

    local pluginPath = fs.path(config.get 'Lua.runtime.plugin')
    if pluginPath:is_relative() then
        if not ws.path then
            return
        end
        pluginPath = fs.path(ws.path) / pluginPath
    end
    local pluginLua = fsu.loadFile(pluginPath)
    if not pluginLua then
        return
    end
    local env = setmetatable(m.interface, { __index = _ENV })
    local f, err = load(pluginLua, '@'..pluginPath:string(), "t", env)
    if not f then
        log.error(err)
        return
    end
    xpcall(f, log.error, f)
end

return m
