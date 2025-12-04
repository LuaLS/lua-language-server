collectgarbage('generational', 10, 50)

---@class never
---@field never never

require 'luals'
require 'master'

xpcall(function ()
    if not ls.args.DEVELOP then
        return
    end
    local dbg = require 'debugger'
    dbg:start(ls.args.DBGADDRESS .. ':' .. ls.args.DBGPORT)
    if ls.args.DBGWAIT then
        dbg:event 'wait'
    end
end, log.warn)

print = log.debug

local server = require 'language-server.init'
server.create():start()

ls.eventLoop.start()
