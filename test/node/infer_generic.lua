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
