local rt = test.scope.rt

do
    TEST_INDEX [[
---@alias f<T> T[]
---@alias A f<number>
    ]]

    assert(rt.type('A').value:view() == 'f<number>')
    assert(rt.type('A').value.value:view() == 'number[]')
end

do
    TEST_INDEX [[
---@alias f<T> T['__index']
---@alias A f<{ __index: 1 }>
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == 'f<{ __index: 1 }>')
    assert(rt.type('A').value.value:view() == '1')
end

do
    rt:reset()
    --[[
    ---@class A
    local t

    t.x = t

    --> A['x']
    ]]

    local A = rt.type 'A'
    local CA = rt.class 'A'

    local V = rt.variable 't'
    CA:addVariable(V)
    V:addClass(CA)

    V:addField {
        key   = rt.value 'x',
        value = V,
    }

    local r = A:get 'x'
    assert(r:view() == 'A')

    local I = rt.index(A, rt.value 'x')
    assert(I:view() == 'A')
end

do
    rt:reset()
    --[[
    local t

    t.x = 1

    --> t['x']
    ]]

    local V = rt.variable 't'

    V:addField {
        key   = rt.value 'x',
        value = rt.value(1),
    }

    local r = V:get 'x'
    assert(r:view() == '1')
end

do
    rt:reset()
    --[[
    ---@type fun<T>(x: T): T['__index']
    local f

    local r = f({ __index = 1 })
    ]]

    local F = rt.variable 'f'
    local T = rt.generic 'T'
    local FUN = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, rt.index(T, rt.value '__index'))

    F:addType(FUN)

    local TABLE = rt.variable 't'
    TABLE:addField {
        key   = rt.value '__index',
        value = rt.value(1),
    }

    local FCALL = rt.fcall(F, { TABLE })
    local R = FCALL.value

    assert(R:view() == '1')
end

do
    rt:reset()
    --[[
    ---@type fun<T>(x: T): T['__index']
    local f

    local mt

    mt.__index = 1

    local r = f(mt)
    ]]

    local F = rt.variable 'f'
    local T = rt.generic 'T'
    local FUN = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, rt.index(T, rt.value '__index'))

    F:addType(FUN)

    local MT = rt.variable 'mt'
    MT:addField {
        key   = rt.value '__index',
        value = rt.value(1),
    }

    local FCALL = rt.fcall(F, { MT })
    local R = FCALL.value

    assert(R:view() == '1')
end

do
    rt:reset()
    --[[
    ---@type fun<T>(x: T): T['__index']
    local f

    local mt

    mt.__index = mt
    mt.x = 1

    local r = f(mt)
    local v = r.x
    ]]

    local F = rt.variable 'f'
    local T = rt.generic 'T'
    local FUN = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, rt.index(T, rt.value '__index'))

    F:addType(FUN)

    local MT = rt.variable 'mt'
    MT:addField {
        key   = rt.value '__index',
        value = MT,
    }
    MT:addField {
        key   = rt.value 'x',
        value = rt.value(1),
    }

    local FCALL = rt.fcall(F, { MT })
    local R = FCALL.value
    assert(R:view() == '{ x: 1, __index: {...} }')

    local V = R:get 'x'
    assert(V:view() == '1')
end

do
    rt:reset()
    --[[
    ---@type fun(): boolean, number
    F = xxx

    R1, R2 = F()
    ]]

    local F = rt:globalAdd({
        key = rt.value 'F',
    })
    F:addType(rt.func()
        : addReturnDef(nil, rt.BOOLEAN)
        : addReturnDef(nil, rt.NUMBER)
    )
    local FCALL = rt.fcall(F, {})
    local R1 = FCALL.returns:select(1)
    local R2 = FCALL.returns:select(2)
    assert(R1:view() == 'boolean')
    assert(R2:view() == 'number')
end

do
    TEST_INDEX [[
---@type fun(): boolean, number
F = xxx

R1, R2 = F()
    ]]

    local R1 = rt:globalGet('R1')
    local R2 = rt:globalGet('R2')
    assert(R1.value:view() == 'boolean')
    assert(R2.value:view() == 'number')
end

do
    TEST_INDEX [[
---@type fun<T>(x: T): T[]
F = xxx

R = F(1)
    ]]

    local R = rt:globalGet('R')
    assert(R.value:view() == '1[]')
end

do
    TEST_INDEX [[
---@return number
function F() end

R = F()
    ]]

    local F = rt:globalGet('F')
    assert(F.value:view() == 'fun():number')
    local R = rt:globalGet('R')
    assert(R.value:view() == 'number')
end

do
    TEST_INDEX [[
---@generic T
---@param x T
---@return T[]
function F(x) end

R = F(1)
    ]]

    local F = rt:globalGet('F')
    assert(F.value:view() == 'fun<T>(x: <T>):<T>[]')
    local R = rt:globalGet('R')
    assert(R.value:view() == '1[]')
end

do
    TEST_INDEX [[
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

    assert(rt:globalGet('obj'):view() == 'A')
    assert(rt:globalGet('obj'):finalValue():view() == '{ __index: A }')
end

do -- 变量作为参数时要转换为类型
    rt:reset()

    local T = rt.generic 'T'
    local FUNC = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, T)

    local A = rt.variable('A')

    A:addField {
        key   = rt.value 'x',
        value = rt.value(1),
    }

    local FCALL = rt.fcall(FUNC, { A })
    local R = FCALL.value
    assert(R:view() == '{ x: 1 }')
end

do
    rt:reset()
    --[[
    ---@type { x: number }
    local t

    B = t.x
    ]]

    local T = rt.variable 't'
    T:addType(rt.table {
        x = rt.NUMBER,
    })

    assert(T:view() == '{ x: number }')
    local X = T:getChild('x')
    assert(X:view() == 'number')
end

do
    TEST_INDEX [[
    ---@type { x: number }
    local t

    B = t.x
    ]]

    assert(rt:globalGet('B').value:view() == 'number')
end

do
    TEST_INDEX [[
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

    assert(rt:globalGet('obj'):view() == '{ xxx: 1, __index: {...} }')
    assert(rt:globalGet('value'):view() == '1')
end
