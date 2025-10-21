local node = test.scope.node

do
    local t = node.table()

    assert(t:view() == '{}')

    local field1 = {
        key = node.value 'x',
        value = node.NUMBER
    }
    local field2 = {
        key = node.value 'y',
        value = node.STRING
    }

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
    node:reset()

    local a = node.type 'A'

    assert(a:get 'x' == node.NEVER)

    local field1 = {
        key = node.value 'x',
        value = node.NUMBER
    }
    local field2 = {
        key = node.value 'x',
        value = node.STRING
    }
    local ca = node.class 'A'
    a:addClass(ca)
    assert(a:get 'x' == node.NIL)

    ca:addField(field1)
    assert(a:get 'x' == node.NUMBER)

    local b = node.type 'B'
    assert(b:get 'x' == node.NEVER)

    local cb = node.class 'B'
    b:addClass(cb)

    cb:addExtends(a)
    assert(b:get 'x' == node.NUMBER)
    assert(b:get 'y' == node.NIL)

    ca:removeField(field1)
    ca:addField(field2)
    assert(a:get 'x' == node.STRING)
    assert(b:get 'x' == node.STRING)
end

do
    node:reset()
    --[[
    ---@class A<T>
    ---@field x T
    ]]

    local a = node.type 'A'
    local T = node.generic 'T'

    local ca = node.class('A', { T })
        : addField {
            key = node.value 'x',
            value = T,
        }
    a:addClass(ca)

    local an = a:call { node.NUMBER }
    assert(an.value:view() == '{ x: number }')
    assert(an:get('x'):view() == 'number')
    assert(an:get('y'):view() == 'nil')

    ca:addField {
        key = node.value 'y',
        value = node.STRING,
    }
    assert(an.value:view() == '{ x: number, y: string }')
    assert(an:get('y'):view() == 'string')
end

do
    local t1 = node.table {
        x = 1
    }
    local t2 = node.table {
        y = 2
    }
    local sec = t1 & t2

    assert(sec:view() == '{ x: 1 } & { y: 2 }')
    assert(sec.value:view() == '{ x: 1, y: 2 }')

    t1:addField {
        key = node.value 'xx',
        value = node.value(11)
    }
    t2:addField {
        key = node.value 'yy',
        value = node.value(22)
    }

    assert(sec:view() == '{ x: 1, xx: 11 } & { y: 2, yy: 22 }')
    assert(sec.value:view() == '{ x: 1, xx: 11, y: 2, yy: 22 }')
end

do
    local t1 = node.table {
        x = 1
    }
    local t2 = node.table {
        y = 2
    }
    assert((t1 >> t2) == false)

    t1:addField {
        key = node.value 'y',
        value = node.value(2)
    }
    assert((t1 >> t2) == true)
end
