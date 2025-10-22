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

    local I = node.index(A, node.value 'x')
    assert(I:view() == 'A')
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

    local r = f({ __index = 1 })
    ]]

    local F = node.variable 'f'
    local T = node.generic 'T'
    local FUN = node.func()
        : addTypeParam(T)
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

    assert(R:view() == '1')
end

do
    node:reset()
    --[[
    ---@type fun<T>(x: T): T['__index']
    local f

    local mt

    mt.__index = 1

    local r = f(mt)
    ]]

    local F = node.variable 'f'
    local T = node.generic 'T'
    local FUN = node.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, node.index(T, node.value '__index'))

    F:addType(FUN)

    local MT = node.variable 'mt'
    MT:addField {
        key   = node.value '__index',
        value = node.value(1),
    }

    local CALL = node.call(F, { MT })
    local R = CALL.value

    assert(R:view() == '1')
end

do
    node:reset()
    --[[
    ---@type fun<T>(x: T): T['__index']
    local f

    local mt

    mt.__index = mt
    mt.x = 1

    local r = f(mt)
    local v = r.x
    ]]

    local F = node.variable 'f'
    local T = node.generic 'T'
    local FUN = node.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, node.index(T, node.value '__index'))

    F:addType(FUN)

    local MT = node.variable 'mt'
    MT:addField {
        key   = node.value '__index',
        value = MT,
    }
    MT:addField {
        key   = node.value 'x',
        value = node.value(1),
    }

    local CALL = node.call(F, { MT })
    local R = CALL.value
    assert(R:view() == '{ x: 1, __index: {...} }')

    local V = R:get 'x'
    assert(V:view() == '1')
end

do
    node:reset()
    --[[
    ---@type fun(): boolean
    F = xxx

    R = F()
    ]]

    local F = node:globalAdd({
        key = node.value 'F',
    })
    F:addType(node.func()
        : addReturnDef(nil, node.BOOLEAN)
    )
    local R = node.call(F, {}).value
    assert(R:view() == 'boolean')
end

do
    node:reset()
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@type fun(): boolean
F = xxx

R = F()
    ]]
    vfile:indexAst(ast, 'common')

    local R = node:globalGet('R')
    assert(R.value:view() == 'boolean')
end

do
    node:reset()
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@type fun<T>(x: T): T[]
F = xxx

R = F(1)
    ]]
    vfile:indexAst(ast, 'common')

    local R = node:globalGet('R')
    assert(R.value:view() == '1[]')
end

do
    node:reset()
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@return number
function F() end

R = F()
    ]]
    vfile:indexAst(ast, 'common')

    local F = node:globalGet('F')
    assert(F.value:view() == 'fun():number')
    local R = node:globalGet('R')
    assert(R.value:view() == 'number')
end

do
    node:reset()
    local vm = ls.vm.create(test.scope)
    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
---@generic T
---@param x T
---@return T[]
function F(x) end

R = F(1)
    ]]
    vfile:indexAst(ast, 'common')

    local F = node:globalGet('F')
    assert(F.value:view() == 'fun<T>(x: <T>):<T>[]')
    local R = node:globalGet('R')
    assert(R.value:view() == '1[]')
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

    assert(node:globalGet('obj'):view() == 'A')
    assert(node:globalGet('obj'):finalValue():view() == '{ __index: A }')
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

local mt = {}
mt.__index = mt

mt.xxx = 1

obj = setmetatable({}, mt)
value = obj.xxx
    ]]
    vfile:indexAst(ast, 'common')

    assert(node:globalGet('obj'):view() == '1')
    assert(node:globalGet('value'):view() == '1')
end
