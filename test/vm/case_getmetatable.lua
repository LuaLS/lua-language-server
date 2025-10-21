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

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'f<{ __index: 1 }>')
    assert(node.type('A').value.value:view() == '1')
end

do
    node:reset()
    --[[
    ---@class A
    local t

    t.x = t

    --> A['x']
    ]]

    local A = node.type 'A'
    local CA = node.class 'A'
    A:addClass(CA)

    local V = node.variable 't'
    CA:addVariable(V)
    V:addClass(CA)

    V:addField {
        key   = node.value 'x',
        value = V,
    }

    local r = A:get 'x'
    assert(r:view() == 'A')
end

do
    node:reset()
    --[[
    local t

    t.x = 1

    --> t['x']
    ]]

    local V = node.variable 't'

    V:addField {
        key   = node.value 'x',
        value = node.value(1),
    }

    local r = V:get 'x'
    assert(r:view() == '1')
end

do
    node:reset()
    --[[
    ---@type fun<T>(x: T): T['__index']
    local f

    local t = {
        __index = 1
    }

    local r = f(t)
    ]]

    local F = node.variable 'f'
    local T = node.generic 'T'
    local FUN = node.func()
        : bindTypeParams { T }
        : addParamDef('x', T)
        : addReturnDef(nil, node.index(T, node.value '__index'))

    F:addType(FUN)

    local TABLE = node.variable 't'
    TABLE:addField {
        key   = node.value '__index',
        value = node.value(1),
    }

    local CALL = node.call(F, { TABLE })
    local R = CALL.value

    assert(R.value:view() == '1')
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

---@class A6
local mt = {}
mt.__index = mt

obj = setmetatable({}, mt)
    ]]
    vfile:indexAst(ast, 'common')

    assert(node:globalGet('obj').value:view() == 'A')
end
