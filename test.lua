local fs     = require 'bee.filesystem'
local thread = require 'bee.thread'

collectgarbage('generational', 10, 50)

package.path = package.path.. ';./?.lua;./?/init.lua'


require 'luals'
require 'runtime'
require 'worker'

fs.create_directories(fs.path(ls.env.LOG_PATH))

---@class Log
log = New 'Log' {
    level = 'verb',
    print = function (level, message, timeStamp)
        print('[{}][{}]: {}' % { timeStamp, level, message })
    end,
    path = ls.uri.decode(ls.env.LOG_URI) .. '/test.log',
}


---@class Test
test = {}
test.catch = require 'test.catch'

test.rootPath = ls.env.ROOT_PATH .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')
test.scope    = ls.scope.create(test.rootUri)

---@async
ls.await.call(function ()
    local suc, err = pcall(function ()
        print('开始测试')
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
end)

ls.eventLoop.start(function ()
    ls.timer.update(1000)
end)
