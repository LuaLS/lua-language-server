ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    coder:addLine('{key} = {value}:shadow()' % {
        key = coder:getKey(source),
        value = coder:makeVarKey(source),
    })

    if source.value then
        coder:getTracer():appendVar(source)
    else
        coder:getTracer():appendRef(source)
    end
end)

ls.vm.registerCoderProvider('field', function (coder, source)
    ---@cast source LuaParser.Node.Field
    local last = source.last
    if not last then
        return
    end

    if source.subtype == 'index' then
        if source.key then
            coder:compile(source.key)
        end
    end

    coder:compile(last)

    coder:addLine('{var} = {value}:shadow()' % {
        var   = coder:getKey(source),
        value = coder:makeVarKey(source),
    })

    if source.value then
        coder:getTracer():appendVar(source)
    else
        coder:getTracer():appendRef(source)
    end

    if source.subtype ~= 'index' then
        -- 字段的id即为整个字段
        if source.key then
            coder:addLine('{r2} = {r1}' % {
                r1 = coder:getKey(source),
                r2 = coder:getKey(source.key),
            })
        end
    end

    local sourceName = coder:getVarName(source)
    if sourceName and source.key then
        local keyLiteral

        if source.subtype == 'field' or source.subtype == 'method' then
            keyLiteral = source.key.id
        elseif source.subtype == 'index' then
            if source.key.isLiteral then
                keyLiteral = source.key.value
            end
        end

        if keyLiteral then
            coder.parentMap[sourceName] = { coder:getVarName(last), keyLiteral }
        end
    end
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
    coder:getTracer():appendVar(source)
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

    coder:getTracer():appendVar(source)

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
