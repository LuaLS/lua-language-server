ls.vm.registerCoderProvider('cat', function (coder, source)
    ---@cast source LuaParser.Node.Cat
    coder:compile(source.value)
end)

ls.vm.registerCoderProvider('catstateclass', function (coder, source)
    ---@cast source LuaParser.Node.CatStateClass

    local classParams = {
        qid = string.format('%q', source.classID.id),
        class = coder:getKey(source),
        location = coder:makeLocationCode(source),
    }

    coder:withIndentation(function ()
        coder:addLine('{class} = node.class {qid}' % classParams)
        coder:addLine('node.type({qid}):addClass({class})' % classParams)
        coder:addLine('{class}:setLocation {location}' % classParams)

        coder:addDisposer('node.type({qid}):removeClass({class})' % classParams)
    end, source.parent.code)

    coder:setBlockKV('lastClass', classParams)

    coder:clearCatGroup()
    coder:addToCatGroup(source.parent)
end)

ls.vm.registerCoderProvider('catstatefield', function (coder, source)
    ---@cast source LuaParser.Node.CatStateField

    local classParams = coder:getBlockKV('lastClass')

    coder:withIndentation(function ()
        local key = coder:getKey(source.key)
        coder:compile(source.key)

        local value = coder:getKey(source.value)
        coder:compile(source.value)

        if not classParams then
            return
        end

        local field = coder:getKey(source)
        coder:addLine([[
{field} = {
    key = {key},
    value = {value},
    location = {location},
}
]] % {
            field = field,
            key = key,
            value = value,
            location = coder:makeLocationCode(source),
        })

        coder:addLine('{class}:addField({field})' % {
            class = classParams.class,
            field = field,
        })

        -- coder:addDisposer('{class}:removeField({field})' % {
        --     class = classParams.class,
        --     field = field,
        -- })
    end, source.parent.code)
end)

ls.vm.registerCoderProvider('catfieldname', function (coder, source)
    ---@cast source LuaParser.Node.CatFieldName

    coder:addLine('{key} = node.value {name:q}' % {
        key = coder:getKey(source),
        name = source.id,
    })
end)

ls.vm.registerCoderProvider('catid', function (coder, source)
    ---@cast source LuaParser.Node.CatID

    coder:addLine('{id} = node.type {name:q}' % {
        id = coder:getKey(source),
        name = source.id,
    })
end)

ls.vm.registerCoderProvider('catstateparam', function (coder, source)
    ---@cast source LuaParser.Node.CatStateParam

    coder:withIndentation(function ()
        if source.value then
            coder:compile(source.value)
        end
    end, source.parent.code)

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catstatereturn', function (coder, source)
    ---@cast source LuaParser.Node.CatStateReturn

    coder:withIndentation(function ()
        coder:compile(source.value)
    end, source.parent.code)

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catstatealias', function (coder, source)
    ---@cast source LuaParser.Node.CatStateAlias

    coder:withIndentation(function ()
        if source.extends then
            coder:compile(source.extends)
        end

        coder:addLine('{alias} = node.alias({name:q})' % {
            alias = coder:getKey(source),
            name  = source.aliasID.id,
        })
        coder:addLine('node.type({name:q}):addAlias({alias})' % {
            alias = coder:getKey(source),
            name  = source.aliasID.id,
        })

        if source.extends then
            coder:addLine('{alias}:setValue({value})' % {
                alias = coder:getKey(source),
                value = coder:getKey(source.extends),
            })
        end

        coder:addDisposer('node.type({name:q}):removeAlias({alias})' % {
            alias = coder:getKey(source),
            name  = source.aliasID.id,
        })
    end, source.parent.code)

    coder:addToCatGroup(source.parent, true)
end)

ls.vm.registerCoderProvider('catinteger', function (coder, source)
    ---@cast source LuaParser.Node.CatInteger

    coder:addLine('{key} = node.value({value})' % {
        key = coder:getKey(source),
        value = source.value,
    })
end)

ls.vm.registerCoderProvider('catunion', function (coder, source)
    ---@cast source LuaParser.Node.CatUnion

    local parts = {}
    for i, v in ipairs(source.exps) do
        coder:compile(v)
        parts[i] = coder:getKey(v)
    end

    coder:addLine('{key} = node.union {{parts}}' % {
        key = coder:getKey(source),
        parts = table.concat(parts, ', '),
    })
end)

ls.vm.registerCoderProvider('catintersection', function (coder, source)
    ---@cast source LuaParser.Node.CatIntersection

    local parts = {}
    for i, v in ipairs(source.exps) do
        coder:compile(v)
        parts[i] = coder:getKey(v)
    end

    coder:addLine('{key} = node.intersection {{parts}}' % {
        key = coder:getKey(source),
        parts = table.concat(parts, ', '),
    })
end)

ls.vm.registerCoderProvider('cattable', function (coder, source)
    ---@cast source LuaParser.Node.CatTable

    local fields = {}
    for i, field in ipairs(source.fields) do
        coder:compile(field)
        fields[i] = coder:getKey(field)
    end

    coder:addLine('{key} = node.table {{fields}}' % {
        key = coder:getKey(source),
        fields = table.concat(fields, ', '),
    })
end)
