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

require 'scope'
ls.scope.watchFiles()

local languageServer = require 'language-server'
local server = languageServer.create()
server:start()

log.option.print = function (level, message, timeStamp)
    if level == 'error' or level == 'fatal' then
        server.client:logMessage('Error', message)
    end
end

ls.eventLoop.start()
