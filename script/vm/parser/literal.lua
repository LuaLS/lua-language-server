ls.vm.registerRunnerParser('number', function (runner, source)
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('integer', function (runner, source)
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('string', function (runner, source)
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('boolean', function (runner, source)
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('nil', function (runner, source)
    return runner.node.NIL
end)
