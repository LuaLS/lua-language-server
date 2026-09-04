ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    coder:addLine('{key} = {value}:shadow()' % {
        key = coder:getKey(source),
        value = coder:makeVarKey(source),
    })

    if source.env then
        local sourceName = coder:getVarName(source)
        if sourceName then
            coder.parentMap[sourceName] = { coder:getVarName(source.env), source.id, true }
        end
    end

    if source.value then
        coder:getTracer():appendVar(source)
    else
        coder:getTracer():appendRef(source)
        coder:addLine('{key}:addUsage {location}' % {
            key      = coder:getKey(source),
            location = coder:makeLocationCode(source),
        })
        coder:addDisposer('{key}:removeUsage {location}' % {
            key      = coder:getKey(source),
            location = coder:makeLocationCode(source),
        })
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
        coder:addLine('{var}:addUsage {location}' % {
            var      = coder:getKey(source),
            location = coder:makeLocationCode(source),
        })
        coder:addDisposer('{var}:removeUsage {location}' % {
            var      = coder:getKey(source),
            location = coder:makeLocationCode(source),
        })
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

        if source.subtype == 'field' then
            keyLiteral = source.key.id
        elseif source.subtype == 'method' then
            keyLiteral = source.key.id
            coder:addLine('{var}:setMethod()' % {
                var = coder:getKey(source),
            })
        elseif source.subtype == 'index' then
            if source.key.isLiteral then
                keyLiteral = source.key.value
            end
        end

        if keyLiteral then
            coder.parentMap[sourceName] = { coder:getVarName(last), keyLiteral }
        end
    end

    -- 可选链访问（?. ?: ?[）：值为 nil | 字段值
    if source.safe then
        coder:addLine('{var}:setOptional()' % {
            var = coder:getKey(source),
        })
    end
end)

ls.vm.registerCoderProvider('local', function (coder, source)
    ---@cast source LuaParser.Node.Local
    if source.isVarargTable then
        coder:addLine('{key} = rt.table():addField(rt.field(rt.INTEGER, rt.ANY)):addField(rt.field(rt.value("n"), rt.INTEGER))' % {
            key = coder:getKey(source),
        })
        coder:addLine('{varKey}:setLocation {location}' % {
            varKey   = coder:getKey(source),
            location = coder:makeLocationCode(source),
        })
        coder:getTracer():appendVar(source)
        return
    end
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
        coder:addLine('{key}:setSelfLike()' % {
            key = coder:getKey(source),
        })
        if parentVariable then
            coder:addLine('{key}:setMasterVariable({parent})' % {
                parent = coder:getKey(parentVariable),
                key    = coder:getKey(source),
            })
        end
        return
    end

    local cat = coder:findMatchedCatParam(source)
    if cat and cat.pack then
        local element = cat.value and coder:getKey(cat.value) or 'rt.ANY'
        coder:addLine('{key}:addType(rt.pack({generic}, {element}))' % {
            key      = coder:getKey(source),
            generic  = coder:getKey(cat.pack),
            element  = element,
        })
        return
    end
    local type = 'rt.ANY'
    if cat and cat.value then
        type = coder:getKey(cat.value)
    elseif source.value then
        coder:compile(source.value)
        type = coder:getKey(source.value)
    end
    coder:addLine('{key}:addType({type})' % {
        key  = coder:getKey(source),
        type = type,
    })
end)
