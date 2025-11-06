local rt = test.scope.rt

do
    local t = rt.table()

    assert(t:view() == '{}')

    local field1 = rt.field('x', rt.NUMBER)
    local field2 = rt.field('y', rt.STRING)

    t:addField(field1)
    assert(t:view() == '{ x: number }')

    t:addField(field2)
    assert(t:view() == '{ x: number, y: string }')

    t:removeField(field1)
    assert(t:view() == '{ y: string }')

    t:removeField(field2)
    assert(t:view() == '{}')
end

do
    rt:reset()

    local a = rt.type 'A'

    assert(a:get 'x' == rt.NEVER)

    local field1 = rt.field('x', rt.NUMBER)
    local field2 = rt.field('x', rt.STRING)
    local ca = rt.class 'A'
    assert(a:get 'x' == rt.NIL)

    ca:addField(field1)
    assert(a:get 'x' :view() == 'number')

    local b = rt.type 'B'
    assert(b:get 'x' :view() == 'never')

    local cb = rt.class 'B'

    cb:addExtends(a)
    assert(b:get 'x' :view() == 'number')
    assert(b:get 'y' :view() == 'nil')

    ca:removeField(field1)
    ca:addField(field2)
    assert(a:get 'x' :view() == 'string')
    assert(b:get 'x' :view() == 'string')
end

do
    rt:reset()
    --[[
    ---@class A<T>
    ---@field x T
    ]]

    local a = rt.type 'A'
    local T = rt.generic 'T'

    local ca = rt.class('A', { T })
        : addField(rt.field('x', T))

    local an = a:call { rt.NUMBER }
    assert(an.value:view() == '{ x: number }')
    assert(an:get('x'):view() == 'number')
    assert(an:get('y'):view() == 'nil')

    ca:addField(rt.field('y', rt.STRING))
    assert(an.value:view() == '{ x: number, y: string }')
    assert(an:get('y'):view() == 'string')
end

do
    local t1 = rt.table {
        x = 1
    }
    local t2 = rt.table {
        y = 2
    }
    local sec = t1 & t2

    assert(sec:view() == '{ x: 1 } & { y: 2 }')
    assert(sec.value:view() == '{ x: 1, y: 2 }')

    t1:addField(rt.field('xx', rt.value(11)))
    t2:addField(rt.field('yy', rt.value(22)))

    assert(sec:view() == '{ x: 1, xx: 11 } & { y: 2, yy: 22 }')
    assert(sec.value:view() == '{ x: 1, xx: 11, y: 2, yy: 22 }')
end

do
    local t1 = rt.table {
        x = 1
    }
    local t2 = rt.table {
        y = 2
    }
    assert((t1 >> t2) == false)

    t1:addField(rt.field('y', rt.value(2)))
    assert((t1 >> t2) == true)
end
