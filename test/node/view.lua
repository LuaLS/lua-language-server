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
