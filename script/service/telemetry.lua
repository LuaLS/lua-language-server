local net    = require 'service.net'
local timer  = require 'timer'
local config = require 'config'
local client = require 'provider.client'
local nonil  = require 'without-check-nil'

local token = ('%016X'):format(math.random(0, math.maxinteger))
local function push()
    local link = net.connect('tcp', '119.45.194.183', 11577)
    nonil.enable()
    local clientName    = client.info.clientInfo.name
    local clientVersion = client.info.clientInfo.version
    nonil.disable()
    link:write(string.pack('zzz'
        , 'pulse'
        , token
        , table.concat({clientName, clientVersion}, ' ')
    ))
    net.update()
end

timer.wait(5, function ()
    timer.loop(60, push)()
end)
