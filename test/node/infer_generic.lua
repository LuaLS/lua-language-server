local node = test.scope.node

do
    local T = node.generic 'T'
    local map = {}
    T:inferGeneric(node.NUMBER, map)

    assert(map[T] == node.NUMBER)
end

do
    --[[
    T[] @ number[]
    T -> number
    ]]
    local T = node.generic 'T'
    local map = {}
    local arrayT = node.array(T)
    local arrayNumber = node.array(node.NUMBER)
    arrayT:inferGeneric(arrayNumber, map)

    assert(map[T] == node.NUMBER)
end

do
    --[[
    T[] @ {}
    T -> T
    ]]
    local T = node.generic 'T'
    local map = {}
    local arrayT = node.array(T)
    local table = node.table()
    arrayT:inferGeneric(table, map)

    assert(map[T] == nil)
end

do
    --[[
    T[] @ { [integer]: string }
    T -> string
    ]]
    local T = node.generic 'T'
    local map = {}
    local arrayT = node.array(T)
    local table = node.table {
        [node.INTEGER] = node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T] == node.STRING)
end

do
    --[[
    T[] @ { [number]: string }
    T -> string
    ]]
    local T = node.generic 'T'
    local map = {}
    local arrayT = node.array(T)
    local table = node.table {
        [node.NUMBER] = node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T] == node.STRING)
end

do
    --[[
    T[] @ [number, string]
    T -> number|string
    ]]
    local T = node.generic 'T'
    local map = {}
    local arrayT = node.array(T)
    local table = node.tuple {
        node.NUMBER,
        node.STRING,
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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tupleT1T2 = node.tuple { T1, T2 }
    local tuple = node.tuple {
        node.NUMBER,
        node.STRING,
    }
    tupleT1T2:inferGeneric(tuple, map)

    assert(map[T1] == node.NUMBER)
    assert(map[T2] == node.STRING)
end

do
    --[[
    [T1, T2] @ number[]
    T1 -> number
    T2 -> number
    ]]
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tupleT1T2 = node.tuple { T1, T2 }
    local target = node.array(node.NUMBER)
    tupleT1T2:inferGeneric(target, map)

    assert(map[T1] == node.NUMBER)
    assert(map[T2] == node.NUMBER)
end

do
    --[[
    [T1, T2] @ { [1]: number, [number]: string }
    T1 -> number
    T2 -> string
    ]]
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tupleT1T2 = node.tuple { T1, T2 }
    local target = node.table {
        [1] = node.NUMBER,
        [node.NUMBER] = node.STRING,
    }
    tupleT1T2:inferGeneric(target, map)

    assert(map[T1] == node.NUMBER)
    assert(map[T2] == node.STRING)
end

do
    --[[
    { [K]: V } @ { [number]: string }
    K -> number
    V -> string
    ]]
    local K = node.generic 'V'
    local V = node.generic 'V'
    local map = {}
    local tableKV = node.table {
        [K] = V,
    }
    local target = node.table {
        [node.NUMBER] = node.STRING,
    }
    tableKV:inferGeneric(target, map)

    assert(map[K] == node.NUMBER)
    assert(map[V] == node.STRING)
end

do
    --[[
    { [K]: V } @ string[]
    K -> integer
    V -> string
    ]]
    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = {}
    local tableKV = node.table {
        [K] = V,
    }
    local target = node.array(node.STRING)
    tableKV:inferGeneric(target, map)

    assert(map[K] == node.INTEGER)
    assert(map[V] == node.STRING)
end

do
    --[[
    { [K]: V } @ [string, boolean]
    K -> 1 | 2
    V -> string | boolean
    ]]
    local K = node.generic 'K'
    local V = node.generic 'V'
    local map = {}
    local tableKV = node.table {
        [K] = V,
    }
    local target = node.tuple {
        node.STRING,
        node.BOOLEAN,
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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tableKV = node.table {
        x = T1,
        y = T2,
    }
    local target = node.table {
        x = node.NUMBER,
        y = node.STRING,
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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tupleG = node.tuple { T1, T2 }
    local target = node.tuple { node.NUMBER, node.STRING }
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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tupleG = node.tuple { T1, T2 }
    local target = node.array(node.STRING)
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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local map = {}
    local tupleG = node.tuple { T1, T2 }
    local target = node.table {
        [node.INTEGER] = node.STRING,
        [2] = node.BOOLEAN,
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
    node:reset()

    local map = node.type 'Map'
    local K = node.generic 'K'
    local V = node.generic 'V'
    map:addClass(node.class('Map', { K, V })
        : addField {
            key   = K,
            value = V,
        }
    )

    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local result = {}
    map:call { T1, T2 } :inferGeneric(node.table {
        [node.NUMBER] = node.STRING
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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local funG = node.func()
        : addParamDef('x', T1)
        : addReturnDef(nil, T2)
    local target = node.func()
        : addParamDef('x', node.NUMBER)
        : addReturnDef(nil, node.STRING)

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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local funG = node.func()
        : addParamDef('x', T1)
        : addParamDef('y', T2)
    local target = node.func()
        : addParamDef('x', node.NUMBER)
        : addVarargParamDef(node.STRING)

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
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local funG = node.func()
        : addParamDef('x', T1)
        : addVarargParamDef(T2)
    local target = node.func()
        : addParamDef('x', node.NUMBER)
        : addParamDef('y', node.BOOLEAN)
        : addVarargParamDef(node.STRING)

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
    local T = node.generic 'T'
    local u = node.union { T, node.NUMBER }

    local result = {}
    u:inferGeneric(node.NUMBER, result)

    assert(result[T]:view() == 'number')
end

do
    --[[
    T & number @ number
    T -> number
    ]]
    local T = node.generic 'T'
    local i = node.intersection { T, node.NUMBER }

    local result = {}
    i:inferGeneric(node.NUMBER, result)

    assert(result[T]:view() == 'number')
end

do
    --[[
    fun<T1, T2>(x: T1, y: T2) @ fun(x: number)
    T1 -> number
    T2 -> unknown
    ]]
    local T1 = node.generic 'T1'
    local T2 = node.generic 'T2'
    local funG = node.func()
        : addTypeParam(T1)
        : addTypeParam(T2)
        : addParamDef('x', T1)
        : addParamDef('y', T2)

    local target = node.func()
        : addParamDef('x', node.NUMBER)

    local result = {}
    funG:inferGeneric(target, result)

    assert(result[T1]:view() == 'number')
    assert(result[T2]:view() == 'unknown')
end
