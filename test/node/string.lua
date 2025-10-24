local node = test.scope.node

do
    node:reset()

    local s1 = node.value('hello')
    local s2 = node.value('hello', '"')
    local s3 = node.value('hello', "'")
    local s4 = node.value('hello', '[[')

    assert(s1:view() == '"hello"')
    assert(s2:view() == '"hello"')
    assert(s3:view() == "'hello'")
    assert(s4:view() == '[[hello]]')

    assert(s1 >> s2)
    assert(s1 >> s3)
    assert(s1 >> s4)
    assert(s2 >> s1)
    assert(s2 >> s3)
    assert(s2 >> s4)
    assert(s3 >> s1)
    assert(s3 >> s2)
    assert(s3 >> s4)
    assert(s4 >> s1)
    assert(s4 >> s2)
    assert(s4 >> s3)

    local t = node.table()
    t:addField {
        key = s2,
        value = node.value(1),
    }

    local v = t:get(s3)
    assert(v:view() == '1')

    t:addField {
        key = s4,
        value = node.value(2),
    }

    local v = t:get(s2)
    assert(v:view() == '2')
end
