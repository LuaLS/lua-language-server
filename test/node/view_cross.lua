do
    local a = ls.node.NIL & ls.node.value(1)

    assert(a:view() == 'never')
end

do
    local a = ls.node.value(1) & ls.node.value(2)

    assert(a:view() == 'never')
end

do
    local a = ls.node.value(1) & ls.node.type('number')

    assert(a:view() == '1')
end

do
    local a = ls.node.type('number') & ls.node.value(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.type('number') & ls.node.value(1)

    assert(a:view() == '1')
end
