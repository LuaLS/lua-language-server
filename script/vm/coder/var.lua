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

---@param coder VM.Coder
---@param source LuaParser.Node.Param
---@return boolean
---@return LuaParser.Node.Term?
local function checkSelf(coder, source)
    if source.isSelf then
        return true, source.parent.name and source.parent.name.last
    end
    if source.id ~= 'self' or source.index ~= 1 then
        return false, nil
    end
    local cat = coder:findMatchedCatParam(source)
    if cat then
        return false, nil
    end
    local func = source.parent
    if not func or func.kind ~= 'function' then
        return false, nil
    end
    local assign = func.parent
    if not assign or assign.kind ~= 'assign' then
        return false, nil
    end
    ---@cast assign LuaParser.Node.Assign
    if assign.values[func.index] ~= func then
        return false, nil
    end
    local exp = assign.exps and assign.exps[func.index]
    if not exp or exp.kind ~= 'field' then
        return false, nil
    end
    return true, exp.last
end

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

    local looksLikeSelf, parentVariable = checkSelf(coder, source)

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
