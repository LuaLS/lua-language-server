local node = test.scope.node

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        local x = 1
    ]]
    vfile:indexAst(ast, 'common')

    local loc = ast.main.localMap['x']
    local n = vfile:getNode(loc)
    assert(n and n:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        local x = 1
        x = 2
    ]]
    vfile:indexAst(ast, 'common')

    local loc = ast.main.localMap['x']
    local n = vfile:getNode(loc)
    assert(n and n:view() == '1')
end

do
    local vm = ls.vm.create(test.scope)
    node:reset()

    local vfile = vm:createFile('test.lua')
    local ast = ls.parser.compile [[
        ---@type 1
        local x
    ]]
    vfile:indexAst(ast, 'common')

    local loc = ast.main.localMap['x']
    local n = vfile:getNode(loc)
    assert(n and n:view() == '1')
end
