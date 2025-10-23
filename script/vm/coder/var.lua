ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    if source.loc then
        coder:addLine('{key} = {loc}' % {
            key = coder:getKey(source),
            loc = coder:getKey(source.loc),
        })
    else
        coder:addLine('{key} = node:globalGet {name:q}' % {
            key = coder:getKey(source),
            name = source.id,
        })
    end
end)

ls.vm.registerCoderProvider('field', function (coder, source)
    ---@cast source LuaParser.Node.Field
    local last = source.last
    if not last then
        return
    end

    coder:compile(last)
    coder:addLine('{var} = {last}:getChild({field})' % {
        var   = coder:getKey(source),
        last  = coder:getKey(last),
        field = coder:makeFieldCode(source),
    })
end)

ls.vm.registerCoderProvider('local', function (coder, source)
    ---@cast source LuaParser.Node.Local
    coder:addLine('{key} = node.variable {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
end)
