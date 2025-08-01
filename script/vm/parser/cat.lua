ls.vm.registerRunnerParser('cat', function (runner, source)
    ---@cast source LuaParser.Node.Cat
    local value = source.value
    if not value then
        return
    end
    local node = runner:parse(value)
    return node
end)

ls.vm.registerRunnerParser('catid', function (runner, source)
    ---@cast source LuaParser.Node.CatID

    return runner.node.type(source.id)
end)

ls.vm.registerRunnerParser('catinteger', function (runner, source)
    ---@cast source LuaParser.Node.CatInteger
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('catboolean', function (runner, source)
    ---@cast source LuaParser.Node.CatBoolean
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('catstring', function (runner, source)
    ---@cast source LuaParser.Node.CatString
    return runner.node.value(source.value)
end)

ls.vm.registerRunnerParser('cattable', function (runner, source)
    ---@cast source LuaParser.Node.Table
    local node = runner.node
    local t = node.table()
    for _, field in ipairs(source.fields) do
        if field.subtype == 'field' then
            t:addField {
                key      = node.value(field.key.id),
                value    = runner:parse(field.value),
                location = runner:makeLocation(field),
            }
        else
            t:addField {
                key      = runner:parse(field.key),
                value    = runner:parse(field.value),
                location = runner:makeLocation(field),
            }
        end
    end
    return t
end)

ls.vm.registerRunnerParser('catunion', function (runner, source)
    ---@cast source LuaParser.Node.CatUnion
    return runner.node.union(ls.util.map(source.exps, function (v, k)
        return runner:parse(v)
    end))
end)

ls.vm.registerRunnerParser('catintersection', function (runner, source)
    ---@cast source LuaParser.Node.CatIntersection
    return runner.node.intersection(ls.util.map(source.exps, function (v, k)
        return runner:parse(v)
    end))
end)

ls.vm.registerRunnerParser('cattuple', function (runner, source)
    ---@cast source LuaParser.Node.CatTuple
    return runner.node.tuple(ls.util.map(source.exps, function (v, k)
        return runner:parse(v)
    end))
end)

ls.vm.registerRunnerParser('catarray', function (runner, source)
    ---@cast source LuaParser.Node.CatArray
    return runner.node.array(runner:parse(source.node), source.size and source.size.value)
end)

ls.vm.registerRunnerParser('catcall', function (runner, source)
    ---@cast source LuaParser.Node.CatCall
    return runner.node.type(source.node.id):call(ls.util.map(source.args, function (v, k)
        return runner:parse(v)
    end))
end)

ls.vm.registerRunnerParser('catfunction', function (runner, source)
    ---@cast source LuaParser.Node.CatFunction
    local func = runner.node.func()
    if source.async then
        func:setAsync()
    end
    if source.typeParams then
        func:bindGenerics(ls.util.map(source.typeParams, function (g, k)
            return runner:makeGeneric(g)
        end))
    end
    if source.params then
        for _, param in ipairs(source.params) do
            local id = param.name and param.name.id
            local value = param.value and runner:parse(param.value) or runner.node.ANY
            if id == '...' then
                func:addVarargParamDef(value)
            else
                func:addParamDef(id, value)
            end
        end
    end
    if source.returns then
        for _, ret in ipairs(source.returns) do
            local id = ret.name and ret.name.id
            local value = ret.value and runner:parse(ret.value) or runner.node.ANY
            if id == '...' then
                func:addVarargReturnDef(value)
            else
                func:addReturnDef(id, value)
            end
        end
    end
    return func
end)

ls.vm.registerRunnerParser('catstateclass', function (runner, source)
    ---@cast source LuaParser.Node.CatStateClass

    local class = runner.node.type(source.classID.id)
    runner.context.lastClass = class

    local location = runner:makeLocation(source)
    class:addClass(location)

    runner:addDispose(function ()
        class:removeClass(location)
    end)

    if source.extends then
        for _, extend in ipairs(source.extends) do
            local value = runner:parse(extend)
            if value.kind == 'type' then
                ---@cast value Node.Type
                class:addExtends(value)
                runner:addDispose(function ()
                    class:removeExtends(value)
                end)
            end
        end
    end

    runner:clearCatGroup()
    runner:addToCatGroup(source.parent)

    return class
end)

ls.vm.registerRunnerParser('catstatefield', function (runner, source)
    ---@cast source LuaParser.Node.CatStateField

    local field = {
        key      = runner.node.value(source.key.id),
        value    = runner:parse(source.value),
        location = runner:makeLocation(source),
    }

    local class = runner.context.lastClass
    if not class then
        return
    end

    class:addField(field)
    runner:addDispose(function ()
        class:removeField(field)
    end)
end)

ls.vm.registerRunnerParser('catstatealias', function (runner, source)
    ---@cast source LuaParser.Node.CatStateAlias

    local alias = runner.node.type(source.aliasID.id)

    local value = runner:parse(source.extends)
    local location = runner:makeLocation(source)

    alias:addAlias(value, location)
    runner:addDispose(function ()
        alias:removeAlias(value, location)
    end)
end)

ls.vm.registerRunnerParser('catstateparam', function (runner, source)
    ---@cast source LuaParser.Node.CatStateParam

    runner:addToCatGroup(source.parent, true)
end)

ls.vm.registerRunnerParser('catstatereturn', function (runner, source)
    ---@cast source LuaParser.Node.CatStateReturn

    runner:addToCatGroup(source.parent, true)
end)

ls.vm.registerRunnerParser('catstatetype', function (runner, source)
    ---@cast source LuaParser.Node.CatStateType

    local node = runner:parse(source.exp)

    runner:clearCatGroup()
    runner:addToCatGroup(source.parent)

    return node
end)
