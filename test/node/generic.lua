local rt = test.scope.rt

do
    local K = rt.generic('K')
    local V = rt.generic('V')

    lt.assertEquals(K:view(), '<K>')
    lt.assertEquals(V:view(), '<V>')

    local table = rt.table { [K] = V }

    lt.assertEquals(table:view(), '{ [<K>]: <V> }')

    local t1 = table:resolveGeneric {}
    lt.assertEquals(t1:view(), '{ [<K>]: <V> }')

    local t2 = table:resolveGeneric { [K] = rt.INTEGER }
    lt.assertEquals(t2:view(), '{ [integer]: <V> }')

    local t3 = table:resolveGeneric { [V] = rt.BOOLEAN }
    lt.assertEquals(t3:view(), '{ [<K>]: boolean }')

    local t4 = table:resolveGeneric { [K] = rt.STRING, [V] = rt.NUMBER }
    lt.assertEquals(t4:view(), '{ [string]: number }')
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

    lt.assertEquals(N:view(), '<N>')
    lt.assertEquals(U:view(), '<U>')

    lt.assertEquals(array:view(), '<N>[]')

    lt.assertEquals(tuple:view(), '[<N>, <U>]')

    lt.assertEquals(table:view(), '{ [<N>]: <U> }')

    lt.assertEquals(func:view(), 'fun(a: <N>, ...: <U>):[<N>, <U>]')
    func:addTypeParam(N)
    func:addTypeParam(U)
    lt.assertEquals(func:view(), 'fun<N:number, U>(a: <N>, ...: <U>):[<N>, <U>]')

    lt.assertEquals(union:view(), '<N> | <U>')

    lt.assertEquals(intersection:view(), '<N> & <U>')

    local resolve = { [N] = rt.INTEGER }

    local newArray = array:resolveGeneric(resolve)
    lt.assertEquals(newArray:view(), 'integer[]')

    local newTuple = tuple:resolveGeneric(resolve)
    lt.assertEquals(newTuple:view(), '[integer, <U>]')

    local newTable = table:resolveGeneric(resolve)
    lt.assertEquals(newTable:view(), '{ [integer]: <U> }')

    local newFunc = func:resolveGeneric(resolve)
    lt.assertEquals(newFunc:view(), 'fun<integer, U>(a: integer, ...: <U>):[integer, <U>]')

    local newUnion = union:resolveGeneric(resolve)
    lt.assertEquals(newUnion:view(), 'integer | <U>')

    local newIntersection = intersection:resolveGeneric(resolve)
    lt.assertEquals(newIntersection:view(), 'integer & <U>')
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

    lt.assertEquals(alias:view(), 'Alias')
    lt.assertEquals(aliasValue.value:view(), '<K> | <V> | boolean')

    local call = alias:call { rt.NUMBER, rt.STRING }
    lt.assertEquals(call:view(), 'number | string | boolean')
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

    lt.assertEquals(alias:view(), 'Alias')
    lt.assertEquals(alias.value:view(), '{ [any]: any }')

    local alias1 = alias:call { rt.STRING }
    lt.assertEquals(alias1:view(), '{ [string]: boolean }')
    lt.assertEquals(alias1:get(1):view(), 'nil')
    lt.assertEquals(alias1:get('x'):view(), 'boolean')

    local alias2 = alias:call { rt.STRING, rt.INTEGER }
    lt.assertEquals(alias2:view(), '{ [string]: integer }')
    lt.assertEquals(alias2:get(1):view(), 'nil')
    lt.assertEquals(alias2:get('x'):view(), 'integer')
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
        rt.template {'xyz', A, '.', B, '.xyz'},
        rt.array(
            rt.template { A }
        ),
    }
    rt.alias('Alias', { A, B }, aliasValue)
    lt.assertEquals(aliasValue:view(), 'unknown | unknown[]')

    local alias1 = alias:call { rt.value 'X', rt.ANY }
    lt.assertEquals(alias1:view(), 'unknown | X[]')

    local alias2 = alias:call { rt.value 'X', rt.value 'Y' }
    lt.assertEquals(alias2:view(), 'xyzX.Y.xyz | X[]')

    local alias3 = alias:call { rt.value 'X1' | rt.value 'X2', rt.value 'Y1' | rt.value 'Y2' }
    lt.assertEquals(alias3:view(), 'xyzX1.Y1.xyz | xyzX1.Y2.xyz | xyzX2.Y1.xyz | xyzX2.Y2.xyz | (X1 | X2)[]')
end

do
    rt:reset()
    --[[
    ---@alias Alias<A> abc.`A`
    ]]
    local A = rt.generic 'A'
    local alias = rt.type 'Alias'
    rt.alias('Alias', { A }, rt.oddTemplate { 'abc', A })

    local alias1 = alias:call { rt.value 'X' }
    lt.assertEquals(alias1:view(), '"X"')
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

    lt.assertEquals(map:view(), 'Map')
    lt.assertEquals(map.value:view(), '{}')

    local map2 = map:call { rt.STRING, rt.INTEGER }
    lt.assertEquals(map2:view(), 'Map<string, integer>')
    lt.assertEquals(map2.value:view(), '{ [string]: integer }')
    lt.assertEquals(map2:get(1):view(), 'nil')
    lt.assertEquals(map2:get('x'):view(), 'integer')
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
    lt.assertEquals(map2:view(), 'Map<string, integer>')
    lt.assertEquals(map2.value:view(), '{ [string]: integer }')
    lt.assertEquals(map2:get(1):view(), 'nil')
    lt.assertEquals(map2:get('x'):view(), 'integer')
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
    lt.assertEquals(map2.value:view(), [[
{
    get: fun(key: string):integer,
    set: fun(key: string, value: integer),
}]])
    lt.assertEquals(map2:get('set'):view(), 'fun(key: string, value: integer)')
    lt.assertEquals(map2.value:get('set'):view(), 'fun(key: string, value: integer)')
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
    lt.assertEquals(map1.value:view(), '{ set: fun<V>(key: string, value: <V>) }')
    lt.assertEquals(map1:get('set'):view(), 'fun<V>(key: string, value: <V>)')
    lt.assertEquals(map1.value:get('set'):view(), 'fun<V>(key: string, value: <V>)')

    local func = map1:get('set')
    ---@cast func Node.Function
    lt.assertEquals(func:view(), 'fun<V>(key: string, value: <V>)')
    local rfunc = func:resolveGeneric { [V] = rt.INTEGER }
    lt.assertEquals(rfunc:view(), 'fun<integer>(key: string, value: integer)')
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

    lt.assertEquals(unit.value:view(), '{ childs: Map<integer, Unit> }')
    lt.assertEquals(unit:get('childs'):view(), 'Map<integer, Unit>')
    lt.assertEquals(unit:get('childs'):finalValue():view(), '{ set: fun(key: integer, value: Unit) }')
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
    lt.assertEquals(unit2.value:view(), '{ childs: Map<number, string> }')
    lt.assertEquals(unit2.value:get('childs'):view(), 'Map<number, string>')
    lt.assertEquals(unit2.value:get('childs'):finalValue():view(), '{ set: fun(key: number, value: string) }')
    lt.assertEquals(unit2:get('childs'):view(), 'Map<number, string>')
    lt.assertEquals(unit2:get('childs'):finalValue():view(), '{ set: fun(key: number, value: string) }')
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

    lt.assertEquals(omap:get('set'):view(), 'fun(key: number, value: string)')
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

    lt.assertEquals(omap2:get('set'):view(), 'fun(key: integer, value: string)')
end
