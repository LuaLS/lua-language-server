print(_VERSION)
local thread = require 'bee.thread'

collectgarbage('generational')
print(collectgarbage('param', 'minormul', 20))
print(collectgarbage('param', 'minormajor', 100))
print(collectgarbage('param', 'majorminor', 20))

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
require 'custom'
require 'file'
require 'feature'

test.rootPath = ls.env.ROOT_PATH .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')
test.scope    = ls.scope.create('test', test.rootUri)

---@async
ls.await.call(function ()
    -- 加载一些工具
    require 'test.include'
    test.catch = require 'test.catch'
    ---@diagnostic disable-next-line
    lt = require 'test.ltest'
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
