do
    local N = ls.node.generic('N', ls.node.NUMBER)
    local U = ls.node.generic 'U'
    local array = ls.node.array(N)
    local pack = ls.node.genericPack { N, U }

    assert(N:view() == 'N:number')
    assert(array:view() == 'N:number[]')
    assert(pack:view() == '<N: number, U>')

    local newPack = pack:resolve {
        N = ls.node.type 'integer'
    }
    assert(newPack:view() == '<N = integer, U = unknown>')

    local newArray = array:resolveGeneric(newPack)
    assert(newArray:view() == 'integer[]')
end
