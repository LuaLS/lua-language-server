---@type string?
TEST_CODER = nil

---@param code string
function TEST_INDEX(code)
    test.scope.rt:reset()
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    ls.file.setText('test.lua', code)

    vfile:index()
    TEST_CODER = vfile.coder.code
end

require 'test.coder.meta'
require 'test.coder.common'
require 'test.coder.metatable'
