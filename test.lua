local fs   = require 'bee.filesystem'

collectgarbage('generational', 10, 50)

package.path = package.path.. ';./?.lua;./?/init.lua'


require 'luals'
require 'runtime'
require 'worker'

---@class Log
log = New 'Log' {
    level = 'verb',
    print = function (level, message, timeStamp)
        print('[{}][{}]: {}' % { timeStamp, level, message })
    end
}

fs.create_directories(fs.path(ls.env.logPath))

---@class Test
test = {}
test.catch = require 'test.catch'

test.rootPath = ls.env.rootPath .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')
test.scope    = ls.scope.create()

print('开始测试')
require 'test.parser'
require 'test.node'
require 'test.vm'
require 'test.project'
print('测试完成')
