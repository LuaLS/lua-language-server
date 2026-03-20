local fs      = require 'bee.filesystem'
local time    = require 'bee.time'
local channel = require 'bee.channel'
local thread  = require 'bee.thread'

ls.threadName = 'master'
thread.setname('master')

--语言服务器自身的状态
require 'runtime'

fs.create_directories(fs.path(ls.env.LOG_PATH))

local logChannel = channel.create('log')

local function writeLog(name, timeStamp, level, sourceStr, message)
    local fullMessage = '[{}][{%5s}][{}]<{}>: {}\n' % {
        timeStamp,
        level,
        sourceStr,
        name,
        message,
    }
    if level == 'error' or level == 'fatal' then
        if ls.server then
            ls.server.client:logMessage('Error', message)
        end
    end
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

local function reportStatus()
    local document = require 'scope.document'
    local vfile = require 'vm.virtual_file'

    local lines = {}
    lines[#lines+1] = ''
    lines[#lines+1] = '======== LuaLS Status ========'
    lines[#lines+1] = '  Memory Usage: {%.3f} MB' % { collectgarbage('count') / 1024 }
    lines[#lines+1] = '  Idle Time: {%.3f} seconds' % { (time.monotonic() - ls.eventLoop.busyTime) / 1000 }
    lines[#lines+1] = '  Scope Count: {}' % { #ls.scope.all }
    lines[#lines+1] = '  File Count: {} / {}' % { ls.util.countTable(ls.file.all), ls.util.countTable(ls.file.traceMap) }
    lines[#lines+1] = '  Document Count: {}' % { ls.util.countTable(document.traceDocumentMap) }
    lines[#lines+1] = '  AST Count: {}' % { ls.util.countTable(document.traceAstMap) }
    lines[#lines+1] = '  Virtual File Count: {}' % { ls.util.countTable(vfile.traceMap) }
    lines[#lines+1] = '=============================='
    log.info(table.concat(lines, '\n'))
end

ls.timer.loop(60, reportStatus)
