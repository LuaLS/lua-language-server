local brave   = require 'brave.brave'
local jsonrpc = require 'jsonrpc'
local parser  = require 'parser'

brave.on('loadProto', function ()
    while true do
        local proto = jsonrpc.decode(io.read, log.error)
        if proto then
            return proto
        end
    end
end)

brave.on('compile', function (text)
    local state, err = parser:compile(text, 'lua', 'Lua 5.4')
    if not state then
        log.error(err)
        return
    end
    local lines = parser:lines(text)
    return {
        root  = state.root,
        errs  = state.errs,
        lines = lines,
    }
end)

return brave
