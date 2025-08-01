ls.vm.registerRunnerParser('select', function (runner, source)
    ---@cast source LuaParser.Node.Select

    local node = runner:parse(source.value)
    if node.kind ~= 'vararg' then
        return node
    end

    return node:get(source.index)
end)
