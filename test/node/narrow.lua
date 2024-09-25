do
    ls.node.TYPE_POOL['A'] = nil
    ls.node.TYPE_POOL['B'] = nil
    ls.node.TYPE_POOL['C'] = nil

    local u = ls.node.type 'A' | ls.node.type 'B' | ls.node.type 'C'
    local r = u:narrow(ls.node.type 'B')

    assert(r:view() == 'B')
end

do
    ls.node.TYPE_POOL['A'] = nil
    ls.node.TYPE_POOL['B'] = nil
    ls.node.TYPE_POOL['C'] = nil

    ls.node.type 'A'
        : addExtends(ls.node.type 'B')

    local u = ls.node.type 'A' | ls.node.type 'B' | ls.node.type 'C'
    local r = u:narrow(ls.node.type 'B')

    assert(r:view() == 'A | B')
end

do
    local u = ls.node.value(1) | ls.node.value(true) | ls.node.value('x')
    local r1 = u:narrow(ls.node.NUMBER)
    local r2 = u:narrow(ls.node.STRING)
    local r3 = u:narrow(ls.node.BOOLEAN)

    assert(r1:view() == '1')
    assert(r2:view() == '"x"')
    assert(r3:view() == 'true')
end
