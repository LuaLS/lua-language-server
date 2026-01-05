ls.vm.registerCoderProvider('var', function (coder, source)
    ---@cast source LuaParser.Node.Var
    local value = coder.flow:getOrCreateVarKey(source)
    assert(value, 'Variable key not found for var')
    coder:addLine('{key} = {value}{shadow}' % {
        key = coder:getKey(source),
        value = value,
        shadow = source.value and ':shadow()' or '',
    })
    if source.value then
        coder.flow:setVarKey(source, coder:getKey(source))
    end
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
    if source.subtype == 'index' then
        if source.key then
            coder:compile(source.key)
        end
    end

    local varKey = coder.flow:getOrCreateVarKey(source)

    if varKey then
        coder:addLine('{var} = {varKey}{shadow}' % {
            var    = coder:getKey(source),
            varKey = varKey,
            shadow = source.value and ':shadow()' or '',
        })
        if source.value then
            coder.flow:setVarKey(source, coder:getKey(source))
        end
    else
        -- 无法追踪变量，如 t[func()] , t:func().xxx 之类的
        coder:addLine('{var} = {value}' % {
            var   = coder:getKey(source),
            value = coder:makeVarKey(source),
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
    coder.flow:createVar(source)
    coder.flow:setVarKey(source, coder:getKey(source))
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
    coder.flow:createVar(source)
    coder.flow:setVarKey(source, coder:getKey(source))

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
