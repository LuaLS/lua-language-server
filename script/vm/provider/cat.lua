ls.vm.registerRunnerProvider('cat', function (runner, source)
    ---@cast source LuaParser.Node.Cat
    local value = source.value
    if not value then
        return
    end
    local node = runner:parse(value)
    return node
end)

ls.vm.registerRunnerProvider('catclass', function (runner, source)
    ---@cast source LuaParser.Node.CatClass

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

    return class
end)

ls.vm.registerRunnerProvider('catfield', function (runner, source)
    ---@cast source LuaParser.Node.CatField

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

ls.vm.registerRunnerProvider('catalias', function (runner, source)
    ---@cast source LuaParser.Node.CatAlias

    local alias = runner.node.type(source.aliasID.id)

    local value = runner:parse(source.extends)
    local location = runner:makeLocation(source)

    alias:addAlias(value, location)
    runner:addDispose(function ()
        alias:removeAlias(value, location)
    end)
end)
