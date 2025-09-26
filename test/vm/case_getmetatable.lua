local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@alias f<T> T[]
---@alias A f<number>
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A').value:view() == 'f<number>')
    assert(node.type('A').value.value:view() == 'number[]')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@alias f<T> T['__index']
---@alias A f<{ __index: 1 }>
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A').value:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@generic T, MT
---@param t T
---@param mt MT
---@return T & MT['__index']
function setmetatable(t, mt) return end

---@class A
local mt = {}
mt.__index = mt

obj = setmetatable({}, mt)
    ]]
    vfile:indexAst(ast, 'common')

    assert(node:globalGet('obj').value:view() == 'A')
end
