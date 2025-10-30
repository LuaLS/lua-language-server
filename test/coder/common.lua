local rt = test.scope.rt

do
    TEST_INDEX [[
        A = 1
    ]]

    local g = rt.type '_G'
    assert(g:get('A'):view() == '1')
    assert(rt:globalGet('A'):viewAsVariable() == 'A')
    assert(rt:globalGet('A').value:view() == '1')
end

do
    TEST_INDEX [[
        A.B.C = 1
    ]]

    local g = rt.type '_G'
    assert(g:get('A'):view() == '{ B: { C: 1 } }')
    assert(rt:globalGet('A', 'B', 'C'):viewAsVariable() == 'A.B.C')
    assert(rt:globalGet('A', 'B', 'C').value:view() == '1')
end

do
    TEST_INDEX [[
        A[1].C = 1
    ]]

    local g = rt.type '_G'
    assert(g:get('A'):view() == '{ [1]: { C: 1 } }')
    assert(rt:globalGet('A', 1, 'C'):viewAsVariable() == 'A[1].C')
    assert(rt:globalGet('A', 1, 'C').value:view() == '1')
end

do
    TEST_INDEX [[
        A[XXX].C = 1
    ]]

    local g = rt.type '_G'
    assert(g:get('A'):view() == '{ [unknown]: { C: 1 } }')
    assert(rt:globalGet('A', rt.UNKNOWN, 'C'):viewAsVariable() == 'A[unknown].C')
    assert(rt:globalGet('A', rt.UNKNOWN, 'C').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@class _G
        ---@field A 1
    ]]

    local g = rt.type '_G'
    assert(g:get('A'):view() == '1')
    assert(rt:globalGet('A'):viewAsVariable() == 'A')
    assert(rt:globalGet('A').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@alias A 1
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@alias A number?
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == 'number | nil')
end

do
    TEST_INDEX [[
        ---@alias A 1 | 2 | 3
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '1 | 2 | 3')
end

do
    TEST_INDEX [[
        ---@alias A B & C & D
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == 'B & C & D')
end

do
    TEST_INDEX [[
        ---@alias A number[]
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == 'number[]')
end

do
    TEST_INDEX [[
        ---@alias A {
        --- x: number,
        --- y: string,
        --- [number]: boolean,
        ---}
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '{ x: number, y: string, [number]: boolean }')
end

do
    TEST_INDEX [[
        ---@alias A [1, 2, 3]
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '[1, 2, 3]')
end

do
    TEST_INDEX [[
        ---@alias A table<number, boolean>
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == 'table<number, boolean>')
end

do
    TEST_INDEX [[
        ---@alias A async fun<T1: table, T2>(a: T1, b?: string, ...: T2)
        ---: T2[]
        ---, desc: string?
        ---, ...: T1
    ]]

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == 'async fun<T1:table, T2>(a: <T1>, b?: string, ...: <T2>):(<T2>[], (desc: string | nil), (...: <T1>))')
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

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '{ [1]: 5, [10]: 4, abc: 3, x: 1, y: 2 }')
end

do
    TEST_INDEX [[
        ---@class A
        B = {}
    ]]

    assert(rt:globalGet('B').value:view() == 'A')
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

    M:addField {
        key   = rt.value 'init',
        value = FUNC,
    }

    local SELF = rt.variable 'self'
    SELF:setMasterVariable(M)

    SELF:addField {
        key   = rt.value 'x',
        value = rt.value(1),
    }

    SELF:addField {
        key   = rt.value 'y',
        value = rt.value(2),
    }

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '{ init: fun(self: A), x: 1, y: 2 }')
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

    assert(rt.type('A'):view() == 'A')
    assert(rt.type('A').value:view() == '{ init: fun(self: A), x: 1, y: 2 }')
end

do
    TEST_INDEX [[
        ---@alias A { x: 1, y: 2 }
        ---@alias B A['x']
    ]]

    assert(rt.type('B'):view() == 'B')
    assert(rt.type('B').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@alias A<T> T[]
        ---@alias B A<number>
    ]]

    assert(rt.type('B'):view() == 'B')
    assert(rt.type('B').value:view() == 'A<number>')
    assert(rt.type('B').value.value:view() == 'number[]')
end

do
    TEST_INDEX [[
        ---@class A<T>
        ---@field data T[]

        ---@alias B A<number>
    ]]

    assert(rt.type('B'):view() == 'B')
    assert(rt.type('B').value:view() == 'A<number>')
    assert(rt.type('B').value.value:view() == '{ data: number[] }')
end

do
    TEST_INDEX [[
        ---@alias A<X, Y> [X, Y]

        ---@alias B<T> A<T, 2>

        ---@alias C B<number>
    ]]

    assert(rt.type('C'):view() == 'C')
    assert(rt.type('C').value:view() == 'B<number>')
    assert(rt.type('C').value.value:view() == '[number, 2]')
end

do
    TEST_INDEX [[
        ---@class A<X, Y>
        ---@field data [X, Y]

        ---@class B<T>: A<T, 2>
        ---@field extra T[]

        ---@alias C B<number>
    ]]

    assert(rt.type('C'):view() == 'C')
    assert(rt.type('C').value:view() == 'B<number>')
    assert(rt.type('C').value.value:view() == '{ data: [number, 2], extra: number[] }')
end

do
    TEST_INDEX [[
        local t = {
            insert = 1,
        }
        X = t
    ]]

    assert(rt:globalGet('X'):view() == '{ insert: 1 }')
end

do
    TEST_INDEX [[
        local t = {
            insert = 1,
        }
        X = t.insert
    ]]

    assert(rt:globalGet('X'):view() == '1')
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

    assert(rt:globalGet('X'):view() == '1')
end
