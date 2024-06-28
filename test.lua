local fs   = require 'bee.filesystem'
local time = require 'bee.time'

collectgarbage('generational', 10, 50)

package.path = package.path.. ';./?.lua;./?/init.lua'

require 'luals'

--语言服务器自身的状态
---@class LuaLS.Runtime
ls.runtime = require 'runtime'

fs.create_directories(fs.path(ls.runtime.logPath))

---@diagnostic disable-next-line: lowercase-global
log = New 'Log' {
    clock = function ()
        return time.monotonic() / 1000.0
    end,
    time  = function ()
        return time.time() // 1000
    end,
    path = ls.uri.decode(ls.runtime.logUri) .. '/test.log',
}

---@class Test
test = {}
test.catch = require 'test.catch'

test.rootPath = ls.runtime.rootPath .. '/test_root'
test.rootUri  = ls.uri.encode(test.rootPath)
test.fileUri  = ls.uri.encode(test.rootPath .. '/unittest.lua')

test.singleFile = function (text)
    ls.files = New 'FileManager' ()
    ls.files:setText(test.fileUri, text)
    ls.files:flush()
    ls.vm = New 'VM' (ls.files)
end

print('开始测试')
require 'test.definition'
