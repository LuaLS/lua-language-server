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
    node.TYPE_POOL['A'] = nil
    node.TYPE_POOL['B'] = nil

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
    a:addField(field1)
    assert(a:get 'x' == node.NUMBER)

    local b = node.type 'B'
    assert(b:get 'x' == node.NEVER)

    b:addExtends(a)
    assert(b:get 'x' == node.NUMBER)
    assert(b:get 'y' == node.NIL)

    a:removeField(field1)
    a:addField(field2)
    assert(a:get 'x' == node.STRING)
    assert(b:get 'x' == node.STRING)
end

do
    --[[
    ---@class A<T>
    ---@field x T
    ]]
    node.TYPE_POOL['A'] = nil

    local a = node.type 'A'
    local T = node.generic 'T'
    a:bindParams { T }
end
