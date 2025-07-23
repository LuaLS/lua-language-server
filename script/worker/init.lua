ls.threadName = 'worker'

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    print = function (level, message, timeStamp)
        
    end,
}

log.info('Worker ready!')

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

require 'worker.worker'
