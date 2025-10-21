ls.vm.registerRunnerParser('call', function (runner, source)
    ---@cast source LuaParser.Node.Call

    local funcNode = runner:parse(source.node)
    local call = runner.node.call(funcNode, ls.util.map(source.args, function (argNode)
        return runner:parse(argNode)
    end))

    return call.returns
end)
