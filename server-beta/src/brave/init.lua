local brave   = require 'brave.brave'
local jsonrpc = require 'jsonrpc'

brave.on('loadProto', function ()
    while true do
        local proto = jsonrpc.decode(io.read, log.error)
        if proto then
            return proto
        end
    end
end)

return brave
