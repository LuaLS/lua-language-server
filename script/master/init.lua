local fs   = require 'bee.filesystem'
local time = require 'bee.time'

ls.threadName = 'master'

--语言服务器自身的状态
---@class LuaLS.Runtime
ls.runtime = require 'runtime'
ls.API = require 'master.api'
ls.eventLoop = require 'master.eventLoop'

fs.create_directories(fs.path(ls.runtime.logPath))

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = ls.uri.decode(ls.runtime.logUri) .. '/service.log',
}

log.info('Lua Lsp startup!')
log.info('LUALS:', ls.runtime.rootUri)
log.info('LOGPATH:', ls.runtime.logUri)
log.info('METAPATH:', ls.runtime.metaUri)
log.info('VERSION:', ls.runtime.version)

xpcall(function ()
    if not ls.runtime.args.DEVELOP then
        return
    end
    local dbg = require 'debugger'
    dbg:start(ls.runtime.args.DBGADDRESS .. ':' .. ls.runtime.args.DBGPORT)
    if ls.runtime.args.DBGWAIT then
        dbg:event 'wait'
    end
end, log.warn)

print = log.debug

ls.eventLoop.addTask(ls.timer.update)

ls.task.setTimer(ls.timer.wait)

ls.eventLoop.startEventLoop()
