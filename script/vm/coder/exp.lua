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

    for _, field in ipairs(source.fields) do
        coder:withIndentation(function ()
            coder:compile(field)
            coder:addLine('{key}:addField({field})' % {
                key   = coder:getKey(source),
                field = coder:getKey(field),
            })
        end, field.code)
    end
end)

ls.vm.registerCoderProvider('tablefield', function (coder, source)
    ---@cast source LuaParser.Node.TableField

    local key = coder:makeFieldCode(source.key)
    if not key then
        key = 'rt.UNKNOWN'
        coder:compile(source.key)
    end
    coder:compile(source.value)

    coder:addLine('{field} = rt.field({key}, {value}):setLocation {location}' % {
        field    = coder:getKey(source),
        key      = key,
        value    = coder:getKey(source.value),
        location = coder:makeLocationCode(source),
    })
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

ls.vm.registerCoderProvider('paren', function (coder, source)
    ---@cast source LuaParser.Node.Paren

    coder:compile(source.exp)
    coder:addLine('{key} = rt.select({value}, 1)' % {
        key   = coder:getKey(source),
        value = coder:getKey(source.exp),
    })
end)

local bopMap = {
    ['or']  = 'op.or',
    ['and'] = 'op.and',
    ['<=']  = 'op.lte',
    ['>=']  = 'op.gte',
    ['<']   = 'op.lt',
    ['>']   = 'op.gt',
    ['~=']  = 'op.neq',
    ['==']  = 'op.eq',
    ['=']   = 'op.eq',
    ['|']   = 'op.bor',
    ['~']   = 'op.bxor',
    ['&']   = 'op.band',
    ['<<']  = 'op.shl',
    ['>>']  = 'op.shr',
    ['..']  = 'op.concat',
    ['+']   = 'op.add',
    ['-']   = 'op.sub',
    ['*']   = 'op.mul',
    ['//']  = 'op.idiv',
    ['/']   = 'op.div',
    ['%']   = 'op.mod',
    ['^']   = 'op.pow',
}

ls.vm.registerCoderProvider('binary', function (coder, source)
    ---@cast source LuaParser.Node.Binary

    coder:compile(source.exp1)
    coder:compile(source.exp2)

    local op = bopMap[source.op]
    if not op or not source.exp1 or not source.exp2 then
        coder:addUnknown(source)
        return
    end

    coder:addLine('{key} = rt.call({op:q}, {{arg1}, {arg2}})' % {
        key   = coder:getKey(source),
        op    = op,
        arg1  = coder:getKey(source.exp1),
        arg2  = coder:getKey(source.exp2),
    })
end)

local uopMap = {
    ['not'] = 'op.not',
    ['#']   = 'op.len',
    ['-']   = 'op.unm',
    ['~']   = 'op.bnot',
}

ls.vm.registerCoderProvider('unary', function (coder, source)
    ---@cast source LuaParser.Node.Unary

    coder:compile(source.exp)

    local op = uopMap[source.op]
    if not op or not source.exp then
        coder:addUnknown(source)
        return
    end

    coder:addLine('{key} = rt.call({op:q}, {{arg}})' % {
        key   = coder:getKey(source),
        op    = op,
        arg   = coder:getKey(source.exp),
    })
end)

ls.vm.registerCoderProvider('varargs', function (coder, source)
    ---@cast source LuaParser.Node.Varargs

    local loc = source.loc
    if not loc then
        coder:addUnknown(source)
        return
    end

    coder:addLine('{key} = {loc}' % {
        key   = coder:getKey(source),
        loc   = coder:getKey(loc),
    })
end)
