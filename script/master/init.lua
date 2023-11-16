
local time = require 'bee.time'

--语言服务器自身的状态
---@class LuaLS.Runtime
luals.runtime = require 'runtime.lua'

---@class Log
log = Class 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = luals.uri.decode(luals.runtime.logUri) .. '/service.log',
}

log.info('Lua Lsp startup!')
log.info('ROOT:', luals.runtime.rootUri)
log.info('LOGPATH:', luals.runtime.logUri)
log.info('METAPATH:', luals.runtime.metaUri)
log.info('VERSION:', luals.runtime.version)

xpcall(function ()
    if not luals.runtime.args.DEVELOP then
        return
    end
    require 'debugger':start "127.0.0.1:12399"
end, log.warn)

require 'cli'

local _, service = xpcall(require, log.error, 'service')

service.start()
