local fs   = require 'bee.filesystem'
local time = require 'bee.time'

collectgarbage('generational', 10, 50)

package.path = package.path.. ';./?.lua;./?/init.lua'

require 'luals'

--语言服务器自身的状态
---@class LuaLS.Runtime
ls.runtime = require 'runtime'

fs.create_directories(fs.path(ls.runtime.logPath))

---@class Test
test = {}
test.catch = require 'test.catch'

test.rootPath = ls.runtime.rootPath .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')
test.scope    = ls.scope.create()

print('开始测试')
require 'test.parser'
require 'test.node'
require 'test.vm'
--require 'test.definition'
print('测试完成')
