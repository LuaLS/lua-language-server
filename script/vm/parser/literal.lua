ls.vm.registerRunnerParser('number', function (runner, source)
    ---@cast source LuaParser.Node.Number
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('integer', function (runner, source)
    ---@cast source LuaParser.Node.Integer
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('string', function (runner, source)
    ---@cast source LuaParser.Node.String
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('boolean', function (runner, source)
    ---@cast source LuaParser.Node.Boolean
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('nil', function (runner, source)
    return runner.node.NIL
end)
