local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        ---@field x number
        ---@field y number
        ---@field z number
    ]]

    vfile:indexAst(ast, 'meta')

    assert(node.type('A').value:view() == '{ x: number, y: number, z: number }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        A = {}

        A.x = 1
        A.y = 2
    ]]

    vfile:indexAst(ast, 'meta')

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        A.B = {}

        A.B.x = 1
        A.B.y = 2
    ]]

    vfile:indexAst(ast, 'meta')

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@class A
        local A = {}

        A.x = 1
        A.y = 2
    ]]

    vfile:indexAst(ast, 'meta')

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        local A = {}

        ---@class A
        A.B = {}

        A.B.x = 1
        A.B.y = 2
    ]]

    vfile:indexAst(ast, 'meta')

    assert(node.type('A').value:view() == '{ x: 1, y: 2 }')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        function type(o)
        end
    ]]
    vfile:indexAst(ast, 'meta')

    assert(node:globalGet('type').value:view() == 'fun(o: any)')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@param o table
        ---@return string
        function type(o)
        end
    ]]
    vfile:indexAst(ast, 'meta')

    assert(node:globalGet('type').value:view() == 'fun(o: table):string')
end
