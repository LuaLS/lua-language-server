ls.node.NEVER = ls.node.type 'never'
    : setConfig('basicType', true)
ls.node.ANY = ls.node.type 'any'
    : setConfig('onCanCast', function (self, other)
        return true
    end)
    : setConfig('onCanBeCast', function (self, other)
        return true
    end)
    : setConfig('basicType', true)
ls.node.UNKNOWN = ls.node.type 'unknown'
    : setConfig('onCanCast', function (self, other)
        if other.typeName ~= 'nil' then
            return true
        end
    end)
    : setConfig('onCanBeCast', function (self, other)
        if other.typeName ~= 'nil' then
            return true
        end
    end)
ls.node.NIL = ls.node.type 'nil'
    : setConfig('basicType', true)
ls.node.NUMBER = ls.node.type 'number'
    : setConfig('basicType', true)
ls.node.INTEGER = ls.node.type 'integer'
    : setConfig('basicType', true)
    : addExtends(ls.node.NUMBER)
ls.node.STRING = ls.node.type 'string'
    : setConfig('basicType', true)
ls.node.BOOLEAN = ls.node.type 'boolean'
    : setConfig('basicType', true)
ls.node.FUNCTION = ls.node.type 'function'
    : setConfig('basicType', true)
ls.node.TABLE = ls.node.type 'table'
    : setConfig('basicType', true)
ls.node.USERDATA = ls.node.type 'userdata'
    : setConfig('basicType', true)
ls.node.THREAD = ls.node.type 'thread'
    : setConfig('basicType', true)

ls.node.ANY:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
ls.node.UNKNOWN:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
ls.node.TABLE:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
ls.node.USERDATA:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
