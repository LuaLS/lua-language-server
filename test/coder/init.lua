---@type string?
TEST_CODER = nil

---@param code string
function TEST_INDEX(code)
    test.scope.rt:reset()
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    ls.file.setServerText('test.lua', code)

    vfile:index()
    TEST_CODER = vfile.coder
end

print('[coder] 测试中...')

require 'test.coder.meta'
require 'test.coder.common'
require 'test.coder.metatable'
require 'test.coder.block'
require 'test.coder.flow'

print('[coder] 测试完毕')
