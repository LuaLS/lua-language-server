local node = test.scope.node

do
    local N = node.generic('N', node.NUMBER)
    local U = node.generic 'U'
    local pack = node.genericPack { N, U }
    local array = node.array(N)
    local tuple = node.tuple { N, U }
    local table = node.table { [N] = U }
    local func  = node.func()
        : addParamDef('a', N)
        : addVarargParamDef(U)
        : addReturnDef(nil, tuple)
    local union = N | U
    local intersection = N & U

    assert(N:view() == '<N:number>')
    assert(U:view() == '<U>')

    assert(pack:view() == '<N:number, U>')

    assert(array:view() == '<N:number>[]')

    assert(tuple:view() == '[<N:number>, <U>]')

    assert(table:view() == '{ [<N:number>]: <U> }')

    assert(func:view() == 'fun(a: <N:number>, ...: <U>):[<N:number>, <U>]')
    func:bindGenerics { N, U }
    assert(func:view() == 'fun<N:number, U>(a: <N:number>, ...: <U>):[<N:number>, <U>]')

    assert(union:view() == '<N:number> | <U>')

    assert(intersection:view() == '<N:number> & <U>')

    local resolve = { [N] = node.INTEGER }

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
    assert(newIntersection:view() == 'integer & <U>')
end

do
    node:reset()

    local K = node.generic 'K'
    local V = node.generic 'V'
    local pack = node.genericPack { K, V }
    local alias = node.type 'Alias'
    alias:addParams { K, V }

    local aliasValue = K | V | node.BOOLEAN
    alias:addAlias(aliasValue)
    assert(aliasValue.value:view() == '<K> | <V> | boolean')

    assert(alias:view() == 'Alias<K, V>')

    local newAlias = alias:resolveGeneric {
        [K] = node.STRING,
        [V] = node.NUMBER,
    }
    assert(newAlias:view() == 'Alias<string, number>')

    newAlias = alias:call { node.NUMBER, node.STRING }
    assert(newAlias:view() == 'Alias<number, string>')

    assert(newAlias.value:view() == 'number | string | boolean')
end

do
    node.TYPE_POOL['Alias'] = nil

    --[[
    ---@alias Alias<K, V:number> K | V | boolean
    ]]

    local K = node.generic 'K'
    local V = node.generic('V', node.NUMBER)
    local alias = node.type 'Alias'
    alias:addParams { K, V }

    local aliasValue = K | V | node.BOOLEAN
    alias:addAlias(aliasValue)
    assert(aliasValue:view() == '<K> | <V:number> | boolean')

    assert(alias:view() == 'Alias<K, V:number>')
    assert(alias.value:view() == '<K> | <V:number> | boolean')

    local alias0 = alias:call()
    assert(alias0:view() == 'Alias<any, number>')
    assert(alias0.value:view() == 'any | number | boolean')

    local alias1 = alias:call { node.STRING }
    assert(alias1:view() == 'Alias<string, number>')
    assert(alias1.value:view() == 'string | number | boolean')

    local alias2 = alias:call { node.STRING, node.INTEGER }
    assert(alias2:view() == 'Alias<string, integer>')
    assert(alias2.value:view() == 'string | integer | boolean')

    local alias3 = alias:call { node.STRING, node.INTEGER, node.TABLE }
    assert(alias3:view() == 'Alias<string, integer>')
    assert(alias3.value:view() == 'string | integer | boolean')
end

do
    node.TYPE_POOL['Alias'] = nil

    --[[
    ---@alias Alias<K, V:number> { [K]: V }
    ]]

    local K = node.generic 'K'
    local V = node.generic('V', node.NUMBER)
    local alias = node.type 'Alias'
    alias:addParams { K, V }

    local aliasValue = node.table { [K] = V }
    alias:addAlias(aliasValue)
    assert(aliasValue:view() == '{ [<K>]: <V:number> }')

    assert(alias:view() == 'Alias<K, V:number>')
    assert(alias.value:view() == '{ [<K>]: <V:number> }')

    local alias0 = alias:call()
    assert(alias0:view() == 'Alias<any, number>')
    assert(alias0.value:view() == '{ [any]: number }')
    assert(alias0:get(1):view() == 'number')
    assert(alias0:get('x'):view() == 'number')

    local alias1 = alias:call { node.STRING }
    assert(alias1:view() == 'Alias<string, number>')
    assert(alias1.value:view() == '{ [string]: number }')
    assert(alias1:get(1):view() == 'nil')
    assert(alias1:get('x'):view() == 'number')

    local alias2 = alias:call { node.STRING, node.INTEGER }
    assert(alias2:view() == 'Alias<string, integer>')
    assert(alias2.value:view() == '{ [string]: integer }')
    assert(alias2:get(1):view() == 'nil')
    assert(alias2:get('x'):view() == 'integer')
end

do
    node.TYPE_POOL['Alias'] = nil

    --[[
    ---@alias Alias<A, B> xyz`A`.`B`.xyz | `A`[]
    ]]

    local A = node.generic 'A'
    local B = node.generic 'B'
    local alias = node.type 'Alias'
    alias:addParams { A, B }

    local aliasValue = node.union {
        node.template('xyz`A`.`B`.xyz', {
            A = A,
            B = B,
        }),
        node.array(
            node.template('`A`', {
                A = A,
            })
        ),
    }
    alias:addAlias(aliasValue)
    assert(aliasValue:view() == 'unknown | unknown[]')

    local alias1 = alias:call { node.value 'X' }
    assert(alias1:view() == 'Alias<"X", any>')
    assert(alias1.value:view() == 'unknown | X[]')

    local alias2 = alias:call { node.value 'X', node.value 'Y' }
    assert(alias2.value:view() == 'xyzX.Y.xyz | X[]')

    local alias3 = alias:call { node.value 'X1' | node.value 'X2', node.value 'Y1' | node.value 'Y2' }
    assert(alias3.value:view() == 'xyzX1.Y1.xyz | xyzX1.Y2.xyz | xyzX2.Y1.xyz | xyzX2.Y2.xyz | (X1 | X2)[]')
end

do
    node.TYPE_POOL['Map'] = nil

    --[[
    ---@class Map<K, V:number>
    ---@field [K] V
    ]]

    local K = node.generic 'K'
    local V = node.generic('V', node.NUMBER)
    local map = node.type 'Map'
    map:addParams { K, V }

    map:addField {
        key   = K,
        value = V,
    }

    assert(map:view() == 'Map<K, V:number>')
    assert(map.value:view() == '{ [<K>]: <V:number> }')

    local map2 = map:call { node.STRING, node.INTEGER }
    assert(map2:view() == 'Map<string, integer>')
    assert(map2.value:view() == '{ [string]: integer }')
    assert(map2:get(1):view() == 'nil')
    assert(map2:get('x'):view() == 'integer')
end

do
    node.TYPE_POOL['Map'] = nil

    --[[
    ---@class Map<K, V:number>
    ---@field set fun(key: K, value: V)
    ---@field get fun(key: K): V
    ]]

    local K = node.generic 'K'
    local V = node.generic('V', node.NUMBER)
    local map = node.type 'Map'
    map:addParams { K, V }

    map:addField {
        key   = node.value 'set',
        value = node.func()
            : addParamDef('key', K)
            : addParamDef('value', V),
    }
    map:addField {
        key   = node.value 'get',
        value = node.func()
            : addParamDef('key', K)
            : addReturnDef(nil, V),
    }

    assert(map.value:view() == '{ get: fun(key: <K>):<V:number>, set: fun(key: <K>, value: <V:number>) }')
    assert(map.value:get('set'):view() == 'fun(key: <K>, value: <V:number>)')
    assert(map:get('set'):view() == 'fun(key: any, value: number)')

    local map2 = map:call { node.STRING, node.INTEGER }
    assert(map2.value:view() == '{ get: fun(key: string):integer, set: fun(key: string, value: integer) }')
    assert(map2:get('set'):view() == 'fun(key: string, value: integer)')
    assert(map2.value:get('set'):view() == 'fun(key: string, value: integer)')
end

do
    node.TYPE_POOL['Map'] = nil

    --[[
    ---@class Map<K>
    ---@field set fun<V>(key: K, value: V)
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addParams { K }

    map:addField {
        key   = node.value 'set',
        value = node.func()
            : bindGenerics { V }
            : addParamDef('key', K)
            : addParamDef('value', V),
    }

    assert(map.value:view() == '{ set: fun<V>(key: <K>, value: <V>) }')
    assert(map.value:get('set'):view() == 'fun<V>(key: <K>, value: <V>)')
    assert(map:get('set'):view() == 'fun<V>(key: any, value: <V>)')

    local map1 = map:call { node.STRING }
    assert(map1.value:view() == '{ set: fun<V>(key: string, value: <V>) }')
    assert(map1:get('set'):view() == 'fun<V>(key: string, value: <V>)')
    assert(map1.value:get('set'):view() == 'fun<V>(key: string, value: <V>)')

    local func = map1:get('set')
    ---@cast func Node.Function
    assert(func:view() == 'fun<V>(key: string, value: <V>)')
    local rfunc = func:resolveGeneric { [V] = node.INTEGER }
    assert(rfunc:view() == 'fun<integer>(key: string, value: integer)')
end

do
    node.TYPE_POOL['Map'] = nil
    node.TYPE_POOL['Unit'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit
    ---@field childs Map<integer, Unit>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addParams { K, V }

    map:addField {
        key   = node.value 'set',
        value = node.func()
            : addParamDef('key', K)
            : addParamDef('value', V),
    }

    local unit = node.type 'Unit'
    unit:addField {
        key   = node.value 'childs',
        value = map:call { node.INTEGER, unit },
    }

    assert(unit.value:view() == '{ childs: Map<integer, Unit> }')
    assert(unit:get('childs'):view() == 'Map<integer, Unit>')
    assert(unit:get('childs').value:view() == '{ set: fun(key: integer, value: Unit) }')
end

do
    node.TYPE_POOL['Map'] = nil
    node.TYPE_POOL['Unit'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit<T>
    ---@field childs Map<T, string>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addParams { K, V }
    map:addField {
        key   = node.value 'set',
        value = node.func()
            : addParamDef('key', K)
            : addParamDef('value', V),
    }

    local T = node.generic 'T'
    local unit = node.type 'Unit'
    unit:addParams { T }
    unit:addField {
        key   = node.value 'childs',
        value = map:call { T, node.STRING },
    }

    assert(unit.value:view() == '{ childs: Map<<T>, string> }')
    assert(unit.value:get('childs'):view() == 'Map<<T>, string>')
    assert(unit.value:get('childs').value:view() == '{ set: fun(key: <T>, value: string) }')
    assert(unit:get('childs'):view() == 'Map<any, string>')
    assert(unit:get('childs').value:view() == '{ set: fun(key: any, value: string) }')

    local unit2 = unit:call { node.NUMBER }
    assert(unit2.value:view() == '{ childs: Map<number, string> }')
    assert(unit2.value:get('childs'):view() == 'Map<number, string>')
    assert(unit2.value:get('childs').value:view() == '{ set: fun(key: number, value: string) }')
    assert(unit2:get('childs'):view() == 'Map<number, string>')
    assert(unit2:get('childs').value:view() == '{ set: fun(key: number, value: string) }')
end

do
    node.TYPE_POOL['Map'] = nil
    node.TYPE_POOL['OrderMap'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap: Map<number, string>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addParams { K, V }
    map:addField {
        key   = node.value 'set',
        value = node.func()
            : addParamDef('key', K)
            : addParamDef('value', V),
    }

    local omap = node.type 'OrderMap'
    omap:addExtends(map:call { node.NUMBER, node.STRING })

    assert(omap:get('set'):view() == 'fun(key: number, value: string)')
end

do
    node.TYPE_POOL['Map'] = nil
    node.TYPE_POOL['OrderMap'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap: Map<number, string>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addParams { K, V }
    map:addField {
        key   = node.value 'set',
        value = node.func()
            : addParamDef('key', K)
            : addParamDef('value', V),
    }

    local omap = node.type 'OrderMap'
    omap:addExtends(map:call { node.NUMBER, node.STRING })

    assert(omap:get('set'):view() == 'fun(key: number, value: string)')
end

do
    node.TYPE_POOL['Map'] = nil
    node.TYPE_POOL['OrderMap'] = nil

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap<OK:number, OV>: Map<OK, OV>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addParams { K, V }
    map:addField {
        key   = node.value 'set',
        value = node.func()
            : addParamDef('key', K)
            : addParamDef('value', V),
    }

    local OK = node.generic('OK', node.NUMBER)
    local OV = node.generic 'OV'
    local omap = node.type 'OrderMap'
    omap:addParams { OK, OV }
    omap:addExtends(map:call { OK, OV })

    assert(omap:get('set'):view() == 'fun(key: number, value: any)')

    local omap2 = omap:call { node.INTEGER, node.STRING }

    assert(omap2:get('set'):view() == 'fun(key: integer, value: string)')
end
