local brave   = require 'brave.brave'
local parser  = require 'parser'
local fs      = require 'bee.filesystem'
local furi    = require 'file-uri'
local util    = require 'utility'
local thread  = require 'bee.thread'

brave.on('loadProto', function ()
    local jsonrpc = require 'jsonrpc'
    while true do
        local proto, err = jsonrpc.decode(io.read)
        --log.debug('loaded proto', proto.method)
        if not proto then
            brave.push('protoerror', err)
            return
        end
        brave.push('proto', proto)
    end
end)

brave.on('timer', function (time)
    while true do
        thread.sleep(time)
        brave.push('wakeup')
    end
end)

brave.on('loadFile', function (path)
    return util.loadFile(path)
end)
