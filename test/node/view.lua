do
    local a = ls.node.create()

    assert(a:view() == 'never')
end

do
    local a = ls.node.number(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.number(1.2345)

    assert(a:view() == '1.2345')
end

do
    local a = ls.node.boolean(true)

    assert(a:view() == 'true')
end

do
    local a = ls.node.boolean(false)

    assert(a:view() == 'false')
end

do
    local a = ls.node.string('abc', '"')

    assert(a:view() == '"abc"')
end

do
    local a = ls.node.string('abc', "'")

    assert(a:view() == "'abc'")
end

do
    local a = ls.node.string('abc', "[[")

    assert(a:view() == "[[abc]]")
end

do
    local a = ls.node.union(ls.node.number(1), ls.node.number(2))

    assert(a:view() == '1|2')
end

do
    local a = ls.node.number(1) | ls.node.number(2)

    assert(a:view() == '1|2')
end

do
    local a = ls.node.number(1) | ls.node.number(2) | ls.node.number(3)

    assert(a:view() == '1|2|3')
end

do
    local a = (ls.node.number(1) | ls.node.number(2)) | (ls.node.number(1) | ls.node.number(3))

    assert(a:view() == '1|2|3')
end

do
    local a = ls.node.create() | ls.node.number(1)

    assert(a:view() == '1')
end

do
    local a = ls.node.number(1) | ls.node.create()

    assert(a:view() == '1')
end
