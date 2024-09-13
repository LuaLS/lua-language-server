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
    assert(t:get(true):view() == 'nil')
    assert(t:get(ls.node.ANY):view() == [[number|boolean|string|"union"|"string"|"integer"|"number"]])
end
