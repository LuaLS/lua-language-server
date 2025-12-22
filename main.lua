collectgarbage('generational')
collectgarbage('param', 'minormul', 10)
collectgarbage('param', 'minormajor', 50)

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

require 'scope'
ls.scope.watchFiles()

local languageServer = require 'language-server'
ls.server = languageServer.create()
ls.server:start()

ls.eventLoop.start()
