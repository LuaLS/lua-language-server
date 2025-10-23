ls.vm.registerCoderProvider('integer', function (coder, source)
    ---@cast source LuaParser.Node.Integer

    coder:addLine('{key} = node.value({value})' % {
        key = coder:getKey(source),
        value = source.value,
    })
end)

ls.vm.registerCoderProvider('table', function (coder, source)
    ---@cast source LuaParser.Node.Table

    coder:addLine('{key} = node.table()' % {
        key = coder:getKey(source),
    })

    coder:addIndentation(1)
    --TODO
    coder:addIndentation(-1)
end)
