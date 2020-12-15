local net    = require 'service.net'
local timer  = require 'timer'
local config = require 'config'
local client = require 'provider.client'
local nonil  = require 'without-check-nil'
local util   = require 'utility'

local tokenPath = (ROOT / 'log' / 'token'):string()
local token = util.loadFile(tokenPath)
if not token then
    token = ('%016X'):format(math.random(0, math.maxinteger))
    util.saveFile(tokenPath, token)
end

log.info('Telemetry Token:', token)

local function getClientName()
    nonil.enable()
    local clientName    = client.info.clientInfo.name
    local clientVersion = client.info.clientInfo.version
    nonil.disable()
    return table.concat({clientName, clientVersion}, ' ')
end

local function send(link, msg)
    link:write(('s4'):pack(msg))
end

local function pushClientInfo(link)
    send(link, string.pack('zzz'
        , 'pulse'
        , token
        , getClientName()
    ))
end

local function pushErrorLog(link)
    if not log.firstError then
        return
    end
    local err = log.firstError
    log.firstError = nil
    send(link, string.pack('zzzz'
        , 'error'
        , token
        , getClientName()
        , ('%q'):format(err)
    ))
end

timer.wait(5, function ()
    timer.loop(60, function ()
        if not config.config.telemetry.enable then
            return
        end
        local link = net.connect('tcp', '119.45.194.183', 11577)
        pushClientInfo(link)
        pushErrorLog(link)
    end)()
    timer.loop(1, function ()
        if not config.config.telemetry.enable then
            return
        end
        net.update()
    end)
end)
