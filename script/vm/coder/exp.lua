---@param coder VM.Coder
---@param source LuaParser.Node.Base
---@param value string | number | boolean
local function makeValue(coder, source, value)
    coder:addLine('{key} = rt.value({value:q})' % {
        key   = coder:getKey(source),
        value = value,
    })
end

ls.vm.registerCoderProvider('integer', function (coder, source)
    ---@cast source LuaParser.Node.Integer

    makeValue(coder, source, source.value)
end)

ls.vm.registerCoderProvider('string', function (coder, source)
    ---@cast source LuaParser.Node.String

    makeValue(coder, source, source.value)
end)

ls.vm.registerCoderProvider('table', function (coder, source)
    ---@cast source LuaParser.Node.Table

    coder:addLine('{key} = rt.table()' % {
        key = coder:getKey(source),
    })

    coder:addIndentation(1)
    for _, field in ipairs(source.fields) do
        coder:compile(field)
        coder:addLine('{key}:addField({field})' % {
            key   = coder:getKey(source),
            field = coder:getKey(field),
        })
        coder:addLine('')
    end
    coder:addIndentation(-1)
end)

ls.vm.registerCoderProvider('tablefield', function (coder, source)
    ---@cast source LuaParser.Node.TableField

    coder:compile(source.key)
    coder:compile(source.value)

    coder:addLine([[
{field} = {
    key      = {key},
    value    = {value},
    location = {location},
}
]] % {
        field    = coder:getKey(source),
        key      = coder:getKey(source.key),
        value    = coder:getKey(source.value),
        location = coder:makeLocationCode(source),
    })
end)

ls.vm.registerCoderProvider('tablefieldid', function (coder, source)
    ---@cast source LuaParser.Node.TableFieldID

    makeValue(coder, source, source.id)
end)

ls.vm.registerCoderProvider('select', function (coder, source)
    ---@cast source LuaParser.Node.Select

    local value = source.value
    if source.index == 1 then
        coder:compile(value)
    end
    coder:addLine('{key} = rt.select({value}, {index})' % {
        key   = coder:getKey(source),
        value = coder:getKey(source.value),
        index = source.index,
    })
end)

ls.vm.registerCoderProvider('call', function (coder, source)
    ---@cast source LuaParser.Node.Call

    coder:compile(source.node)
    local args = {}
    for i, arg in ipairs(source.args) do
        coder:compile(arg)
        args[i] = coder:getKey(arg)
    end
    coder:addLine('{key} = rt.fcall({func}, { {args} })' % {
        key   = coder:getKey(source),
        func  = coder:getKey(source.node),
        args  = table.concat(args, ', '),
    })
end)
