do
    local N = ls.node.generic('N', ls.node.NUMBER)
    local U = ls.node.generic 'U'
    local pack = ls.node.genericPack { N, U }
    local map = ls.node.type 'Map'
    map:bindParams(pack)
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

    assert(map:view() == 'Map<N:number, U>')

    assert(array:view() == '<N:number>[]')

    assert(tuple:view() == '[<N:number>, <U>]')

    assert(table:view() == '{ [<N:number>]: <U> }')

    assert(func:view() == 'fun(a: <N:number>, ...: <U>):[<N:number>, <U>]')
    func:bindGenericPack(pack)
    assert(func:view() == 'fun<N:number, U>(a: <N:number>, ...: <U>):[<N:number>, <U>]')

    assert(union:view() == '<N:number> | <U>')

    assert(intersection:view() == '<N:number> & <U>')

    local newPack = pack:resolve {
        [N] = ls.node.type 'integer'
    }
    assert(newPack:view() == '<integer, unknown>')

    local newMap = map:resolveGeneric(newPack)
    assert(newMap:view() == 'Map<integer, unknown>')

    local newArray = array:resolveGeneric(newPack)
    assert(newArray:view() == 'integer[]')

    local newTuple = tuple:resolveGeneric(newPack)
    assert(newTuple:view() == '[integer, unknown]')

    local newTable = table:resolveGeneric(newPack)
    assert(newTable:view() == '{ [integer]: unknown }')

    local newFunc = func:resolveGeneric(newPack)
    assert(newFunc:view() == 'fun<integer, unknown>(a: integer, ...: unknown):[integer, unknown]')

    local newUnion = union:resolveGeneric(newPack)
    assert(newUnion:view() == 'integer | unknown')

    local newIntersection = intersection:resolveGeneric(newPack)
    assert(newIntersection:view() == 'integer')
end
