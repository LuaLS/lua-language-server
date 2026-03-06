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

test.require 'test.coder.meta'
test.require 'test.coder.common'
test.require 'test.coder.metatable'
test.require 'test.coder.block'
test.require 'test.coder.flow'
test.require 'test.coder.custom'

print('[coder] 测试完毕')
