luals.threadName = 'worker'

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    print = function (level, message, timeStamp)
        
    end,
}

log.info('Worker ready!')

xpcall(function ()
    if not luals.runtime.args.DEVELOP then
        return
    end
    local dbg = require 'debugger'
    dbg:start(luals.runtime.args.DBGADDRESS .. ':' .. luals.runtime.args.DBGPORT)
    if luals.runtime.args.DBGWAIT then
        dbg:event 'wait'
    end
end, log.warn)

print = log.debug

require 'core'
