local node = test.scope.node

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
