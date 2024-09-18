do
    local t = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.type 'number'
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.type 'boolean'
        }
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.type 'string'
        }
        : addField {
            key   = ls.node.union { ls.node.value(1), ls.node.value(2) },
            value = ls.node.value('union')
        }
        : addField {
            key   = ls.node.type 'string',
            value = ls.node.value('string')
        }
        : addField {
            key   = ls.node.type 'integer',
            value = ls.node.value('integer')
        }
        : addField {
            key   = ls.node.type 'number',
            value = ls.node.value('number')
        }

    assert(t:get('x'):view() == 'number')
    assert(t:get('y'):view() == 'boolean')
    assert(t:get('z'):view() == 'string')
    assert(t:get(1):view() == '"union"')
    assert(t:get(2):view() == '"union"')
    assert(t:get('www'):view() == '"string"')
    assert(t:get(3):view() == '"integer"')
    assert(t:get(0.5):view() == '"number"')
    assert(t:get(true) == nil)
    assert(t:get(ls.node.ANY):view() == [["union"|number|boolean|string|"integer"|"number"|"string"]])
    assert(t.sortedFields[1].key == ls.node.value(1))
    assert(t.sortedFields[2].key == ls.node.value(2))
    assert(t.sortedFields[3].key == ls.node.value 'x')
    assert(t.sortedFields[4].key == ls.node.value 'y')
    assert(t.sortedFields[5].key == ls.node.value 'z')
    assert(t.sortedFields[6].key == ls.node.type 'integer')
    assert(t.sortedFields[7].key == ls.node.type 'number')
    assert(t.sortedFields[8].key == ls.node.type 'string')
end

do
    ls.node.TYPE['A']   = nil
    ls.node.TYPE['A1']  = nil
    ls.node.TYPE['A2']  = nil
    ls.node.TYPE['A11'] = nil
    ls.node.TYPE['A12'] = nil
    ls.node.TYPE['A21'] = nil
    ls.node.TYPE['A22'] = nil

    local A   = ls.node.type 'A'
    local A1  = ls.node.type 'A1'
    local A2  = ls.node.type 'A2'
    local A11 = ls.node.type 'A11'
    local A12 = ls.node.type 'A12'
    local A21 = ls.node.type 'A21'
    local A22 = ls.node.type 'A22'

    A:addExtends(A1)
    A:addExtends(A2)
    A1:addExtends(A11)
    A1:addExtends(A12)
    A2:addExtends(A21)
    A2:addExtends(A22)
    A22:addExtends(A)

    local extends = A.fullExtends
    assert(extends[1] == A1)
    assert(extends[2] == A2)
    assert(extends[3] == A11)
    assert(extends[4] == A12)
    assert(extends[5] == A21)
    assert(extends[6] == A22)
end
