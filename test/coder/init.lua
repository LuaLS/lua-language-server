---@type Coder?
TEST_CODER = nil

---@param code string
---@return function
function TEST_INDEX(code)
    test.scope.rt:reset()
    local dispose = test.checkInclude(code)
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    ls.file.setServerText('test.lua', code)

    vfile:index()
    TEST_CODER = vfile.coder

    return function ()
        if dispose then
            dispose()
        end
        vfile:remove()
    end
end

print('[coder] 测试中...')

require 'test.coder.meta'
require 'test.coder.common'
require 'test.coder.metatable'
require 'test.coder.block'
--require 'test.coder.flow'
require 'test.coder.custom'
--require 'test.coder.find-local'

print('[coder] 测试完毕')
