local rt = test.scope.rt

do
    local K = rt.generic('K')
    local V = rt.generic('V')

    assert(K:view() == '<K>')
    assert(V:view() == '<V>')

    local table = rt.table { [K] = V }

    assert(table:view() == '{ [<K>]: <V> }')

    local t1 = table:resolveGeneric {}
    assert(t1:view() == '{ [<K>]: <V> }')

    local t2 = table:resolveGeneric { [K] = rt.INTEGER }
    assert(t2:view() == '{ [integer]: <V> }')

    local t3 = table:resolveGeneric { [V] = rt.BOOLEAN }
    assert(t3:view() == '{ [<K>]: boolean }')

    local t4 = table:resolveGeneric { [K] = rt.STRING, [V] = rt.NUMBER }
    assert(t4:view() == '{ [string]: number }')
end

do
    local N = rt.generic('N', rt.NUMBER)
    local U = rt.generic 'U'
    local array = rt.array(N)
    local tuple = rt.tuple { N, U }
    local table = rt.table { [N] = U }
    local func  = rt.func()
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

    local resolve = { [N] = rt.INTEGER }

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
    rt:reset()

    --[[
    ---@alias Alias<K, V> K | V | boolean
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local alias = rt.type 'Alias'
    local aliasValue = K | V | rt.BOOLEAN

    rt.alias('Alias', { K, V }, aliasValue)

    assert(alias:view() == 'Alias')
    assert(aliasValue.value:view() == '<K> | <V> | boolean')

    local call = alias:call { rt.NUMBER, rt.STRING }
    assert(call:view() == 'Alias<number, string>')

    assert(call.value:view() == 'number | string | boolean')
end

do
    rt:reset()

    --[[
    ---@alias Alias { [any]: any }
    ---@alias Alias<T> { [T]: boolean }
    ---@alias Alias<K, V> { [K]: V }
    ]]

    local T = rt.generic 'T'
    local K = rt.generic 'K'
    local V = rt.generic('V')
    local alias = rt.type 'Alias'

    rt.alias('Alias', nil, rt.table { [rt.ANY] = rt.ANY })
    rt.alias('Alias', { T }, rt.table { [T] = rt.BOOLEAN })
    rt.alias('Alias', { K, V }, rt.table { [K] = V })

    assert(alias:view() == 'Alias')
    assert(alias.value:view() == '{ [any]: any }')

    local alias1 = alias:call { rt.STRING }
    assert(alias1:view() == 'Alias<string>')
    assert(alias1.value:view() == '{ [string]: boolean }')
    assert(alias1:get(1):view() == 'nil')
    assert(alias1:get('x'):view() == 'boolean')

    local alias2 = alias:call { rt.STRING, rt.INTEGER }
    assert(alias2:view() == 'Alias<string, integer>')
    assert(alias2.value:view() == '{ [string]: integer }')
    assert(alias2:get(1):view() == 'nil')
    assert(alias2:get('x'):view() == 'integer')
end

do
    rt:reset()

    --[[
    ---@alias Alias<A, B> xyz`A`.`B`.xyz | `A`[]
    ]]

    local A = rt.generic 'A'
    local B = rt.generic 'B'
    local alias = rt.type 'Alias'

    local aliasValue = rt.union {
        rt.template('xyz`A`.`B`.xyz', {
            A = A,
            B = B,
        }),
        rt.array(
            rt.template('`A`', {
                A = A,
            })
        ),
    }
    rt.alias('Alias', { A, B }, aliasValue)
    assert(aliasValue:view() == 'unknown | unknown[]')

    local alias1 = alias:call { rt.value 'X', rt.ANY }
    assert(alias1:view() == 'Alias<"X", any>')
    assert(alias1.value:view() == 'unknown | X[]')

    local alias2 = alias:call { rt.value 'X', rt.value 'Y' }
    assert(alias2.value:view() == 'xyzX.Y.xyz | X[]')

    local alias3 = alias:call { rt.value 'X1' | rt.value 'X2', rt.value 'Y1' | rt.value 'Y2' }
    assert(alias3.value:view() == 'xyzX1.Y1.xyz | xyzX1.Y2.xyz | xyzX2.Y1.xyz | xyzX2.Y2.xyz | (X1 | X2)[]')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>
    ---@field [K] V
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'

    rt.class('Map', { K, V })
        : addField(rt.field(K, V))

    assert(map:view() == 'Map')
    assert(map.value:view() == '{}')

    local map2 = map:call { rt.STRING, rt.INTEGER }
    assert(map2:view() == 'Map<string, integer>')
    assert(map2.value:view() == '{ [string]: integer }')
    assert(map2:get(1):view() == 'nil')
    assert(map2:get('x'):view() == 'integer')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>: { [K]: V }
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'

    local map = rt.type 'Map'
    rt.class('Map', { K, V }, {
        rt.table { [K] = V }
    })

    local map2 = map:call { rt.STRING, rt.INTEGER }
    assert(map2:view() == 'Map<string, integer>')
    assert(map2.value:view() == '{ [string]: integer }')
    assert(map2:get(1):view() == 'nil')
    assert(map2:get('x'):view() == 'integer')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)
    ---@field get fun(key: K): V
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'

    rt.class('Map', { K, V })
        : addField(rt.field('set', rt.func()
            : addParamDef('key', K)
            : addParamDef('value', V)
        ))
        : addField(rt.field('get', rt.func()
                : addParamDef('key', K)
                : addReturnDef(nil, V)
        ))

    local map2 = map:call { rt.STRING, rt.INTEGER }
    assert(map2.value:view() == '{ get: fun(key: string):integer, set: fun(key: string, value: integer) }')
    assert(map2:get('set'):view() == 'fun(key: string, value: integer)')
    assert(map2.value:get('set'):view() == 'fun(key: string, value: integer)')
end

do
    rt:reset()

    --[[
    ---@class Map<K>
    ---@field set fun<V>(key: K, value: V)
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'
    rt.class('Map', { K })
        : addField(rt.field('set', rt.func()
                : addTypeParam(V)
                : addParamDef('key', K)
                : addParamDef('value', V)
            ))

    local map1 = map:call { rt.STRING }
    assert(map1.value:view() == '{ set: fun<V>(key: string, value: <V>) }')
    assert(map1:get('set'):view() == 'fun<V>(key: string, value: <V>)')
    assert(map1.value:get('set'):view() == 'fun<V>(key: string, value: <V>)')

    local func = map1:get('set')
    ---@cast func Node.Function
    assert(func:view() == 'fun<V>(key: string, value: <V>)')
    local rfunc = func:resolveGeneric { [V] = rt.INTEGER }
    assert(rfunc:view() == 'fun<integer>(key: string, value: integer)')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit
    ---@field childs Map<integer, Unit>
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'
    rt.class('Map', { K, V })
        : addField(rt.field('set', rt.func()
                : addParamDef('key', K)
                : addParamDef('value', V)
            ))

    local unit = rt.type 'Unit'
    rt.class('Unit')
        : addField(rt.field('childs', map:call { rt.INTEGER, unit }))

    assert(unit.value:view() == '{ childs: Map<integer, Unit> }')
    assert(unit:get('childs'):view() == 'Map<integer, Unit>')
    assert(unit:get('childs'):finalValue():view() == '{ set: fun(key: integer, value: Unit) }')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class Unit<T>
    ---@field childs Map<T, string>
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'
    rt.class('Map', { K, V })
        :addField(rt.field('set', rt.func()
            : addParamDef('key', K)
            : addParamDef('value', V)
        ))

    local T = rt.generic 'T'
    local unit = rt.type 'Unit'
    rt.class('Unit', { T })
        :addField(rt.field('childs', map:call { T, rt.STRING }))

    local unit2 = unit:call { rt.NUMBER }
    assert(unit2.value:view() == '{ childs: Map<number, string> }')
    assert(unit2.value:get('childs'):view() == 'Map<number, string>')
    assert(unit2.value:get('childs'):finalValue():view() == '{ set: fun(key: number, value: string) }')
    assert(unit2:get('childs'):view() == 'Map<number, string>')
    assert(unit2:get('childs'):finalValue():view() == '{ set: fun(key: number, value: string) }')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap: Map<number, string>
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'
    rt.class('Map', { K, V })
        : addField(rt.field('set', rt.func()
            : addParamDef('key', K)
            : addParamDef('value', V)
        ))

    local omap = rt.type 'OrderMap'
    rt.class('OrderMap', nil, { map:call { rt.NUMBER, rt.STRING } })

    assert(omap:get('set'):view() == 'fun(key: number, value: string)')
end

do
    rt:reset()

    --[[
    ---@class Map<K, V>
    ---@field set fun(key: K, value: V)

    ---@class OrderMap<OK, OV>: Map<OK, OV>
    ]]

    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = rt.type 'Map'
    rt.class('Map', { K, V })
        : addField(rt.field('set', rt.func()
            : addParamDef('key', K)
            : addParamDef('value', V)
        ))

    local OK = rt.generic('OK', rt.NUMBER)
    local OV = rt.generic 'OV'
    local omap = rt.type 'OrderMap'
    rt.class('OrderMap', { OK, OV }, { map:call { OK, OV } })

    local omap2 = omap:call { rt.INTEGER, rt.STRING }

    assert(omap2:get('set'):view() == 'fun(key: integer, value: string)')
end
