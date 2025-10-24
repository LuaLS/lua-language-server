local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local g = node.type '_G'

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        A = 1
    ]]

    local coder = vfile:makeCoder(ast)
    coder:run()

    assert(g:get('A'):view() == '1')
    assert(node:globalGet('A'):viewVariable() == 'A')
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

    local coder = vfile:makeCoder(ast)
    coder:run()

    assert(g:get('A'):view() == '{ B: { C: 1 } }')
    assert(node:globalGet('A', 'B', 'C'):viewVariable() == 'A.B.C')
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

    local coder = vfile:makeCoder(ast)
    coder:run()

    assert(g:get('A'):view() == '{ [1]: { C: 1 } }')
    assert(node:globalGet('A', 1, 'C'):viewVariable() == 'A[1].C')
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

    local coder = vfile:makeCoder(ast)
    coder:run()

    assert(g:get('A'):view() == '{ [unknown]: { C: 1 } }')
    assert(node:globalGet('A', node.UNKNOWN, 'C'):viewVariable() == 'A[unknown].C')
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

    local coder = vfile:makeCoder(ast)
    coder:run()

    assert(g:get('A'):view() == '1')
    assert(node:globalGet('A'):viewVariable() == 'A')
    assert(node:globalGet('A').value:view() == 'unknown')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@alias A 1
    ]]

    local coder = vfile:makeCoder(ast)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

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

    local coder = vfile:makeCoder(ast)
    log.debug(coder.code)
    coder:run()

    assert(node.type('B'):view() == 'B')
    assert(node.type('B').value:view() == '1')
end
