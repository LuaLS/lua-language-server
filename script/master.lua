local fs      = require 'bee.filesystem'
local time    = require 'bee.time'
local channel = require 'bee.channel'

ls.threadName = 'master'

--语言服务器自身的状态
require 'runtime'

fs.create_directories(fs.path(ls.env.LOG_PATH))

local logChannel = channel.create('log')

local function writeLog(name, timeStamp, level, sourceStr, message)
    local fullMessage = '[{}][{:5s}][{}]<{}>: {}\n' % {
        timeStamp,
        level,
        sourceStr,
        name,
        message,
    }
    return log:write(fullMessage)
end

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = ls.env.LOG_FILE,
    level = ls.args.LOGLEVEL,
    print = function (timeStamp, level, sourceStr, message)
        writeLog('master', timeStamp, level, sourceStr, message)
        return true
    end
}

ls.eventLoop.addTask(function ()
    while true do
        local ok, name, timeStamp, level, sourceStr, message = logChannel:pop()
        if ok then
            writeLog(name, timeStamp, level, sourceStr, message)
        else
            break
        end
    end
end)

log.info('Lua Lsp startup!')
log.info('LUALS:', ls.env.ROOT_URI)
log.info('LOGPATH:', ls.env.LOG_URI)
log.info('METAPATH:', ls.env.META_URI)
log.info('VERSION:', ls.env.version)
log.info('LOGLEVEL:', ls.args.LOGLEVEL)
