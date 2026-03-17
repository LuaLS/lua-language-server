---@param coder Coder
---@param source LuaParser.Node.Base
---@param value string | number | boolean
local function makeValue(coder, source, value)
    coder:addLine('{key} = rt.value({value%q})' % {
        key   = coder:getKey(source),
        value = value,
    })
    coder:getTracer():append('value', source.uniqueKey)
end

ls.vm.registerCoderProvider('integer', function (coder, source)
    ---@cast source LuaParser.Node.Integer

    makeValue(coder, source, source.value)
end)

ls.vm.registerCoderProvider('float', function (coder, source)
    ---@cast source LuaParser.Node.Float

    makeValue(coder, source, source.value)
end)

ls.vm.registerCoderProvider('string', function (coder, source)
    ---@cast source LuaParser.Node.String

    makeValue(coder, source, source.value)
end)

ls.vm.registerCoderProvider('nil', function (coder, source)
    ---@cast source LuaParser.Node.Nil

    coder:addLine('{key} = rt.NIL' % {
        key = coder:getKey(source),
    })
    coder:getTracer():append('value', source.uniqueKey)
end)

ls.vm.registerCoderProvider('boolean', function (coder, source)
    ---@cast source LuaParser.Node.Boolean

    makeValue(coder, source, source.value)
end)

ls.vm.registerCoderProvider('table', function (coder, source)
    ---@cast source LuaParser.Node.Table

    coder:addLine('{key} = rt.table()' % {
        key = coder:getKey(source),
    })

    for _, field in ipairs(source.fields) do
        if not field.value then
            goto CONTINUE
        end
        coder:withIndentation(function ()
            coder:compile(field)
            coder:addLine('{key}:addField({field})' % {
                key   = coder:getKey(source),
                field = coder:getKey(field),
            })
        end, field)
        ::CONTINUE::
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
    if source.subtype == 'field' then
        coder:addLine('{fieldid} = rt.index({table}, {field%q}, true)' % {
            fieldid = coder:getKey(source.key),
            table   = coder:getKey(source.parent),
            field   = source.key.id,
        })
    end
end)

ls.vm.registerCoderProvider('select', function (coder, source)
    ---@cast source LuaParser.Node.Select

    local value = source.value
    if source.sindex == 1 then
        coder:compile(value)
    end
    coder:addLine('{key} = rt.select({value}, {index})' % {
        key   = coder:getKey(source),
        value = coder:getKey(source.value),
        index = source.sindex,
    })
end)

ls.vm.registerCoderProvider('call', function (coder, source)
    ---@cast source LuaParser.Node.Call

    coder:compile(source.node)
    local func = coder:getKey(source.node)
    local args = {}
    for i, arg in ipairs(source.args) do
        coder:compile(arg)
        args[i] = coder:getKey(arg)
        if arg.kind == 'table' then
            coder:addLine('{key}:setExpectParent(rt.paramOf({func}, {index}))' % {
                key   = coder:getKey(arg),
                func  = func,
                index = i,
            })
        end
    end
    coder:addLine('{key} = rt.fcall({func}, { {args} })' % {
        key   = coder:getKey(source),
        func  = func,
        args  = table.concat(args, ', '),
    })
    coder:getTracer():appendCall(source)
end)

ls.vm.registerCoderProvider('paren', function (coder, source)
    ---@cast source LuaParser.Node.Paren

    if not source.value then
        coder:addUnknown(source)
        return
    end
    coder:compile(source.value)
    coder:addLine('{key} = {value}' % {
        key   = coder:getKey(source),
        value = coder:getKey(source.value),
    })
end)

local bopMap = {
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

    local op = bopMap[source.op]

    local needCloseNode
    if source.op == '=='
    or source.op == '~='
    or source.op == 'and'
    or source.op == 'or' then
        if source.exp1 and source.exp2 then
            coder:getTracer():openNode(source.op)
            needCloseNode = true
        end
    end
    if source.exp1 then
        coder:compile(source.exp1)
    end
    if source.exp2 then
        coder:compile(source.exp2)
    end

    if needCloseNode then
        coder:getTracer():closeNode()
    end

    if not source.op or not source.exp1 or not source.exp2 then
        coder:addUnknown(source)
        return
    end

    if source.op == 'and' then
        -- and: 若左侧为假则取左侧（假值），否则取右侧
        coder:addLine('{key} = rt.ternary({value1}, {value2}, rt.narrow({value1}):matchFalsy())' % {
            key    = coder:getKey(source),
            value1 = coder:getKey(source.exp1),
            value2 = coder:getKey(source.exp2),
        })
        return
    end

    if source.op == 'or' then
        -- or: 若左侧为真则取左侧（真值），否则取右侧
        coder:addLine('{key} = rt.ternary({value1}, rt.narrow({value1}):matchTruly(), {value2})' % {
            key    = coder:getKey(source),
            value1 = coder:getKey(source.exp1),
            value2 = coder:getKey(source.exp2),
        })
        return
    end

    if not op then
        return
    end

    coder:addLine('{key} = rt.call({op%q}, { {arg1}, {arg2} })' % {
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

    local needCloseNode
    if source.op == 'not' and source.exp then
        coder:getTracer():openNode(source.op)
        needCloseNode = true
    end

    if source.exp then
        coder:compile(source.exp)
    end

    if needCloseNode then
        coder:getTracer():closeNode()
    end

    local op = uopMap[source.op]
    if not op or not source.exp then
        coder:addUnknown(source)
        return
    end

    coder:addLine('{key} = rt.call({op%q}, { {arg} })' % {
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
