local node = test.scope.node

do
    local K = node.generic('K')
    local V = node.generic('V')

    assert(K:view() == '<K>')
    assert(V:view() == '<V>')

    local table = node.table { [K] = V }

    assert(table:view() == '{ [<K>]: <V> }')

    local t1 = table:resolveGeneric {}
    assert(t1:view() == '{ [<K>]: <V> }')

    local t2 = table:resolveGeneric { [K] = node.INTEGER }
    assert(t2:view() == '{ [integer]: <V> }')

    local t3 = table:resolveGeneric { [V] = node.BOOLEAN }
    assert(t3:view() == '{ [<K>]: boolean }')

    local t4 = table:resolveGeneric { [K] = node.STRING, [V] = node.NUMBER }
    assert(t4:view() == '{ [string]: number }')
end

do
    local N = node.generic('N', node.NUMBER)
    local U = node.generic 'U'
    local array = node.array(N)
    local tuple = node.tuple { N, U }
    local table = node.table { [N] = U }
    local func  = node.func()
        : addParamDef('a', N)
        : addVarargParamDef(U)
        : addReturnDef(nil, tuple)
    local union = N | U
    local intersection = N & U

    assert(N:view() == '<N>')
    assert(U:view() == '<U>')

    assert(array:view() == '<N>[]')

    assert(tuple:view() == '[<N>, <U>]')

    assert(table:view() == '{ [<N>]: <U> }')

    assert(func:view() == 'fun(a: <N>, ...: <U>):[<N>, <U>]')
    func:addTypeParam(N)
    func:addTypeParam(U)
    assert(func:view() == 'fun<N:number, U>(a: <N>, ...: <U>):[<N>, <U>]')

    assert(union:view() == '<N> | <U>')

    assert(intersection:view() == '<N> & <U>')

    local resolve = { [N] = node.INTEGER }

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

    --[[
    ---@alias Alias<K, V> K | V | boolean
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local alias = node.type 'Alias'
    local aliasValue = K | V | node.BOOLEAN

    alias:addAlias(node.alias('Alias', { K, V }, aliasValue))

    assert(alias:view() == 'Alias')
    assert(aliasValue.value:view() == '<K> | <V> | boolean')

    local call = alias:call { node.NUMBER, node.STRING }
    assert(call:view() == 'Alias<number, string>')

    assert(call.value:view() == 'number | string | boolean')
end

do
    node:reset()

    --[[
    ---@alias Alias { [any]: any }
    ---@alias Alias<T> { [T]: boolean }
    ---@alias Alias<K, V> { [K]: V }
    ]]

    local T = node.generic 'T'
    local K = node.generic 'K'
    local V = node.generic('V')
    local alias = node.type 'Alias'

    alias:addAlias(node.alias('Alias', nil, node.table { [node.ANY] = node.ANY }))
    alias:addAlias(node.alias('Alias', { T }, node.table { [T] = node.BOOLEAN }))
    alias:addAlias(node.alias('Alias', { K, V }, node.table { [K] = V }))

    assert(alias:view() == 'Alias')
    assert(alias.value:view() == '{ [any]: any }')

    local alias1 = alias:call { node.STRING }
    assert(alias1:view() == 'Alias<string>')
    assert(alias1.value:view() == '{ [string]: boolean }')
    assert(alias1:get(1):view() == 'nil')
    assert(alias1:get('x'):view() == 'boolean')

    local alias2 = alias:call { node.STRING, node.INTEGER }
    assert(alias2:view() == 'Alias<string, integer>')
    assert(alias2.value:view() == '{ [string]: integer }')
    assert(alias2:get(1):view() == 'nil')
    assert(alias2:get('x'):view() == 'integer')
end

do
    node:reset()

    --[[
    ---@alias Alias<A, B> xyz`A`.`B`.xyz | `A`[]
    ]]

    local A = node.generic 'A'
    local B = node.generic 'B'
    local alias = node.type 'Alias'

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
    alias:addAlias(node.alias('Alias', { A, B }, aliasValue))
    assert(aliasValue:view() == 'unknown | unknown[]')

    local alias1 = alias:call { node.value 'X', node.ANY }
    assert(alias1:view() == 'Alias<"X", any>')
    assert(alias1.value:view() == 'unknown | X[]')

    local alias2 = alias:call { node.value 'X', node.value 'Y' }
    assert(alias2.value:view() == 'xyzX.Y.xyz | X[]')

    local alias3 = alias:call { node.value 'X1' | node.value 'X2', node.value 'Y1' | node.value 'Y2' }
    assert(alias3.value:view() == 'xyzX1.Y1.xyz | xyzX1.Y2.xyz | xyzX2.Y1.xyz | xyzX2.Y2.xyz | (X1 | X2)[]')
end

do
    node:reset()

    --[[
    ---@class Map<K, V>
    ---@field [K] V
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'

    map:addClass(node.class('Map', { K, V })
        : addField {
            key   = K,
            value = V,
        }
    )

    assert(map:view() == 'Map')
    assert(map.value:view() == '{}')

    local map2 = map:call { node.STRING, node.INTEGER }
    assert(map2:view() == 'Map<string, integer>')
    assert(map2.value:view() == '{ [string]: integer }')
    assert(map2:get(1):view() == 'nil')
    assert(map2:get('x'):view() == 'integer')
end

do
    node:reset()

    --[[
    ---@class Map<K, V>: { [K]: V }
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'

    local map = node.type 'Map'
        : addClass(node.class('Map', { K, V }, {
            node.table { [K] = V }
        }))

    local map2 = map:call { node.STRING, node.INTEGER }
    assert(map2:view() == 'Map<string, integer>')
    assert(map2.value:view() == '{ [string]: integer }')
    assert(map2:get(1):view() == 'nil')
    assert(map2:get('x'):view() == 'integer')
end

do
    node:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)
    ---@field get fun(key: K): V
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'

    map:addClass(node.class('Map', { K, V })
        : addField {
            key   = node.value 'set',
            value = node.func()
                : addParamDef('key', K)
                : addParamDef('value', V),
        }
        : addField {
            key   = node.value 'get',
            value = node.func()
                : addParamDef('key', K)
                : addReturnDef(nil, V),
        }
    )

    local map2 = map:call { node.STRING, node.INTEGER }
    assert(map2.value:view() == '{ get: fun(key: string):integer, set: fun(key: string, value: integer) }')
    assert(map2:get('set'):view() == 'fun(key: string, value: integer)')
    assert(map2.value:get('set'):view() == 'fun(key: string, value: integer)')
end

do
    node:reset()

    --[[
    ---@class Map<K>
    ---@field set fun<V>(key: K, value: V)
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addClass(node.class('Map', { K })
        : addField {
            key   = node.value 'set',
            value = node.func()
                : addTypeParam(V)
                : addParamDef('key', K)
                : addParamDef('value', V),
        }
    )

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
    node:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit
    ---@field childs Map<integer, Unit>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addClass(node.class('Map', { K, V })
        : addField {
            key   = node.value 'set',
            value = node.func()
                : addParamDef('key', K)
                : addParamDef('value', V),
        }
    )

    local unit = node.type 'Unit'
    unit:addClass(node.class('Unit')
        : addField {
            key   = node.value 'childs',
            value = map:call { node.INTEGER, unit },
        }
    )

    assert(unit.value:view() == '{ childs: Map<integer, Unit> }')
    assert(unit:get('childs'):view() == 'Map<integer, Unit>')
    assert(unit:get('childs').value:view() == '{ set: fun(key: integer, value: Unit) }')
end

do
    node:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit<T>
    ---@field childs Map<T, string>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addClass(node.class('Map', { K, V })
        :addField {
            key   = node.value 'set',
            value = node.func()
                : addParamDef('key', K)
                : addParamDef('value', V),
        }
    )

    local T = node.generic 'T'
    local unit = node.type 'Unit'
    unit:addClass(node.class('Unit', { T })
        :addField {
            key   = node.value 'childs',
            value = map:call { T, node.STRING },
        }
    )

    local unit2 = unit:call { node.NUMBER }
    assert(unit2.value:view() == '{ childs: Map<number, string> }')
    assert(unit2.value:get('childs'):view() == 'Map<number, string>')
    assert(unit2.value:get('childs').value:view() == '{ set: fun(key: number, value: string) }')
    assert(unit2:get('childs'):view() == 'Map<number, string>')
    assert(unit2:get('childs').value:view() == '{ set: fun(key: number, value: string) }')
end

do
    node:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap: Map<number, string>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addClass(node.class('Map', { K, V })
        : addField {
            key   = node.value 'set',
            value = node.func()
                : addParamDef('key', K)
                : addParamDef('value', V),
        }
    )

    local omap = node.type 'OrderMap'
    omap:addClass(node.class('OrderMap', nil, { map:call { node.NUMBER, node.STRING } }))

    assert(omap:get('set'):view() == 'fun(key: number, value: string)')
end

do
    node:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap<OK, OV>: Map<OK, OV>
    ]]

    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = node.type 'Map'
    map:addClass(node.class('Map', { K, V })
        : addField {
            key   = node.value 'set',
            value = node.func()
                : addParamDef('key', K)
                : addParamDef('value', V),
        }
    )

    local OK = node.generic('OK', node.NUMBER)
    local OV = node.generic 'OV'
    local omap = node.type 'OrderMap'
    omap:addClass(node.class('OrderMap', { OK, OV }, { map:call { OK, OV } }))

    local omap2 = omap:call { node.INTEGER, node.STRING }

    assert(omap2:get('set'):view() == 'fun(key: integer, value: string)')
end
