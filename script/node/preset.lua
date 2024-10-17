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
        if other.value ~= ls.node.NIL then
            return true
        end
    end)
    : setConfig('onCanBeCast', function (self, other)
        if other.value ~= ls.node.NIL then
            return true
        end
    end)
ls.node.TRULY = ls.node.type 'truly'
    : setConfig('onCanCast', function (self, other)
        if  other.value ~= ls.node.NIL
        and other.value ~= ls.node.FALSE then
            return true
        end
    end)
    : setConfig('onCanBeCast', function (self, other)
        if  other.value ~= ls.node.NIL
        and other.value ~= ls.node.FALSE then
            return true
        end
    end)
    : setConfig('basicType', true)
ls.node.TRUE = ls.node.value(true)
ls.node.FALSE = ls.node.value(false)
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
    : setConfig('hideEmptyArgs', true)
ls.node.USERDATA = ls.node.type 'userdata'
    : setConfig('basicType', true)
ls.node.THREAD = ls.node.type 'thread'
    : setConfig('basicType', true)

ls.node.ANY:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
ls.node.ANY.truly = ls.node.TRULY
ls.node.ANY.falsy = ls.node.value(false) | ls.node.NIL

ls.node.UNKNOWN:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
ls.node.UNKNOWN.truly = ls.node.TRULY
ls.node.UNKNOWN.falsy = ls.node.value(false)

ls.node.TRULY:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}

ls.node.NIL.truly = ls.node.NEVER
ls.node.NIL.falsy = ls.node.NIL

ls.node.BOOLEAN.truly = ls.node.TRUE
ls.node.BOOLEAN.falsy = ls.node.FALSE

ls.node.FALSE.truly = ls.node.NEVER
ls.node.FALSE.falsy = ls.node.FALSE

do
    local K = ls.node.generic('K', ls.node.ANY, ls.node.ANY)
    local V = ls.node.generic('V', ls.node.ANY, ls.node.ANY)
    ls.node.TABLE:bindParams(ls.node.genericPack { K, V })
    ls.node.TABLE:addField {
        key   = K,
        value = V,
    }
end

ls.node.USERDATA:addField {
    key   = ls.node.ANY,
    value = ls.node.ANY,
}
