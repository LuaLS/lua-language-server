ls.node.ANY = ls.node.type 'any'
    : setConfig('onCanCast', function (self, other)
        return true
    end)
    : setConfig('onCanBeCast', function (self, other)
        return true
    end)
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
ls.node.NUMBER = ls.node.type 'number'
ls.node.INTEGER = ls.node.type 'integer'
    : addExtends(ls.node.NUMBER)
ls.node.STRING = ls.node.type 'string'
ls.node.BOOLEAN = ls.node.type 'boolean'
ls.node.FUNCTION = ls.node.type 'function'
ls.node.TABLE = ls.node.type 'table'
ls.node.USERDATA = ls.node.type 'userdata'
ls.node.THREAD = ls.node.type 'thread'


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
