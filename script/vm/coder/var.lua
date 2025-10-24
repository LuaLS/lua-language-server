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
    coder:compile(source.key)
    if source.subtype == 'index' and not source.key.isLiteral then
        coder:addLine('{var} = {last}:getChild({field})' % {
            var   = coder:getKey(source),
            last  = coder:getKey(last),
            field = 'node.UNKNOWN',
        })
    else
        coder:addLine('{var} = {last}:getChild({field})' % {
            var   = coder:getKey(source),
            last  = coder:getKey(last),
            field = coder:getKey(source.key),
        })
    end
end)

ls.vm.registerCoderProvider('fieldid', function (coder, source)
    ---@cast source LuaParser.Node.FieldID
    coder:addLine('{key} = node.value {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
end)

ls.vm.registerCoderProvider('local', function (coder, source)
    ---@cast source LuaParser.Node.Local
    coder:addLine('{key} = node.variable {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
end)

ls.vm.registerCoderProvider('param', function (coder, source)
    ---@cast source LuaParser.Node.Param
    coder:addLine('{key} = node.variable {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })

    if source.isSelf then
        local parentVariable = source.parent.name and source.parent.name.last
        if parentVariable then
            coder:addLine('{parent}:addSubVariable({key})' % {
                parent = coder:getKey(parentVariable),
                key    = coder:getKey(source),
            })
            coder:addDisposer('{parent}:removeSubVariable({key})' % {
                parent = coder:getKey(parentVariable),
                key    = coder:getKey(source),
            })
        end
        return
    end

    local type = 'node.ANY'
    local cat = coder:findMatchedCatParam(source)
    if cat and cat.value then
        type = coder:getKey(cat.value)
    end
    coder:addLine('{key}:addType({type})' % {
        key  = coder:getKey(source),
        type = type,
    })
end)
