ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    if source.loc then
        coder:addLine('{key} = {loc}' % {
            key = coder:getKey(source),
            loc = coder:getKey(source.loc),
        })
    else
        coder:addLine('{key} = rt:globalGet {name%q}' % {
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
    local fieldCode = coder:makeFieldCode(source.key)
    if not fieldCode then
        fieldCode = 'rt.UNKNOWN'
        coder:compile(source.key)
    end

    coder:addLine('{var} = {last}:getChild({field})' % {
        var    = coder:getKey(source),
        last   = coder:getKey(last),
        field  = fieldCode,
    })
    coder:addLine('{variable} = {var}' % {
        variable = coder:getVariableKey(source),
        var      = coder:getKey(source),
    })
    if fieldCode == 'rt.UNKNOWN' then
        return
    end
    coder:addLine('{r2}, {v2} = {r1}, {v1}' % {
        r1 = coder:getKey(source),
        v1 = coder:getVariableKey(source),
        r2 = coder:getKey(source.key),
        v2 = coder:getVariableKey(source.key),
    })
end)

ls.vm.registerCoderProvider('local', function (coder, source)
    ---@cast source LuaParser.Node.Local
    coder:addLine('{key} = rt.variable {name%q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
    coder:addLine('{varKey}:setLocation {location}' % {
        varKey   = coder:getKey(source),
        location = coder:makeLocationCode(source),
    })
    coder:addLine('{variable} = {key}' % {
        variable = coder:getVariableKey(source),
        key      = coder:getKey(source),
    })
end)

ls.vm.registerCoderProvider('param', function (coder, source)
    ---@cast source LuaParser.Node.Param
    coder:addLine('{key} = rt.variable {name%q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
    coder:addLine('{varKey}:setLocation {location}' % {
        varKey   = coder:getKey(source),
        location = coder:makeLocationCode(source),
    })
    coder:addLine('{variable} = {key}' % {
        variable = coder:getVariableKey(source),
        key      = coder:getKey(source),
    })

    local looksLikeSelf, parentVariable = coder:looksLikeSelf(source)

    if looksLikeSelf then
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
