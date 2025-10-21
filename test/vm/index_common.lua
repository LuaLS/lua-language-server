local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A = 1
    ]]
    vfile:indexAst(ast, 'common')

    assert(g:get('A'):view() == '1')
    assert(node:globalGet('A'):view() == 'A')
    assert(node:globalGet('A').value:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A.B.C = 1
    ]]
    vfile:indexAst(ast, 'common')

    assert(g:get('A'):view() == 'unknown')
    assert(node:globalGet('A', 'B', 'C'):view() == 'A.B.C')
    assert(node:globalGet('A', 'B', 'C').value:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A[1].C = 1
    ]]
    vfile:indexAst(ast, 'common')

    assert(g:get('A'):view() == 'unknown')
    assert(node:globalGet('A', 1, 'C'):view() == 'A[1].C')
    assert(node:globalGet('A', 1, 'C').value:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A[XXX].C = 1
    ]]
    vfile:indexAst(ast, 'common')

    assert(g:get('A'):view() == 'unknown')
    assert(node:globalGet('A', node.UNKNOWN, 'C'):view() == 'A[unknown].C')
    assert(node:globalGet('A', node.UNKNOWN, 'C').value:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class _G
        ---@field A 1
    ]]
    vfile:indexAst(ast, 'common')

    assert(g:get('A'):view() == '1')
    assert(node:globalGet('A'):view() == 'A')
    assert(node:globalGet('A').value:view() == 'unknown')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A 1
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A 1 | 2 | 3
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '1 | 2 | 3')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A B & C & D
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'B & C & D')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A {
        --- x: number,
        --- y: string,
        --- [number]: boolean,
        ---}
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ x: number, y: string, [number]: boolean }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A [1, 2, 3]
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '[1, 2, 3]')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A table<number, boolean>
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'table<number, boolean>')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A async fun<T1: table, T2>(a: T1, ...: T2)
        ---: T2[]
        ---, desc: string
        ---, ...: T1
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'async fun<T1:table, T2>(a: <T1>, ...: <T2>):(<T2>[], (desc: string), (...: <T1>))')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        local m = {
            x = 1,
            y = 2,
            ['abc'] = 3,
            [10] = 4,
            5,
        }
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ [1]: 5, [10]: 4, abc: 3, x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        B = {}
    ]]
    vfile:indexAst(ast, 'common')

    assert(node:globalGet('B').value:view() == 'A')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        local m = {}

        function m:init()
            self.x = 1
            self.y = 2
        end
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == '{ init: fun(self: A), x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A { x: 1, y: 2 }
        ---@alias B A['x']
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('B'):view() == 'B')
    assert(node.type('B').value:view() == 'A["x"]')
    assert(node.type('B').value.value:view() == '1')
end
