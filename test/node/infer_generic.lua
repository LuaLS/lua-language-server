do
    local T = ls.node.generic 'T'
    local map = {}
    T:inferGeneric(ls.node.NUMBER, map)

    assert(map[T] == ls.node.NUMBER)
end

do
    --[[
    T[] @ number[]
    T -> number
    ]]
    local T = ls.node.generic 'T'
    local map = {}
    local arrayT = ls.node.array(T)
    local arrayNumber = ls.node.array(ls.node.NUMBER)
    arrayT:inferGeneric(arrayNumber, map)

    assert(map[T] == ls.node.NUMBER)
end

do
    --[[
    T[] @ {}
    T -> T
    ]]
    local T = ls.node.generic 'T'
    local map = {}
    local arrayT = ls.node.array(T)
    local table = ls.node.table()
    arrayT:inferGeneric(table, map)

    assert(map[T] == nil)
end

do
    --[[
    T[] @ { [integer]: string }
    T -> string
    ]]
    local T = ls.node.generic 'T'
    local map = {}
    local arrayT = ls.node.array(T)
    local table = ls.node.table {
        [ls.node.INTEGER] = ls.node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T] == ls.node.STRING)
end

do
    --[[
    T[] @ { [number]: string }
    T -> string
    ]]
    local T = ls.node.generic 'T'
    local map = {}
    local arrayT = ls.node.array(T)
    local table = ls.node.table {
        [ls.node.NUMBER] = ls.node.STRING,
    }
    arrayT:inferGeneric(table, map)

    assert(map[T] == ls.node.STRING)
end

do
    --[[
    T[] @ [number, string]
    T -> number|string
    ]]
    local T = ls.node.generic 'T'
    local map = {}
    local arrayT = ls.node.array(T)
    local table = ls.node.tuple {
        ls.node.NUMBER,
        ls.node.STRING,
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
    local T1 = ls.node.generic 'T1'
    local T2 = ls.node.generic 'T2'
    local map = {}
    local tupleT1T2 = ls.node.tuple { T1, T2 }
    local tuple = ls.node.tuple {
        ls.node.NUMBER,
        ls.node.STRING,
    }
    tupleT1T2:inferGeneric(tuple, map)

    assert(map[T1] == ls.node.NUMBER)
    assert(map[T2] == ls.node.STRING)
end

do
    --[[
    [T1, T2] @ number[]
    T1 -> number
    T2 -> number
    ]]
    local T1 = ls.node.generic 'T1'
    local T2 = ls.node.generic 'T2'
    local map = {}
    local tupleT1T2 = ls.node.tuple { T1, T2 }
    local target = ls.node.array(ls.node.NUMBER)
    tupleT1T2:inferGeneric(target, map)

    assert(map[T1] == ls.node.NUMBER)
    assert(map[T2] == ls.node.NUMBER)
end

do
    --[[
    [T1, T2] @ { [1]: number, [number]: string }
    T1 -> number
    T2 -> string
    ]]
    local T1 = ls.node.generic 'T1'
    local T2 = ls.node.generic 'T2'
    local map = {}
    local tupleT1T2 = ls.node.tuple { T1, T2 }
    local target = ls.node.table {
        [1] = ls.node.NUMBER,
        [ls.node.NUMBER] = ls.node.STRING,
    }
    tupleT1T2:inferGeneric(target, map)

    assert(map[T1] == ls.node.NUMBER)
    assert(map[T2] == ls.node.STRING)
end

do
    --[[
    { [K]: V } @ { [number]: string }
    K -> number
    V -> string
    ]]
    local K = ls.node.generic 'V'
    local V = ls.node.generic 'V'
    local map = {}
    local tableKV = ls.node.table {
        [K] = V,
    }
    local target = ls.node.table {
        [ls.node.NUMBER] = ls.node.STRING,
    }
    tableKV:inferGeneric(target, map)

    assert(map[K] == ls.node.NUMBER)
    assert(map[V] == ls.node.STRING)
end

do
    --[[
    { [K]: V } @ string[]
    K -> integer
    V -> string
    ]]
    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = {}
    local tableKV = ls.node.table {
        [K] = V,
    }
    local target = ls.node.array(ls.node.STRING)
    tableKV:inferGeneric(target, map)

    assert(map[K] == ls.node.INTEGER)
    assert(map[V] == ls.node.STRING)
end

do
    --[[
    { [K]: V } @ [string, boolean]
    K -> 1 | 2
    V -> string | boolean
    ]]
    local K = ls.node.generic 'K'
    local V = ls.node.generic 'V'
    local map = {}
    local tableKV = ls.node.table {
        [K] = V,
    }
    local target = ls.node.tuple {
        ls.node.STRING,
        ls.node.BOOLEAN,
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
    local T1 = ls.node.generic 'T1'
    local T2 = ls.node.generic 'T2'
    local map = {}
    local tableKV = ls.node.table {
        x = T1,
        y = T2,
    }
    local target = ls.node.table {
        x = ls.node.NUMBER,
        y = ls.node.STRING,
    }
    tableKV:inferGeneric(target, map)

    assert(map[T1]:view() == 'number')
    assert(map[T2]:view() == 'string')
end
