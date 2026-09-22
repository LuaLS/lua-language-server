---@type Coder?
TEST_CODER = nil

---@type VM.Vfile?
TEST_VFILE = nil

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
    TEST_VFILE = vfile

    return function ()
        if dispose then
            dispose()
        end
        vfile:remove()
    end
end


test.require 'test.coder.meta'
test.require 'test.coder.common'
test.require 'test.coder.metatable'
test.require 'test.coder.block'
test.require 'test.coder.flow'
test.require 'test.coder.custom'
test.require 'test.coder.optchain'
test.require 'test.coder.lua55'
test.require 'test.coder.type-annotation'
test.require 'test.coder.multi-return'
test.require 'test.coder.narrow-branch'
test.require 'test.coder.goto-narrow'
test.require 'test.coder.inline-cast'
