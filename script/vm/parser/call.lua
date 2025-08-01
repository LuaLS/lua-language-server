ls.vm.registerRunnerParser('call', function (runner, source)
    ---@cast source LuaParser.Node.Call

    local funcNode = runner:parse(source.node).solve

    local return1 = {}

    for f in funcNode:each 'function' do
        ---@cast f Node.Function
        return1[#return1+1] = f:getReturn(1)
    end

    return runner.node.union(return1)
end)
