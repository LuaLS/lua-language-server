local rt = test.scope.rt

do
    TEST_INDEX [[
---@alias f<T> T[]
---@alias A f<number>
    ]]

    lt.assertEquals(rt.type('A').value:view(), 'number[]')
end

do
    TEST_INDEX [[
---@alias f<T> T['__index']
---@alias A f<{ __index: 1 }>
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), '1')
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

    V:addField(rt.field('x', V))

    local r = A:get 'x'
    lt.assertEquals(r:view(), 'A')

    local I = rt.index(A, rt.value 'x')
    lt.assertEquals(I:view(), 'A')
end

do
    rt:reset()
    --[[
    local t

    t.x = 1

    --> t['x']
    ]]

    local V = rt.variable 't'

    V:addField(rt.field('x', rt.value(1)))

    local r = V:get 'x'
    lt.assertEquals(r:view(), '1')
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
    TABLE:addField(rt.field('__index', rt.value(1)))

    local FCALL = rt.fcall(F, { TABLE })
    local R = FCALL.value

    lt.assertEquals(R:view(), '1')
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
    MT:addField(rt.field('__index', rt.value(1)))

    local FCALL = rt.fcall(F, { MT })
    local R = FCALL.value

    lt.assertEquals(R:view(), '1')
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
    MT:addField(rt.field('__index', MT))
    MT:addField(rt.field('x', rt.value(1)))

    local FCALL = rt.fcall(F, { MT })
    local R = FCALL.value
    lt.assertEquals(R:view(), [[
{
    x: 1,
    __index: { ... },
}]])

    local V = R:get 'x'
    lt.assertEquals(V:view(), '1')
end

do
    rt:reset()
    --[[
    ---@type fun(): boolean, number
    F = xxx

    R1, R2 = F()
    ]]

    local F = rt:globalAdd(rt.field('F'))
    F:addType(rt.func()
        : addReturnDef(nil, rt.BOOLEAN)
        : addReturnDef(nil, rt.NUMBER)
    )
    local FCALL = rt.fcall(F, {})
    local R1 = FCALL.returns:select(1)
    local R2 = FCALL.returns:select(2)
    lt.assertEquals(R1:view(), 'boolean')
    lt.assertEquals(R2:view(), 'number')
end

do
    TEST_INDEX [[
---@type fun(): boolean, number
F = xxx

R1, R2 = F()
    ]]

    local R1 = rt:globalGet('R1')
    local R2 = rt:globalGet('R2')
    lt.assertEquals(R1.value:view(), 'boolean')
    lt.assertEquals(R2.value:view(), 'number')
end

do
    TEST_INDEX [[
---@type fun<T>(x: T): T[]
F = xxx

R = F(1)
    ]]

    local R = rt:globalGet('R')
    lt.assertEquals(R.value:view(), '1[]')
end

do
    TEST_INDEX [[
---@return number
function F() end

R = F()
    ]]

    local F = rt:globalGet('F')
    lt.assertEquals(F.value:view(), 'fun():number')
    local R = rt:globalGet('R')
    lt.assertEquals(R.value:view(), 'number')
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
    lt.assertEquals(F.value:view(), 'fun<T>(x: <T>):<T>[]')
    local R = rt:globalGet('R')
    lt.assertEquals(R.value:view(), '1[]')
end

do
    rt:reset()
    --[[
    ---@class A
    local mt = {}
    mt.__index = mt

    mt['__index'] --> A
    ]]

    local A = rt.class 'A'
    local MT = rt.variable 'mt'
    A:addVariable(MT)
    MT:addClass(A)

    MT:addAssign(rt.field('mt', rt.table()))
    MT:addField(rt.field('__index', MT))

    local R = rt.index(MT, rt.value '__index')
    lt.assertEquals(R:view(), 'A')
    lt.assertEquals(R:finalValue():view(), '{ __index: A }')
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

    lt.assertEquals(rt:globalGet('obj'):view(), 'A')
    lt.assertEquals(rt:globalGet('obj'):finalValue():view(), '{ __index: A }')
end

do -- 变量作为参数时要转换为类型
    rt:reset()

    local T = rt.generic 'T'
    local FUNC = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addReturnDef(nil, T)

    local A = rt.variable('A')

    A:addField(rt.field('x', rt.value(1)))

    local FCALL = rt.fcall(FUNC, { A })
    local R = FCALL.value
    lt.assertEquals(R:view(), '{ x: 1 }')
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

    lt.assertEquals(T:view(), '{ x: number }')
    local X = T:getChild('x')
    lt.assertEquals(X:view(), 'number')
end

do
    TEST_INDEX [[
    ---@type { x: number }
    local t

    B = t.x
    ]]

    lt.assertEquals(rt:globalGet('B').value:view(), 'number')
end

do
    TEST_INDEX [[
local mt = {}
mt.__index = mt

mt.xxx = 1

MT = mt
    ]]

    lt.assertEquals(rt:globalGet('MT'):view(), [[
{
    xxx: 1,
    __index: { ... },
}]])
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

    lt.assertEquals(rt:globalGet('obj'):view(), [[
{
    xxx: 1,
    __index: { ... },
}]])
    lt.assertEquals(rt:globalGet('value'):view(), '1')
end
