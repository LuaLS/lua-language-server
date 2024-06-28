ls.threadName = 'worker'

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    print = function (level, message, timeStamp)
        
    end,
}

log.info('Worker ready!')

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

require 'core'
