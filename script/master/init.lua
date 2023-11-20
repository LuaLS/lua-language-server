local fs   = require 'bee.filesystem'
local time = require 'bee.time'

luals.threadName = 'master'

--语言服务器自身的状态
---@class LuaLS.Runtime
luals.runtime = require 'runtime'

fs.create_directories(fs.path(luals.runtime.logPath))

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = luals.uri.decode(luals.runtime.logUri) .. '/service.log',
}

log.info('Lua Lsp startup!')
log.info('LUALS:', luals.runtime.rootUri)
log.info('LOGPATH:', luals.runtime.logUri)
log.info('METAPATH:', luals.runtime.metaUri)
log.info('VERSION:', luals.runtime.version)

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
