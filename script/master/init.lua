local fs     = require 'bee.filesystem'
local time   = require 'bee.time'

ls.threadName = 'master'

--语言服务器自身的状态
---@class LuaLS.Runtime
ls.runtime = require 'runtime'
ls.API = require 'master.api'

fs.create_directories(fs.path(ls.env.logPath))

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = ls.uri.decode(ls.env.logUri) .. '/service.log',
}

log.info('Lua Lsp startup!')
log.info('LUALS:', ls.env.rootUri)
log.info('LOGPATH:', ls.env.logUri)
log.info('METAPATH:', ls.env.metaUri)
log.info('VERSION:', ls.env.version)

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

ls.eventLoop.start()
