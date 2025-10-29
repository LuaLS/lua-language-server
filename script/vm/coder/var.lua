ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    if source.loc then
        coder:addLine('{key} = {loc}' % {
            key = coder:getKey(source),
            loc = coder:getKey(source.loc),
        })
    else
        coder:addLine('{key} = rt:globalGet {name:q}' % {
            key = coder:getKey(source),
            name = source.id,
        })
    end
    coder:addLine('{variable} = {key}' % {
        variable = coder:getVariableKey(source),
        key      = coder:getKey(source),
    })
end)

ls.vm.registerCoderProvider('field', function (coder, source)
    ---@cast source LuaParser.Node.Field
    local last = source.last
    if not last then
        return
    end

    coder:compile(last)
    coder:compile(source.key)
    local isGetVariable, isComplexKey
    if source.next or source.value then
        isGetVariable = true
    end
    if source.subtype == 'index' and not source.key.isLiteral then
        isComplexKey = true
    end

    coder:addLine('{var} = {last}:getChild({field})' % {
        var    = coder:getKey(source),
        last   = coder:getKey(last),
        field  = isComplexKey and 'rt.UNKNOWN' or coder:getKey(source.key),
    })
    coder:addLine('{variable} = {var}' % {
        variable = coder:getVariableKey(source),
        var      = coder:getKey(source),
    })
end)

ls.vm.registerCoderProvider('fieldid', function (coder, source)
    ---@cast source LuaParser.Node.FieldID
    coder:addLine('{key} = rt.value {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
end)

ls.vm.registerCoderProvider('local', function (coder, source)
    ---@cast source LuaParser.Node.Local
    coder:addLine('{key} = rt.variable {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
    coder:addLine('{variable} = {key}' % {
        variable = coder:getVariableKey(source),
        key      = coder:getKey(source),
    })
end)

ls.vm.registerCoderProvider('param', function (coder, source)
    ---@cast source LuaParser.Node.Param
    coder:addLine('{key} = rt.variable {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
    coder:addLine('{variable} = {key}' % {
        variable = coder:getVariableKey(source),
        key      = coder:getKey(source),
    })

    if source.isSelf then
        local parentVariable = source.parent.name and source.parent.name.last
        if parentVariable then
            coder:addLine('{key}:setMasterVariable({parent})' % {
                parent = coder:getKey(parentVariable),
                key    = coder:getKey(source),
            })
        end
        return
    end

    local type = 'rt.ANY'
    local cat = coder:findMatchedCatParam(source)
    if cat and cat.value then
        type = coder:getKey(cat.value)
    end
    coder:addLine('{key}:addType({type})' % {
        key  = coder:getKey(source),
        type = type,
    })
end)
