local node = test.scope.node

do
    TEST_INDEX [[
        A = 1
    ]]

    local g = node.type '_G'
    assert(g:get('A'):view() == '1')
    assert(node:globalGet('A'):viewVariable() == 'A')
    assert(node:globalGet('A').value:view() == '1')
end

do
    TEST_INDEX [[
        A.B.C = 1
    ]]

    local g = node.type '_G'
    assert(g:get('A'):view() == '{ B: { C: 1 } }')
    assert(node:globalGet('A', 'B', 'C'):viewVariable() == 'A.B.C')
    assert(node:globalGet('A', 'B', 'C').value:view() == '1')
end

do
    TEST_INDEX [[
        A[1].C = 1
    ]]

    local g = node.type '_G'
    assert(g:get('A'):view() == '{ [1]: { C: 1 } }')
    assert(node:globalGet('A', 1, 'C'):viewVariable() == 'A[1].C')
    assert(node:globalGet('A', 1, 'C').value:view() == '1')
end

do
    TEST_INDEX [[
        A[XXX].C = 1
    ]]

    local g = node.type '_G'
    assert(g:get('A'):view() == '{ [unknown]: { C: 1 } }')
    assert(node:globalGet('A', node.UNKNOWN, 'C'):viewVariable() == 'A[unknown].C')
    assert(node:globalGet('A', node.UNKNOWN, 'C').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@class _G
        ---@field A 1
    ]]

    local g = node.type '_G'
    assert(g:get('A'):view() == '1')
    assert(node:globalGet('A'):viewVariable() == 'A')
    assert(node:globalGet('A').value:view() == 'unknown')
end

do
    TEST_INDEX [[
        ---@alias A 1
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@alias A number?
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'number | nil')
end

do
    TEST_INDEX [[
        ---@alias A 1 | 2 | 3
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '1 | 2 | 3')
end

do
    TEST_INDEX [[
        ---@alias A B & C & D
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'B & C & D')
end

do
    TEST_INDEX [[
        ---@alias A number[]
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'number[]')
end

do
    TEST_INDEX [[
        ---@alias A {
        --- x: number,
        --- y: string,
        --- [number]: boolean,
        ---}
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ x: number, y: string, [number]: boolean }')
end

do
    TEST_INDEX [[
        ---@alias A [1, 2, 3]
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '[1, 2, 3]')
end

do
    TEST_INDEX [[
        ---@alias A table<number, boolean>
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'table<number, boolean>')
end

do
    TEST_INDEX [[
        ---@alias A async fun<T1: table, T2>(a: T1, b?: string, ...: T2)
        ---: T2[]
        ---, desc: string?
        ---, ...: T1
    ]]

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'async fun<T1:table, T2>(a: <T1>, b?: string, ...: <T2>):(<T2>[], (desc: string | nil), (...: <T1>))')
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

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ [1]: 5, [10]: 4, abc: 3, x: 1, y: 2 }')
end

do
    TEST_INDEX [[
        ---@class A
        B = {}
    ]]

    assert(node:globalGet('B').value:view() == 'A')
end

do
    node:reset()
    --[[
        ---@class A
        local m = {}

        function m:init()
            self.x = 1
            self.y = 2
        end
    ]]

    local CA = node.class 'A'
    local M = node.variable 'm'
    M:addClass(CA)
    CA:addVariable(M)

    local FUNC = node.func()
    FUNC:addParamDef('self', M)

    M:addField {
        key   = node.value 'init',
        value = FUNC,
    }

    local SELF = node.variable 'self'
    M:addSubVariable(SELF)

    SELF:addField {
        key   = node.value 'x',
        value = node.value(1),
    }

    SELF:addField {
        key   = node.value 'y',
        value = node.value(2),
    }

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ init: fun(self: A), x: 1, y: 2 }')
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

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ init: fun(self: A), x: 1, y: 2 }')
end

do
    TEST_INDEX [[
        ---@alias A { x: 1, y: 2 }
        ---@alias B A['x']
    ]]

    assert(node.type('B'):view() == 'B')
    assert(node.type('B').value:view() == '1')
end

do
    TEST_INDEX [[
        ---@alias A<T> T[]
        ---@alias B A<number>
    ]]

    assert(node.type('B'):view() == 'B')
    assert(node.type('B').value:view() == 'A<number>')
    assert(node.type('B').value.value:view() == 'number[]')
end

do
    TEST_INDEX [[
        ---@class A<T>
        ---@field data T[]

        ---@alias B A<number>
    ]]

    assert(node.type('B'):view() == 'B')
    assert(node.type('B').value:view() == 'A<number>')
    assert(node.type('B').value.value:view() == '{ data: number[] }')
end

do
    TEST_INDEX [[
        ---@alias A<X, Y> [X, Y]

        ---@alias B<T> A<T, 2>

        ---@alias C B<number>
    ]]

    assert(node.type('C'):view() == 'C')
    assert(node.type('C').value:view() == 'B<number>')
    assert(node.type('C').value.value:view() == '[number, 2]')
end

do
    TEST_INDEX [[
        ---@class A<X, Y>
        ---@field data [X, Y]

        ---@class B<T>: A<T, 2>
        ---@field extra T[]

        ---@alias C B<number>
    ]]

    assert(node.type('C'):view() == 'C')
    assert(node.type('C').value:view() == 'B<number>')
    assert(node.type('C').value.value:view() == '{ data: [number, 2], extra: number[] }')
end
