ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    local value = coder.flow:getVarKey(source)
    if not value then
        if source.loc then
            value = coder:getKey(source.loc)
        else
            value = 'rt:globalGet({%q})' % { source.id }
        end
    end
    coder:addLine('{key} = {value}{shadow}' % {
        key = coder:getKey(source),
        value = value,
        shadow = source.value and ':shadow()' or '',
    })
    if source.value then
        coder.flow:setVarKey(source, coder:getKey(source))
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

    if not source.value then
        -- 有 value 的情况在 assign 里处理
        coder:compile(last)
    end
    local fieldCode = coder:makeFieldCode(source.key)
    if not fieldCode then
        fieldCode = 'rt.UNKNOWN'
        coder:compile(source.key)
    end

    local value =  coder.flow:getVarKey(source)
                or '{last}:getChild({field})' % {
                    last  = coder:getKey(last),
                    field = fieldCode,
                }

    coder:addLine('{var} = {value}{shadow}' % {
        var    = coder:getKey(source),
        value  = value,
        shadow = source.value and ':shadow()' or '',
    })
    coder:addLine('{variable} = {var}' % {
        variable = coder:getVariableKey(source),
        var      = coder:getKey(source),
    })
    if source.value then
        coder.flow:setVarKey(source, coder:getKey(source))
    end
    if fieldCode == 'rt.UNKNOWN' then
        return
    end
    coder:addLine('{r2} = {r1}' % {
        r1 = coder:getKey(source),
        r2 = coder:getKey(source.key),
    })
    coder:addLine('{v2} = {v1}' % {
        v1 = coder:getVariableKey(source),
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
