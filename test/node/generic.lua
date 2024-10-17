do
    local N = ls.node.generic('N', ls.node.NUMBER)
    local U = ls.node.generic 'U'
    local pack = ls.node.genericPack { N, U }
    local array = ls.node.array(N)
    local tuple = ls.node.tuple { N, U }
    local table = ls.node.table { [N] = U }
    local func  = ls.node.func()
        : addParam('a', N)
        : addVarargParam(U)
        : addReturn(nil, tuple)
    local union = N | U
    local intersection = N & U

    assert(N:view() == '<N:number>')
    assert(U:view() == '<U>')

    assert(pack:view() == '<N:number, U>')

    assert(array:view() == '<N:number>[]')

    assert(tuple:view() == '[<N:number>, <U>]')

    assert(table:view() == '{ [<N:number>]: <U> }')

    assert(func:view() == 'fun(a: <N:number>, ...: <U>):[<N:number>, <U>]')
    func:bindGenericPack(pack)
    assert(func:view() == 'fun<N:number, U>(a: <N:number>, ...: <U>):[<N:number>, <U>]')

    assert(union:view() == '<N:number> | <U>')

    assert(intersection:view() == '<N:number> & <U>')

    local newPack = pack:resolve {
        [N] = ls.node.type 'integer'
    }
    assert(newPack:view() == '<integer, any>')

    local newArray = array:resolveGeneric(newPack)
    assert(newArray:view() == 'integer[]')

    local newTuple = tuple:resolveGeneric(newPack)
    assert(newTuple:view() == '[integer, any]')

    local newTable = table:resolveGeneric(newPack)
    assert(newTable:view() == '{ [integer]: any }')

    local newFunc = func:resolveGeneric(newPack)
    assert(newFunc:view() == 'fun<integer, any>(a: integer, ...: any):[integer, any]')

    local newUnion = union:resolveGeneric(newPack)
    assert(newUnion:view() == 'integer | any')

    local newIntersection = intersection:resolveGeneric(newPack)
    assert(newIntersection:view() == 'integer')
end

do
    ls.node.TYPE_POOL['Alias'] = nil

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local pack = ls.node.genericPack { K, V }
    local alias = ls.node.type 'Alias'
    alias:bindParams(pack)

    local aliasValue = K | V | ls.node.BOOLEAN
    alias:addAlias(aliasValue)
    assert(aliasValue.value:view() == '<K> | <V> | boolean')

    assert(alias:view() == 'Alias<K, V>')

    local newPack = pack:resolve {
        [K] = ls.node.STRING,
        [V] = ls.node.NUMBER,
    }

    local newAlias = alias:resolveGeneric(newPack)
    assert(newAlias:view() == 'Alias<string, number>')

    newAlias = alias:call { ls.node.NUMBER, ls.node.STRING }
    assert(newAlias:view() == 'Alias<number, string>')

    assert(newAlias.value:view() == 'number | string | boolean')
end

do
    ls.node.TYPE_POOL['Alias'] = nil

    local K = ls.node.generic 'K'
    local V = ls.node.generic('V', ls.node.NUMBER)
    local pack = ls.node.genericPack { K, V }
    local alias = ls.node.type 'Alias'
    alias:bindParams(pack)

    local aliasValue = K | V | ls.node.BOOLEAN
    alias:addAlias(aliasValue)
    assert(aliasValue.value:view() == '<K> | <V:number> | boolean')

    assert(alias:view() == 'Alias<K, V:number>')
    assert(alias.value:view() == '<K> | <V:number> | boolean')

    local alias0 = alias:call()
    assert(alias0:view() == 'Alias<any, number>')
    assert(alias0.value:view() == 'any | number | boolean')

    local alias1 = alias:call { ls.node.STRING }
    assert(alias1:view() == 'Alias<string, number>')
    assert(alias1.value:view() == 'string | number | boolean')

    local alias2 = alias:call { ls.node.STRING, ls.node.INTEGER }
    assert(alias2:view() == 'Alias<string, integer>')
    assert(alias2.value:view() == 'string | integer | boolean')

    local alias3 = alias:call { ls.node.STRING, ls.node.INTEGER, ls.node.TABLE }
    assert(alias3:view() == 'Alias<string, integer>')
    assert(alias3.value:view() == 'string | integer | boolean')
end
