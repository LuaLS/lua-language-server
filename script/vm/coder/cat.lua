ls.vm.registerCoderProvider('cat', function (coder, source)
    ---@cast source LuaParser.Node.Cat
    coder:compile(source.value)
end)

ls.vm.registerCoderProvider('catstateclass', function (coder, source)
    ---@cast source LuaParser.Node.CatStateClass

    local classParams = {
        qid = string.format('%q', source.classID.id),
        class = coder:getKey(source.parent),
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
