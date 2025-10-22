ls.vm.registerCoderProvider('cat', function (coder, source)
    ---@cast source LuaParser.Node.Cat
    coder:compile(source.value)
end)

ls.vm.registerCoderProvider('catstateclass', function (coder, source)
    ---@cast source LuaParser.Node.CatStateClass

    local classParams = {
        qid = string.format('%q', source.classID.id),
        class = coder:makeKeyCode('class', source.classID.id, source.startRow + 1, source.startCol + 1),
        location = coder:makeLocationCode(source.start, source.finish),
    }
    coder:addLine('{class} = node.class {qid}' % classParams)
    coder:addLine('node.type({qid}):addClass({class})' % classParams)
    coder:addLine('{class}:setLocation {location}' % classParams)

    coder:addDisposer('node.type({qid}):removeClass({class})' % classParams)

    coder:setBlockKV('lastClass', classParams)
end)

ls.vm.registerCoderProvider('catstatefield', function (coder, source)
    ---@cast source LuaParser.Node.CatStateField

    local classParams = coder:getBlockKV('lastClass')

    coder:withNewBlock(function ()
        local key = coder:makeKeyCode('field', 'key', source.key.startRow + 1, source.key.startCol + 1)
        coder:compile(source.key, key)

        local value = coder:makeKeyCode('field', 'value', source.value.startRow + 1, source.value.startCol + 1)
        coder:compile(source.value, value)

        if not classParams then
            return
        end

        local field = coder:makeKeyCode('field', 'field', source.startRow + 1, source.startCol + 1)
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
            location = coder:makeLocationCode(source.start, source.finish),
        })

        coder:addLine('{class}:addField({field})' % {
            class = classParams.class,
            field = field,
        })

        coder:addDisposer('{class}:removeField({field})' % {
            class = classParams.class,
            field = field,
        })
    end)
end)

ls.vm.registerCoderProvider('catfieldname', function (coder, source, saveKey)
    ---@cast source LuaParser.Node.CatFieldName

    saveKey = saveKey or coder:makeKeyCode('fieldname', 'key', source.startRow + 1, source.startCol + 1)
    coder:addLine('{key} = node.value {name:q}' % {
        key = saveKey,
        name = source.id,
    })
end)

ls.vm.registerCoderProvider('catid', function (coder, source, saveKey)
    ---@cast source LuaParser.Node.CatID

    saveKey = saveKey or coder:makeKeyCode('id', 'id', source.startRow + 1, source.startCol + 1)
    coder:addLine('{id} = node.type {name:q}' % {
        id = saveKey,
        name = source.id,
    })
end)
