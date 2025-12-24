print(_VERSION)
local thread = require 'bee.thread'

collectgarbage('generational')
collectgarbage('param', 'minormul', 10)
collectgarbage('param', 'minormajor', 50)

package.path = package.path.. ';./?.lua;./?/init.lua'

---@class Test
test = {}

require 'luals'
require 'runtime'
ls.env.LOG_FILE = ls.util.expandPath('$LOG_PATH/test.log', ls.env)
require 'master'
require 'scope'
require 'config'
require 'filesystem'
require 'node'
require 'vm'
require 'file'
require 'feature'

local function writeLog(name, timeStamp, level, sourceStr, message)
    local fullMessage = '[{}][{:5s}][{}]<{}>: {}\n' % {
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

---@class Log
log = New 'Log' {
    level = 'verb',
    print = function (timeStamp, level, sourceStr, message)
        writeLog('master', timeStamp, level, sourceStr, message)
        return true
    end,
    path = ls.uri.decode(ls.env.LOG_URI) .. '/test.log',
}



test.rootPath = ls.env.ROOT_PATH .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')
test.scope    = ls.scope.create('test', test.rootUri)

---@async
ls.await.call(function ()
    -- 加载一些工具
    require 'test.include'
    test.catch = require 'test.catch'
    local suc, err = pcall(function ()
        print('开始测试')
        dofile 'test/tools/init.lua'
        require 'test.parser'
        require 'test.node'
        require 'test.coder'
        require 'test.feature'
        dofile 'test/project/init.lua'
    end)
    ls.await.sleep(1)
    ls.eventLoop.stop()
    if suc then
        print('测试完成')
    else
        print('测试失败：\n' .. err)
    end
    thread.sleep(1000)
    os.exit(true)
end)

ls.eventLoop.start(function ()
    ls.timer.update(1000)
    thread.sleep(1)
end)
