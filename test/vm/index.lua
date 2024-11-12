local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local a = node.type 'A'
    assert(a.value:view() == 'A')

    local vfile = vm:createFile('test.lua')
    vfile.contribute:commit {
        kind = 'classfield',
        className = 'A',
        field = {
            key = node.value 'x',
            value = node.NUMBER,
        }
    }

    assert(a.value:view() == '{ x: number }')

    vfile:resetContribute()
    assert(a.value:view() == 'A')

    vfile.contribute:commit {
        kind = 'classfield',
        className = 'A',
        field = {
            key = node.value 'x',
            value = node.STRING,
        }
    }
    assert(a.value:view() == '{ x: string }')

    vfile:remove()
    assert(a.value:view() == 'A')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'
    assert(g.value:view() == '{}')
    assert(node:globalGet('x').value:view() == 'unknown')

    local vfile = vm:createFile('test.lua')
    vfile.contribute:commit {
        kind = 'global',
        field = {
            key = node.value 'x',
            value = node.NUMBER,
        }
    }

    assert(g.value:view() == '{ x: number }')
    assert(node:globalGet('x').value:view() == 'number')

    vfile:resetContribute()
    assert(g.value:view() == '{}')

    vfile.contribute:commit {
        kind = 'global',
        field = {
            key = node.value 'x',
            value = node.STRING,
        }
    }
    assert(g.value:view() == '{ x: string }')
    assert(node:globalGet('x').value:view() == 'string')

    vfile:remove()
    assert(g.value:view() == '{}')
    assert(node:globalGet('x').value:view() == 'unknown')
end

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
        ---@alias A string[3][4]
    ]]
    vfile:indexAst(ast, 'common')

    assert(node.type('A'):view() == 'A')
    assert(node.type('A').value:view() == 'string[3][4]')
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
    assert(node.type('A').value:view() == 'async fun<T1:table, T2>(a: T1, ...: T2):(T2[], (desc: string), (...: T1))')
end
