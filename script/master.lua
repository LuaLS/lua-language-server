local fs     = require 'bee.filesystem'
local time   = require 'bee.time'

ls.threadName = 'master'

--语言服务器自身的状态
require 'runtime'

fs.create_directories(fs.path(ls.env.LOG_PATH))

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = ls.env.LOG_PATH / 'service.log',
    level = ls.args.LOGLEVEL,
}

log.info('Lua Lsp startup!')
log.info('LUALS:', ls.env.ROOT_URI)
log.info('LOGPATH:', ls.env.LOG_URI)
log.info('METAPATH:', ls.env.META_URI)
log.info('VERSION:', ls.env.version)
