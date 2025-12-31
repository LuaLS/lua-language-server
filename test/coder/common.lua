local rt = test.scope.rt

do
    TEST_INDEX [[
        A = 1
    ]]

    local g = rt.type '_G'
    lt.assertEquals(g:get('A'):view(), '1')
    lt.assertEquals(rt:globalGet('A'):viewAsVariable(), 'A')
    lt.assertEquals(rt:globalGet('A').value:view(), '1')
end

do
    TEST_INDEX [[
        A.B.C = 1
    ]]

    local g = rt.type '_G'
    lt.assertEquals(g:get('A'):view(), '{ B: { C: 1 } }')
    lt.assertEquals(rt:globalGet('A', 'B', 'C'):viewAsVariable(), 'A.B.C')
    lt.assertEquals(rt:globalGet('A', 'B', 'C').value:view(), '1')
end

do
    TEST_INDEX [[
        A[1].C = 1
    ]]

    local g = rt.type '_G'
    lt.assertEquals(g:get('A'):view(), '{ [1]: { C: 1 } }')
    lt.assertEquals(rt:globalGet('A', 1, 'C'):viewAsVariable(), 'A[1].C')
    lt.assertEquals(rt:globalGet('A', 1, 'C').value:view(), '1')
end

do
    TEST_INDEX [[
        A[XXX].C = 1
    ]]

    local g = rt.type '_G'
    lt.assertEquals(g:get('A'):view(), '{ [unknown]: { C: 1 } }')
    lt.assertEquals(rt:globalGet('A', rt.UNKNOWN, 'C'):viewAsVariable(), 'A[unknown].C')
    lt.assertEquals(rt:globalGet('A', rt.UNKNOWN, 'C').value:view(), '1')
end

do
    TEST_INDEX [[
        A[func()].C = 1
    ]]

    local g = rt.type '_G'
    lt.assertEquals(g:get('A'):view(), '{ [unknown]: { C: 1 } }')
    lt.assertEquals(rt:globalGet('A', rt.UNKNOWN, 'C'):viewAsVariable(), 'A[unknown].C')
    lt.assertEquals(rt:globalGet('A', rt.UNKNOWN, 'C').value:view(), '1')
end

do
    TEST_INDEX [[
        root = mainPath:parent_path():string()
    ]]
end

do
    TEST_INDEX [[
        ---@class _G
        ---@field A 1
    ]]

    local g = rt.type '_G'
    lt.assertEquals(g:get('A'):view(), '1')
    lt.assertEquals(rt:globalGet('A'):viewAsVariable(), 'A')
    lt.assertEquals(rt:globalGet('A').value:view(), '1')
end

do
    TEST_INDEX [[
        ---@alias A 1
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), '1')
end

do
    TEST_INDEX [[
        ---@alias A number?
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), 'number | nil')
end

do
    TEST_INDEX [[
        ---@alias A 1 | 2 | 3
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), '1 | 2 | 3')
end

do
    TEST_INDEX [[
        ---@alias A B & C & D
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), 'B & C & D')
end

do
    TEST_INDEX [[
        ---@alias A number[]
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), 'number[]')
end

do
    TEST_INDEX [[
        ---@alias A {
        --- x: number,
        --- y: string,
        --- [number]: boolean,
        ---}
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), [[
{
    x: number,
    y: string,
    [number]: boolean,
}]])
end

do
    TEST_INDEX [[
        ---@alias A [1, 2, 3]
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), '[1, 2, 3]')
end

do
    TEST_INDEX [[
        ---@alias A table<number, boolean>
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), 'table<number, boolean>')
end

do
    TEST_INDEX [[
        ---@alias A async fun<T1: table, T2>(a: T1, b?: string, ...: T2)
        ---: T2[]
        ---, desc: string?
        ---, ...: T1
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), 'async fun<T1:table, T2>(a: <T1>, b?: string, ...: <T2>):(<T2>[], (desc: string | nil), (...: <T1>))')
end

do
    TEST_INDEX [[
        ---@class A
        local m = {
            x = 1,
            y = 2,
            ['abc'] = 3,
            [10] = 4,
            5,
        }
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), [[
{
    [1]: 5,
    [10]: 4,
    abc: 3,
    x: 1,
    y: 2,
}]])
end

do
    TEST_INDEX [[
        ---@class A
        B = {}
    ]]

    lt.assertEquals(rt:globalGet('B').value:view(), 'A')
end

do
    rt:reset()
    --[[
        ---@class A
        local m = {}

        function m:init()
            self.x = 1
            self.y = 2
        end
    ]]

    local CA = rt.class 'A'
    local M = rt.variable 'm'
    M:addClass(CA)
    CA:addVariable(M)

    local FUNC = rt.func()
    FUNC:addParamDef('self', M)

    M:addField(rt.field('init', FUNC))

    local SELF = rt.variable 'self'
    SELF:setMasterVariable(M)

    SELF:addField(rt.field('x', rt.value(1)))

    SELF:addField(rt.field('y', rt.value(2)))

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), [[
{
    init: fun(self: A),
    x: 1,
    y: 2,
}]])
end

do
    TEST_INDEX [[
        ---@class A
        local m = {}

        function m:init()
            self.x = 1
            self.y = 2
        end
    ]]

    lt.assertEquals(rt.type('A'):view(), 'A')
    lt.assertEquals(rt.type('A').value:view(), [[
{
    init: fun(self: A),
    x: 1,
    y: 2,
}]])
end

do
    TEST_INDEX [[
        ---@alias A { x: 1, y: 2 }
        ---@alias B A['x']
    ]]

    lt.assertEquals(rt.type('B'):view(), 'B')
    lt.assertEquals(rt.type('B').value:view(), '1')
end

do
    TEST_INDEX [[
        ---@alias A<T> T[]
        ---@alias B A<number>
    ]]

    lt.assertEquals(rt.type('B'):view(), 'B')
    lt.assertEquals(rt.type('B').value:view(), 'number[]')
end

do
    TEST_INDEX [[
        ---@class A<T>
        ---@field data T[]

        ---@alias B A<number>
    ]]

    lt.assertEquals(rt.type('B'):view(), 'B')
    lt.assertEquals(rt.type('B').value:view(), 'A<number>')
    lt.assertEquals(rt.type('B').value.value:view(), '{ data: number[] }')
end

do
    TEST_INDEX [[
        ---@alias A<X, Y> [X, Y]

        ---@alias B<T> A<T, 2>

        ---@alias C B<number>
    ]]

    lt.assertEquals(rt.type('C'):view(), 'C')
    lt.assertEquals(rt.type('C').value:view(), '[number, 2]')
end

do
    TEST_INDEX [[
        ---@class A<X, Y>
        ---@field data [X, Y]

        ---@class B<T>: A<T, 2>
        ---@field extra T[]

        ---@alias C B<number>
    ]]

    lt.assertEquals(rt.type('C'):view(), 'C')
    lt.assertEquals(rt.type('C').value:view(), 'B<number>')
    lt.assertEquals(rt.type('C').value.value:view(), [[
{
    data: [number, 2],
    extra: number[],
}]])
end

do
    TEST_INDEX [[
        local t = {
            insert = 1,
        }
        X = t
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), '{ insert: 1 }')
end

do
    TEST_INDEX [[
        local t = {
            insert = 1,
        }
        X = t.insert
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), '1')
end

do
    TEST_INDEX [[
        local t = {
            l = {
                insert = 1,
            },
        }
        X = t.l.insert
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), '1')
end

do
    TEST_INDEX [[
        ---@class A
        local m = {}
        m.x = 1

        ---@type A
        local n

        V = n.x
    ]]

    lt.assertEquals(rt:globalGet('V'):view(), '1')
end

do
    TEST_INDEX [[
        x, y, z = f1(), f2()
    ]]
end

do
    TEST_INDEX [[
        local x, y, z = f1(), f2()
    ]]
end

do
    TEST_INDEX [[
        local x, y, z = f1()
    ]]
end

do
    TEST_INDEX [[
        a[nil] = 10
    ]]
end

do
    TEST_INDEX [[
    ---@alias f fun<T>(a: T): T[]

    ---@alias r f(number) --> number[]
    ]]

    lt.assertEquals(rt.type('r'):view(), 'r')
    lt.assertEquals(rt.type('r').value:view(), 'f(number)')
    lt.assertEquals(rt.type('r').value.value:view(), 'number[]')
end

do
    TEST_INDEX [[
    ---@alias r X ? 1 : 2
    ]]

    lt.assertEquals(rt.type('r'):view(), 'r')
    lt.assertEquals(rt.type('r').value:view(), '1 | 2')

    do
        local trueNode <close> = rt.alias('X', nil, rt.TRUE)
        lt.assertEquals(rt.type('r').value.value:view(), '1')
    end

    do
        local falseNode <close> = rt.alias('X', nil, rt.FALSE)
        lt.assertEquals(rt.type('r').value.value:view(), '2')
    end
end

do
    TEST_INDEX [[
    local t = { x = 1, y = 2 }

    ---@alias t [ $t['x'], $t['y'] ] --> [1, 2]
    ]]

    lt.assertEquals(rt.type('t'):view(), 't')
    lt.assertEquals(rt.type('t').value:view(), '[1, 2]')
end
