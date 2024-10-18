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

    local resolve = { [N] = ls.node.INTEGER }

    local newPack = pack:resolve(resolve)
    assert(newPack:view() == '<integer, U>')

    local newArray = array:resolveGeneric(resolve)
    assert(newArray:view() == 'integer[]')

    local newTuple = tuple:resolveGeneric(resolve)
    assert(newTuple:view() == '[integer, <U>]')

    local newTable = table:resolveGeneric(resolve)
    assert(newTable:view() == '{ [integer]: <U> }')

    local newFunc = func:resolveGeneric(resolve)
    assert(newFunc:view() == 'fun<integer, U>(a: integer, ...: <U>):[integer, <U>]')

    local newUnion = union:resolveGeneric(resolve)
    assert(newUnion:view() == 'integer | <U>')

    local newIntersection = intersection:resolveGeneric(resolve)
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

    --[[
    ---@alias Alias<K, V:number> K | V | boolean
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic('V', ls.node.NUMBER)
    local pack = ls.node.genericPack { K, V }
    local alias = ls.node.type 'Alias'
    alias:bindParams(pack)

    local aliasValue = K | V | ls.node.BOOLEAN
    alias:addAlias(aliasValue)
    assert(aliasValue:view() == '<K> | <V:number> | boolean')

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

do
    ls.node.TYPE_POOL['Alias'] = nil

    --[[
    ---@alias Alias<K, V:number> { [K]: V }
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic('V', ls.node.NUMBER)
    local pack = ls.node.genericPack { K, V }
    local alias = ls.node.type 'Alias'
    alias:bindParams(pack)

    local aliasValue = ls.node.table { [K] = V }
    alias:addAlias(aliasValue)
    assert(aliasValue:view() == '{ [<K>]: <V:number> }')

    assert(alias:view() == 'Alias<K, V:number>')
    assert(alias.value:view() == '{ [<K>]: <V:number> }')

    local alias0 = alias:call()
    assert(alias0:view() == 'Alias<any, number>')
    assert(alias0.value:view() == '{ [any]: number }')
    assert(alias0:get(1):view() == 'number')
    assert(alias0:get('x'):view() == 'number')

    local alias1 = alias:call { ls.node.STRING }
    assert(alias1:view() == 'Alias<string, number>')
    assert(alias1.value:view() == '{ [string]: number }')
    assert(alias1:get(1):view() == 'nil')
    assert(alias1:get('x'):view() == 'number')

    local alias2 = alias:call { ls.node.STRING, ls.node.INTEGER }
    assert(alias2:view() == 'Alias<string, integer>')
    assert(alias2.value:view() == '{ [string]: integer }')
    assert(alias2:get(1):view() == 'nil')
    assert(alias2:get('x'):view() == 'integer')
end

do
    ls.node.TYPE_POOL['Map'] = nil

    --[[
    ---@class Map<K, V:number>
    ---@field [K] V
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic('V', ls.node.NUMBER)
    local pack = ls.node.genericPack { K, V }
    local map = ls.node.type 'Map'
    map:bindParams(pack)

    map:addField {
        key   = K,
        value = V,
    }

    assert(map:view() == 'Map<K, V:number>')
    assert(map.value:view() == '{ [<K>]: <V:number> }')

    local map2 = map:call { ls.node.STRING, ls.node.INTEGER }
    assert(map2:view() == 'Map<string, integer>')
    assert(map2.value:view() == '{ [string]: integer }')
    assert(map2:get(1):view() == 'nil')
    assert(map2:get('x'):view() == 'integer')
end

do
    ls.node.TYPE_POOL['Map'] = nil

    --[[
    ---@class Map<K, V:number>
    ---@field set fun(key: K, value: V)
    ---@field get fun(key: K): V
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic('V', ls.node.NUMBER)
    local pack = ls.node.genericPack { K, V }
    local map = ls.node.type 'Map'
    map:bindParams(pack)

    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : addParam('key', K)
            : addParam('value', V),
    }
    map:addField {
        key   = ls.node.value 'get',
        value = ls.node.func()
            : addParam('key', K)
            : addReturn(nil, V),
    }

    assert(map.value:view() == '{ get: fun(key: <K>):<V:number>, set: fun(key: <K>, value: <V:number>) }')
    assert(map.value:get('set'):view() == 'fun(key: <K>, value: <V:number>)')
    assert(map:get('set'):view() == 'fun(key: any, value: number)')

    local map2 = map:call { ls.node.STRING, ls.node.INTEGER }
    assert(map2.value:view() == '{ get: fun(key: string):integer, set: fun(key: string, value: integer) }')
    assert(map2:get('set'):view() == 'fun(key: string, value: integer)')
    assert(map2.value:get('set'):view() == 'fun(key: string, value: integer)')
end

do
    ls.node.TYPE_POOL['Map'] = nil

    --[[
    ---@class Map<K>
    ---@field set fun<V>(key: K, value: V)
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = ls.node.type 'Map'
    map:bindParams(ls.node.genericPack { K })

    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : bindGenericPack(ls.node.genericPack { V })
            : addParam('key', K)
            : addParam('value', V),
    }

    assert(map.value:view() == '{ set: fun<V>(key: <K>, value: <V>) }')
    assert(map.value:get('set'):view() == 'fun<V>(key: <K>, value: <V>)')
    assert(map:get('set'):view() == 'fun<V>(key: any, value: <V>)')

    local map1 = map:call { ls.node.STRING }
    assert(map1.value:view() == '{ set: fun<V>(key: string, value: <V>) }')
    assert(map1:get('set'):view() == 'fun<V>(key: string, value: <V>)')
    assert(map1.value:get('set'):view() == 'fun<V>(key: string, value: <V>)')

    local func = map1:get('set')
    ---@cast func Node.Function
    assert(func:view() == 'fun<V>(key: string, value: <V>)')
    local rfunc = func:resolveGeneric { [V] = ls.node.INTEGER }
    assert(rfunc:view() == 'fun<integer>(key: string, value: integer)')
end

do
    ls.node.TYPE_POOL['Map'] = nil
    ls.node.TYPE_POOL['Unit'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit
    ---@field childs Map<integer, Unit>
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = ls.node.type 'Map'
    map:bindParams(ls.node.genericPack { K, V })

    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : addParam('key', K)
            : addParam('value', V),
    }

    local unit = ls.node.type 'Unit'
    unit:addField {
        key   = ls.node.value 'childs',
        value = map:call { ls.node.INTEGER, unit },
    }

    assert(unit.value:view() == '{ childs: Map<integer, Unit> }')
    assert(unit:get('childs'):view() == 'Map<integer, Unit>')
    assert(unit:get('childs').value:view() == '{ set: fun(key: integer, value: Unit) }')
end

do
    ls.node.TYPE_POOL['Map'] = nil
    ls.node.TYPE_POOL['Unit'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit<T>
    ---@field childs Map<T, string>
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = ls.node.type 'Map'
    map:bindParams(ls.node.genericPack { K, V })
    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : addParam('key', K)
            : addParam('value', V),
    }

    local T = ls.node.generic 'T'
    local unit = ls.node.type 'Unit'
    unit:bindParams(ls.node.genericPack { T })
    unit:addField {
        key   = ls.node.value 'childs',
        value = map:call { T, ls.node.STRING },
    }

    assert(unit.value:view() == '{ childs: Map<<T>, string> }')
    assert(unit.value:get('childs'):view() == 'Map<<T>, string>')
    assert(unit.value:get('childs').value:view() == '{ set: fun(key: <T>, value: string) }')
    assert(unit:get('childs'):view() == 'Map<any, string>')
    assert(unit:get('childs').value:view() == '{ set: fun(key: any, value: string) }')

    local unit2 = unit:call { ls.node.NUMBER }
    assert(unit2.value:view() == '{ childs: Map<number, string> }')
    assert(unit2.value:get('childs'):view() == 'Map<number, string>')
    assert(unit2.value:get('childs').value:view() == '{ set: fun(key: number, value: string) }')
    assert(unit2:get('childs'):view() == 'Map<number, string>')
    assert(unit2:get('childs').value:view() == '{ set: fun(key: number, value: string) }')
end

do
    ls.node.TYPE_POOL['Map'] = nil
    ls.node.TYPE_POOL['OrderMap'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap: Map<number, string>
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = ls.node.type 'Map'
    map:bindParams(ls.node.genericPack { K, V })
    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : addParam('key', K)
            : addParam('value', V),
    }

    local omap = ls.node.type 'OrderMap'
    omap:addExtends(map:call { ls.node.NUMBER, ls.node.STRING })

    assert(omap:get('set'):view() == 'fun(key: number, value: string)')
end

do
    ls.node.TYPE_POOL['Map'] = nil
    ls.node.TYPE_POOL['OrderMap'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap: Map<number, string>
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = ls.node.type 'Map'
    map:bindParams(ls.node.genericPack { K, V })
    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : addParam('key', K)
            : addParam('value', V),
    }

    local omap = ls.node.type 'OrderMap'
    omap:addExtends(map:call { ls.node.NUMBER, ls.node.STRING })

    assert(omap:get('set'):view() == 'fun(key: number, value: string)')
end

do
    ls.node.TYPE_POOL['Map'] = nil
    ls.node.TYPE_POOL['OrderMap'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap<OK:number, OV>: Map<OK, OV>
    ]]

    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = ls.node.type 'Map'
    map:bindParams(ls.node.genericPack { K, V })
    map:addField {
        key   = ls.node.value 'set',
        value = ls.node.func()
            : addParam('key', K)
            : addParam('value', V),
    }

    local OK = ls.node.generic('OK', ls.node.NUMBER)
    local OV = ls.node.generic 'OV'
    local omap = ls.node.type 'OrderMap'
    omap:bindParams(ls.node.genericPack { OK, OV })
    omap:addExtends(map:call { OK, OV })

    assert(omap:get('set'):view() == 'fun(key: number, value: any)')

    local omap2 = omap:call { ls.node.INTEGER, ls.node.STRING }

    assert(omap2:get('set'):view() == 'fun(key: integer, value: string)')
end
