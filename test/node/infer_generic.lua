do
    local T = test.scope.node.generic 'T'
    local map = {}
    T:inferGeneric(test.scope.node.NUMBER, map)

    assert(map[T] == test.scope.node.NUMBER)
end

do
    --[[
    T[] @ number[]
    T -> number
    ]]
    local T = test.scope.node.generic 'T'
    local map = {}
    local arrayT = test.scope.node.array(T)
    local arrayNumber = test.scope.node.array(test.scope.node.NUMBER)
    arrayT:inferGeneric(arrayNumber, map)

    assert(map[T] == test.scope.node.NUMBER)
end

do
    --[[
    T[] @ {}
    T -> T
    ]]
    local T = test.scope.node.generic 'T'
    local map = {}
    local arrayT = test.scope.node.array(T)
    local table = test.scope.node.table()
    arrayT:inferGeneric(table, map)

    assert(map[T] == nil)
end

do
    --[[
    T[] @ { [integer]: string }
    T -> string
    ]]
    local T = test.scope.node.generic 'T'
    local map = {}
    local arrayT = test.scope.node.array(T)
    local table = test.scope.node.table {
        [test.scope.node.INTEGER] = test.scope.node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T] == test.scope.node.STRING)
end

do
    --[[
    T[] @ { [number]: string }
    T -> string
    ]]
    local T = test.scope.node.generic 'T'
    local map = {}
    local arrayT = test.scope.node.array(T)
    local table = test.scope.node.table {
        [test.scope.node.NUMBER] = test.scope.node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T] == test.scope.node.STRING)
end

do
    --[[
    T[] @ [number, string]
    T -> number|string
    ]]
    local T = test.scope.node.generic 'T'
    local map = {}
    local arrayT = test.scope.node.array(T)
    local table = test.scope.node.tuple {
        test.scope.node.NUMBER,
        test.scope.node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T]:view() == 'number | string')
end

do
    --[[
    [T1, T2] @ [number, string]
    T1 -> number
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tupleT1T2 = test.scope.node.tuple { T1, T2 }
    local tuple = test.scope.node.tuple {
        test.scope.node.NUMBER,
        test.scope.node.STRING,
    }
    tupleT1T2:inferGeneric(tuple, map)

    assert(map[T1] == test.scope.node.NUMBER)
    assert(map[T2] == test.scope.node.STRING)
end

do
    --[[
    [T1, T2] @ number[]
    T1 -> number
    T2 -> number
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tupleT1T2 = test.scope.node.tuple { T1, T2 }
    local target = test.scope.node.array(test.scope.node.NUMBER)
    tupleT1T2:inferGeneric(target, map)

    assert(map[T1] == test.scope.node.NUMBER)
    assert(map[T2] == test.scope.node.NUMBER)
end

do
    --[[
    [T1, T2] @ { [1]: number, [number]: string }
    T1 -> number
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tupleT1T2 = test.scope.node.tuple { T1, T2 }
    local target = test.scope.node.table {
        [1] = test.scope.node.NUMBER,
        [test.scope.node.NUMBER] = test.scope.node.STRING,
    }
    tupleT1T2:inferGeneric(target, map)

    assert(map[T1] == test.scope.node.NUMBER)
    assert(map[T2] == test.scope.node.STRING)
end

do
    --[[
    { [K]: V } @ { [number]: string }
    K -> number
    V -> string
    ]]
    local K = test.scope.node.generic 'V'
    local V = test.scope.node.generic 'V'
    local map = {}
    local tableKV = test.scope.node.table {
        [K] = V,
    }
    local target = test.scope.node.table {
        [test.scope.node.NUMBER] = test.scope.node.STRING,
    }
    tableKV:inferGeneric(target, map)

    assert(map[K] == test.scope.node.NUMBER)
    assert(map[V] == test.scope.node.STRING)
end

do
    --[[
    { [K]: V } @ string[]
    K -> integer
    V -> string
    ]]
    local K = test.scope.node.generic 'K'
    local V = test.scope.node.generic 'V'
    local map = {}
    local tableKV = test.scope.node.table {
        [K] = V,
    }
    local target = test.scope.node.array(test.scope.node.STRING)
    tableKV:inferGeneric(target, map)

    assert(map[K] == test.scope.node.INTEGER)
    assert(map[V] == test.scope.node.STRING)
end

do
    --[[
    { [K]: V } @ [string, boolean]
    K -> 1 | 2
    V -> string | boolean
    ]]
    local K = test.scope.node.generic 'K'
    local V = test.scope.node.generic 'V'
    local map = {}
    local tableKV = test.scope.node.table {
        [K] = V,
    }
    local target = test.scope.node.tuple {
        test.scope.node.STRING,
        test.scope.node.BOOLEAN,
    }
    tableKV:inferGeneric(target, map)

    assert(map[K]:view() == '1 | 2')
    assert(map[V]:view() == 'string | boolean')
end

do
    --[[
    { x: T1, y: T2 } @ { x: number, y: string }
    T1 -> number
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tableKV = test.scope.node.table {
        x = T1,
        y = T2,
    }
    local target = test.scope.node.table {
        x = test.scope.node.NUMBER,
        y = test.scope.node.STRING,
    }
    tableKV:inferGeneric(target, map)

    assert(map[T1]:view() == 'number')
    assert(map[T2]:view() == 'string')
end

do
    --[[
    [T1, T2] @ [number, string]
    T1 -> number
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tupleG = test.scope.node.tuple { T1, T2 }
    local target = test.scope.node.tuple { test.scope.node.NUMBER, test.scope.node.STRING }
    tupleG:inferGeneric(target, map)

    assert(map[T1]:view() == 'number')
    assert(map[T2]:view() == 'string')
end

do
    --[[
    [T1, T2] @ string[]
    T1 -> string
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tupleG = test.scope.node.tuple { T1, T2 }
    local target = test.scope.node.array(test.scope.node.STRING)
    tupleG:inferGeneric(target, map)

    assert(map[T1]:view() == 'string')
    assert(map[T2]:view() == 'string')
end

do
    --[[
    [T1, T2] @ { [integer]: string, [2]: boolean }
    T1 -> string
    T2 -> boolean
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local map = {}
    local tupleG = test.scope.node.tuple { T1, T2 }
    local target = test.scope.node.table {
        [test.scope.node.INTEGER] = test.scope.node.STRING,
        [2] = test.scope.node.BOOLEAN,
    }
    tupleG:inferGeneric(target, map)

    assert(map[T1]:view() == 'string')
    assert(map[T2]:view() == 'boolean')
end

do
    --[[
    ---@class Map<K, V>
    ---@field [K] V
    
    Map<T1, T2> @ { [number]: string }
    T1 -> number
    T2 -> string
    ]]
    test.scope.node.TYPE_POOL['Map'] = nil

    local map = test.scope.node.type 'Map'
    local K = test.scope.node.generic 'K'
    local V = test.scope.node.generic 'V'
    map:bindParams { K, V }
    map:addField { key = K, value = V }

    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local result = {}
    map:call { T1, T2 } :inferGeneric(test.scope.node.table {
        [test.scope.node.NUMBER] = test.scope.node.STRING
    }, result)
    assert(result[T1]:view() == 'number')
    assert(result[T2]:view() == 'string')
end

do
    --[[
    fun(x: T1): T2 @ fun(x: number): string
    T1 -> number
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local funG = test.scope.node.func()
        : addParam('x', T1)
        : addReturn(nil, T2)
    local target = test.scope.node.func()
        : addParam('x', test.scope.node.NUMBER)
        : addReturn(nil, test.scope.node.STRING)

    local result = {}
    funG:inferGeneric(target, result)

    assert(result[T1]:view() == 'number')
    assert(result[T2]:view() == 'string')
end

do
    --[[
    fun(x: T1, y: T2) @ fun(x: number, ...: string)
    T1 -> number
    T2 -> string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local funG = test.scope.node.func()
        : addParam('x', T1)
        : addParam('y', T2)
    local target = test.scope.node.func()
        : addParam('x', test.scope.node.NUMBER)
        : addVarargParam(test.scope.node.STRING)

    local result = {}
    funG:inferGeneric(target, result)

    assert(result[T1]:view() == 'number')
    assert(result[T2]:view() == 'string')
end

do
    --[[
    fun(x: T1, ...: T2) @ fun(x: number, y: boolean, ...: string)
    T1 -> number
    T2 -> boolean | string
    ]]
    local T1 = test.scope.node.generic 'T1'
    local T2 = test.scope.node.generic 'T2'
    local funG = test.scope.node.func()
        : addParam('x', T1)
        : addVarargParam(T2)
    local target = test.scope.node.func()
        : addParam('x', test.scope.node.NUMBER)
        : addParam('y', test.scope.node.BOOLEAN)
        : addVarargParam(test.scope.node.STRING)

    local result = {}
    funG:inferGeneric(target, result)

    assert(result[T1]:view() == 'number')
    assert(result[T2]:view() == 'boolean | string')
end

do
    --[[
    T | number @ number
    T -> number
    ]]
    local T = test.scope.node.generic 'T'
    local u = test.scope.node.union { T, test.scope.node.NUMBER }

    local result = {}
    u:inferGeneric(test.scope.node.NUMBER, result)

    assert(result[T]:view() == 'number')
end

do
    --[[
    T & number @ number
    T -> number
    ]]
    local T = test.scope.node.generic 'T'
    local i = test.scope.node.intersection { T, test.scope.node.NUMBER }

    local result = {}
    i:inferGeneric(test.scope.node.NUMBER, result)

    assert(result[T]:view() == 'number')
end
