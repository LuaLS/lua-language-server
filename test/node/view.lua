do
    local a = ls.node.create()

    assert(a:view() == 'never')
end

do
    local a = ls.node.value(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.value(1.2345)

    assert(a:view() == '1.2345')
end

do
    local a = ls.node.value(true)

    assert(a:view() == 'true')
end

do
    local a = ls.node.value(false)

    assert(a:view() == 'false')
end

do
    local a = ls.node.value('abc', '"')

    assert(a:view() == '"abc"')
end

do
    local a = ls.node.value('abc', "'")

    assert(a:view() == "'abc'")
end

do
    local a = ls.node.value('abc', "[[")

    assert(a:view() == "[[abc]]")
end

do
    local a = ls.node.union(ls.node.value(1), ls.node.value(2))

    assert(a:view() == '1|2')
end

do
    local a = ls.node.value(1) | ls.node.value(2)

    assert(a:view() == '1|2')
end

do
    local a = ls.node.value(1) | ls.node.value(2) | ls.node.value(3)

    assert(a:view() == '1|2|3')
end

do
    local a = (ls.node.value(1) | ls.node.value(2)) | (ls.node.value(1) | ls.node.value(3))

    assert(a:view() == '1|2|3')
end

do
    local a = ls.node.create() | ls.node.value(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.value(1) | ls.node.create()

    assert(a:view() == '1')
end

do
    local a = ls.node.value(1) | nil

    assert(a:view() == '1')
end

do
    local a = nil | ls.node.value(1)

    assert(a:view() == '1')
end

do
    local t = ls.node.table()
    t:insert(ls.node.value('x'), ls.node.value(1))
    t:insert(ls.node.value('y'), ls.node.value(2))
    t:insert(ls.node.value('z'), ls.node.value(3))
    t:insert(ls.node.value(1), ls.node.value('x'))
    t:insert(ls.node.value(2), ls.node.value('y'))
    t:insert(ls.node.value(3), ls.node.value('z'))

    assert(t:view() == [[{ x: 1, y: 2, z: 3, [1]: "x", [2]: "y", [3]: "z" }]])
end
