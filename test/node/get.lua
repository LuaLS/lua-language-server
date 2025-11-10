local rt = test.scope.rt

do
    local t = rt.table {
        [1] = rt.value(100),
        [2] = rt.value(200),
    }

    assert(t:get(1):view() == '100')
    assert(t:get(2):view() == '200')
    assert(t:get(3):view() == 'nil')
    assert(t:get(rt.INTEGER):view() == '100 | 200')
    assert(t:get(rt.NUMBER):view() == '100 | 200')
end

do
    local t = rt.table {
        [rt.INTEGER] = rt.TRUE,
    }

    assert(t:get(1):view() == 'true')
    assert(t:get(2):view() == 'true')
    assert(t:get(rt.INTEGER):view() == 'true')
    assert(t:get(rt.NUMBER):view() == 'true')
end

do
    local t = rt.table {
        [rt.NUMBER] = rt.TRUE,
    }

    assert(t:get(1):view() == 'true')
    assert(t:get(2):view() == 'true')
    assert(t:get(rt.INTEGER):view() == 'true')
    assert(t:get(rt.NUMBER):view() == 'true')
end

do
    local A = rt.class('A')
    A:addField(rt.field('x', rt.NUMBER))

    local t = rt.table {
        x = rt.TRUE,
    }

    t:setExpectParent(rt.type 'A')

    assert(t:get('x'):view() == 'number')
end
