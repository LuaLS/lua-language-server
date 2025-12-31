local rt = test.scope.rt

do
    local T = rt.generic 'T'
    local map = {}
    T:inferGeneric(rt.NUMBER, map)

    lt.assertEquals(map[T], rt.NUMBER)
end

do
    --[[
    T[] @ number[]
    T -> number
    ]]
    local T = rt.generic 'T'
    local map = {}
    local arrayT = rt.array(T)
    local arrayNumber = rt.array(rt.NUMBER)
    arrayT:inferGeneric(arrayNumber, map)

    lt.assertEquals(map[T], rt.NUMBER)
end

do
    --[[
    T[] @ {}
    T -> T
    ]]
    local T = rt.generic 'T'
    local map = {}
    local arrayT = rt.array(T)
    local table = rt.table()
    arrayT:inferGeneric(table, map)

    lt.assertEquals(map[T], nil)
end

do
    --[[
    T[] @ { [integer]: string }
    T -> string
    ]]
    local T = rt.generic 'T'
    local map = {}
    local arrayT = rt.array(T)
    local table = rt.table {
        [rt.INTEGER] = rt.STRING,
    }
    arrayT:inferGeneric(table, map)

    lt.assertEquals(map[T]:view(), 'string')
end

do
    --[[
    T[] @ { [number]: string }
    T -> string
    ]]
    local T = rt.generic 'T'
    local map = {}
    local arrayT = rt.array(T)
    local table = rt.table {
        [rt.NUMBER] = rt.STRING,
    }
    arrayT:inferGeneric(table, map)

    lt.assertEquals(map[T], rt.STRING)
end

do
    --[[
    T[] @ [number, string]
    T -> number|string
    ]]
    local T = rt.generic 'T'
    local map = {}
    local arrayT = rt.array(T)
    local table = rt.tuple {
        rt.NUMBER,
        rt.STRING,
    }
    arrayT:inferGeneric(table, map)

    lt.assertEquals(map[T]:view(), 'number | string')
end

do
    --[[
    [T1, T2] @ [number, string]
    T1 -> number
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tupleT1T2 = rt.tuple { T1, T2 }
    local tuple = rt.tuple {
        rt.NUMBER,
        rt.STRING,
    }
    tupleT1T2:inferGeneric(tuple, map)

    lt.assertEquals(map[T1], rt.NUMBER)
    lt.assertEquals(map[T2], rt.STRING)
end

do
    --[[
    [T1, T2] @ number[]
    T1 -> number
    T2 -> number
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tupleT1T2 = rt.tuple { T1, T2 }
    local target = rt.array(rt.NUMBER)
    tupleT1T2:inferGeneric(target, map)

    lt.assertEquals(map[T1], rt.NUMBER)
    lt.assertEquals(map[T2], rt.NUMBER)
end

do
    --[[
    [T1, T2] @ { [1]: number, [number]: string }
    T1 -> number
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tupleT1T2 = rt.tuple { T1, T2 }
    local target = rt.table {
        [1] = rt.NUMBER,
        [rt.NUMBER] = rt.STRING,
    }
    tupleT1T2:inferGeneric(target, map)

    lt.assertEquals(map[T1]:view(), 'number')
    lt.assertEquals(map[T2]:view(), 'string')
end

do
    --[[
    { [K]: V } @ { [number]: string }
    K -> number
    V -> string
    ]]
    local K = rt.generic 'V'
    local V = rt.generic 'V'
    local map = {}
    local tableKV = rt.table {
        [K] = V,
    }
    local target = rt.table {
        [rt.NUMBER] = rt.STRING,
    }
    tableKV:inferGeneric(target, map)

    lt.assertEquals(map[K]:view(), 'number')
    lt.assertEquals(map[V]:view(), 'string')
end

do
    --[[
    { [K]: V } @ string[]
    K -> integer
    V -> string
    ]]
    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = {}
    local tableKV = rt.table {
        [K] = V,
    }
    local target = rt.array(rt.STRING)
    tableKV:inferGeneric(target, map)

    lt.assertEquals(map[K], rt.INTEGER)
    lt.assertEquals(map[V], rt.STRING)
end

do
    --[[
    { [K]: V } @ [string, boolean]
    K -> 1 | 2
    V -> string | boolean
    ]]
    local K = rt.generic 'K'
    local V = rt.generic 'V'
    local map = {}
    local tableKV = rt.table {
        [K] = V,
    }
    local target = rt.tuple {
        rt.STRING,
        rt.BOOLEAN,
    }
    tableKV:inferGeneric(target, map)

    lt.assertEquals(map[K]:view(), '1 | 2')
    lt.assertEquals(map[V]:view(), 'string | boolean')
end

do
    --[[
    { x: T1, y: T2 } @ { x: number, y: string }
    T1 -> number
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tableKV = rt.table {
        x = T1,
        y = T2,
    }
    local target = rt.table {
        x = rt.NUMBER,
        y = rt.STRING,
    }
    tableKV:inferGeneric(target, map)

    lt.assertEquals(map[T1]:view(), 'number')
    lt.assertEquals(map[T2]:view(), 'string')
end

do
    --[[
    [T1, T2] @ [number, string]
    T1 -> number
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tupleG = rt.tuple { T1, T2 }
    local target = rt.tuple { rt.NUMBER, rt.STRING }
    tupleG:inferGeneric(target, map)

    lt.assertEquals(map[T1]:view(), 'number')
    lt.assertEquals(map[T2]:view(), 'string')
end

do
    --[[
    [T1, T2] @ string[]
    T1 -> string
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tupleG = rt.tuple { T1, T2 }
    local target = rt.array(rt.STRING)
    tupleG:inferGeneric(target, map)

    lt.assertEquals(map[T1]:view(), 'string')
    lt.assertEquals(map[T2]:view(), 'string')
end

do
    --[[
    [T1, T2] @ { [integer]: string, [2]: boolean }
    T1 -> string
    T2 -> boolean
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local map = {}
    local tupleG = rt.tuple { T1, T2 }
    local target = rt.table {
        [rt.INTEGER] = rt.STRING,
        [2] = rt.BOOLEAN,
    }
    tupleG:inferGeneric(target, map)

    lt.assertEquals(map[T1]:view(), 'string')
    lt.assertEquals(map[T2]:view(), 'boolean')
end

do
    --[[
    ---@class Map<K, V>
    ---@field [K] V
    
    Map<T1, T2> @ { [number]: string }
    T1 -> number
    T2 -> string
    ]]
    rt:reset()

    local map = rt.type 'Map'
    local K = rt.generic 'K'
    local V = rt.generic 'V'
    rt.class('Map', { K, V })
        : addField(rt.field(K, V))

    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local result = {}
    map:call { T1, T2 } :inferGeneric(rt.table {
        [rt.NUMBER] = rt.STRING
    }, result)
    lt.assertEquals(result[T1]:view(), 'number')
    lt.assertEquals(result[T2]:view(), 'string')
end

do
    --[[
    fun(x: T1): T2 @ fun(x: number): string
    T1 -> number
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local funG = rt.func()
        : addParamDef('x', T1)
        : addReturnDef(nil, T2)
    local target = rt.func()
        : addParamDef('x', rt.NUMBER)
        : addReturnDef(nil, rt.STRING)

    local result = {}
    funG:inferGeneric(target, result)

    lt.assertEquals(result[T1]:view(), 'number')
    lt.assertEquals(result[T2]:view(), 'string')
end

do
    --[[
    fun(x: T1, y: T2) @ fun(x: number, ...: string)
    T1 -> number
    T2 -> string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local funG = rt.func()
        : addParamDef('x', T1)
        : addParamDef('y', T2)
    local target = rt.func()
        : addParamDef('x', rt.NUMBER)
        : addVarargParamDef(rt.STRING)

    local result = {}
    funG:inferGeneric(target, result)

    lt.assertEquals(result[T1]:view(), 'number')
    lt.assertEquals(result[T2]:view(), 'string | nil')
end

do
    --[[
    fun(x: T1, ...: T2) @ fun(x: number, y: boolean, ...: string)
    T1 -> number
    T2 -> boolean | string
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local funG = rt.func()
        : addParamDef('x', T1)
        : addVarargParamDef(T2)
    local target = rt.func()
        : addParamDef('x', rt.NUMBER)
        : addParamDef('y', rt.BOOLEAN)
        : addVarargParamDef(rt.STRING)

    local result = {}
    funG:inferGeneric(target, result)

    lt.assertEquals(result[T1]:view(), 'number')
    lt.assertEquals(result[T2]:view(), 'boolean | string | nil')
end

do
    --[[
    T | number @ number
    T -> number
    ]]
    local T = rt.generic 'T'
    local u = rt.union { T, rt.NUMBER }

    local result = {}
    u:inferGeneric(rt.NUMBER, result)

    lt.assertEquals(result[T]:view(), 'number')
end

do
    --[[
    T & number @ number
    T -> number
    ]]
    local T = rt.generic 'T'
    local i = rt.intersection { T, rt.NUMBER }

    local result = {}
    i:inferGeneric(rt.NUMBER, result)

    lt.assertEquals(result[T]:view(), 'number')
end

do
    --[[
    fun<T1, T2>(x: T1, y: T2) @ fun(x: number)
    T1 -> number
    T2 -> unknown
    ]]
    local T1 = rt.generic 'T1'
    local T2 = rt.generic 'T2'
    local funG = rt.func()
        : addTypeParam(T1)
        : addTypeParam(T2)
        : addParamDef('x', T1)
        : addParamDef('y', T2)

    local target = rt.func()
        : addParamDef('x', rt.NUMBER)

    local result = {}
    funG:inferGeneric(target, result)

    lt.assertEquals(result[T1]:view(), 'number')
    lt.assertEquals(result[T2]:view(), 'unknown')
end

do
    rt:reset()
    --[[
    abc.`T` @ "X"
    T -> abc.X
    ]]
    local T = rt.generic 'T'
    local template = rt.oddTemplate {'abc.', T}
    local results = {}
    template:inferGeneric(rt.value 'X', results)

    lt.assertEquals(results[T].kind, 'type')
    lt.assertEquals(results[T]:view(), 'abc.X')
end

do
    rt:reset()

    local A = rt.generic 'A'
    local B = rt.generic 'B'
    local t = rt.table {
        [A] = rt.value(1),
        [B] = rt.value(2),
    }

    local results = {}
    t:inferGeneric(rt.table {
        x = rt.value(2),
        y = rt.value(1),
    }, results)

    lt.assertEquals(results[A]:view(), '"y"')
    lt.assertEquals(results[B]:view(), '"x"')
end

do
    rt:reset()

    local A = rt.generic 'A'
    local B = rt.generic 'B'
    local t = rt.table {
        [1] = A,
        [2] = B,
    }

    local results = {}
    t:inferGeneric(rt.table {
        [1] = rt.value 'x',
        [2] = rt.value 'y',
    }, results)

    lt.assertEquals(results[A]:view(), '"x"')
    lt.assertEquals(results[B]:view(), '"y"')
end

do
    rt:reset()

    local A = rt.generic 'A'
    local B = rt.generic 'B'
    local t = rt.table {
        [1] = A,
        [B] = rt.value 'y',
    }

    local results = {}
    t:inferGeneric(rt.table {
        [1] = rt.value 'x',
        [2] = rt.value 'y',
    }, results)

    lt.assertEquals(results[A]:view(), '"x"')
    lt.assertEquals(results[B]:view(), '2')
end

do
    rt:reset()

    local A = rt.generic 'A'
    local B = rt.generic 'B'
    local C = rt.generic 'C'
    local D = rt.generic 'D'
    local t = rt.table {
        [1] = rt.value 'a',
        [A] = rt.value 'b',
        [3] = B,
        [C] = D,
    }

    local results = {}
    t:inferGeneric(rt.table {
        [1] = rt.value 'a',
        [2] = rt.value 'b',
        [3] = rt.value 'c',
        [4] = rt.value 'd',
        [5] = rt.value 'e',
    }, results)

    lt.assertEquals(results[A]:view(), '2')
    lt.assertEquals(results[B]:view(), '"c"')
    lt.assertEquals(results[C]:view(), '4 | 5')
    lt.assertEquals(results[D]:view(), '"d" | "e"')
end

do
    rt:reset()

    --[[
        fun<T>(x: T, y: T) @ fun(x: number, y: string)
        T -> number
    ]]

    local T = rt.generic 'T'
    local f = rt.func()
        : addTypeParam(T)
        : addParamDef('x', T)
        : addParamDef('y', T)

    local target = rt.func()
        : addParamDef('x', rt.NUMBER)
        : addParamDef('y', rt.STRING)

    local results = {}
    f:inferGeneric(target, results)
    lt.assertEquals(results[T]:view(), 'number')
end

do
    rt:reset()

    --[[
    ---@alias A { x: 1, y: 2 }

    A[T] @ 2 --> T = 'y'
    ]]

    local t = rt.table {
        x = rt.value(1),
        y = rt.value(2),
    }

    local T = rt.generic 'T'
    local indexType = rt.index(t, T)

    local results = {}
    indexType:inferGeneric(rt.value(2), results)

    lt.assertEquals(results[T]:view(), '"y"')
end

do
    rt:reset()

    local T = rt.generic 'T'
    local call = rt.call('ABC', { T })

    local K = rt.generic 'K'
    local ABC = rt.alias 'ABC'
        : addTypeParam(K)
        : setValue(K)

    local results = {}
    call:inferGeneric(rt.value(1), results)

    lt.assertEquals(results[T]:view(), '1')
end
