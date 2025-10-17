local node = test.scope.node

do
    node:reset()

    local a = node.type('A')

    assert(a:view() == 'A')
    assert(a.value:view() == 'A')
end

do
    node:reset()
    --[[
    ---@class A
    ---@field x 'x'
    ---@field y 'y'
    ]]

    local a = node.type('A')
        : addClass(node.class('A')
            : addField {
                key   = node.value 'x',
                value = node.value 'x'
            }
            : addField {
                key   = node.value 'y',
                value = node.value 'y'
            }
        )

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: "x", y: "y" }')
end

do
    node:reset()
    --[[
    ---@class A: B, C, D

    ---@class B
    ---@field x 'x'

    ---@class C
    ---@field y 'y'

    ---@class D
    ---@field z 'z'
    ]]

    local a = node.type('A')
    local b = node.type('B')
        : addClass(node.class('B')
            : addField {
                key   = node.value 'x',
                value = node.value 'x'
            }
        )
    local c = node.type('C')
        : addClass(node.class('C')
            : addField {
                key   = node.value 'y',
                value = node.value 'y'
            }
        )
    local d = node.type('D')
        : addClass(node.class('D')
            : addField {
                key   = node.value 'z',
                value = node.value 'z'
            }
        )

    a:addClass(node.class('A', nil, { b, c, d }))

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: "x", y: "y", z: "z" }')
end

do
    node:reset()
    --[[
    ---@class A: B, C, D
    ---@field w 1
    ---@field x 2
    ---@field y 3

    ---@class B
    ---@field field x 'x'

    ---@class C
    ---@field field y 'y'

    ---@class D
    ---@field field z 'z'
    ]]

    local a = node.type('A')
        : addClass(node.class('A')
            : addField {
                key   = node.value 'w',
                value = node.value '1'
            }
            : addField {
                key   = node.value 'x',
                value = node.value '2'
            }
            : addField {
                key   = node.value 'y',
                value = node.value '3'
            }
            : addExtends(node.type 'B')
            : addExtends(node.type 'C')
            : addExtends(node.type 'D')
        )
    local b = node.type('B')
        : addClass(node.class('B')
            : addField {
                key   = node.value 'x',
                value = node.value 'x'
            }
        )
    local c = node.type('C')
        : addClass(node.class('C')
            : addField {
                key   = node.value 'y',
                value = node.value 'y'
            }
        )
    local d = node.type('D')
        : addClass(node.class('D')
            : addField {
                key   = node.value 'z',
                value = node.value 'z'
            }
        )

    assert(a:view() == 'A')
    assert(a.value:view() == '{ w: "1", x: "2", y: "3", z: "z" }')
end

do
    node:reset()
    --[[
    ---@alias A 1
    ---@alias A 2
    ---@alias A 3
    ]]

    local a = node.type('A')
        : addAlias(node.alias('A', nil, node.value(1)))
        : addAlias(node.alias('A', nil, node.value(2)))
        : addAlias(node.alias('A', nil, node.value(3)))

    assert(a:view() == 'A')
    assert(a.value:view() == '1 | 2 | 3')
end

do
    node:reset()
    --[[
    ---@alias A B
    ---@alias A C
    ---@alias A D

    ---@alias B 1
    ---@alias B 2

    ---@alias C 2
    ---@alias C 3

    ---@alias D 3
    ---@alias D 4
    ]]

    local a = node.type('A')
        : addAlias(node.alias('A', nil, node.type 'B'))
        : addAlias(node.alias('A', nil, node.type 'C'))
        : addAlias(node.alias('A', nil, node.type 'D'))
    node.type('B')
        : addAlias(node.alias('B', nil, node.value(1)))
        : addAlias(node.alias('B', nil, node.value(2)))
    node.type('C')
        : addAlias(node.alias('C', nil, node.value(2)))
        : addAlias(node.alias('C', nil, node.value(3)))
    node.type('D')
        : addAlias(node.alias('D', nil, node.value(3)))
        : addAlias(node.alias('D', nil, node.value(4)))

    assert(a:view() == 'A')
    assert(a.value:view() == 'B | C | D')
end

do
    node:reset()
    --[[
    ---@class A: { [string]: boolean }
    ]]

    local a = node.type('A')
        : addClass(node.class('A', nil, { node.table {
            [node.STRING] = node.BOOLEAN,
        }}))

    assert(a:view() == 'A')
    assert(a.value:view() == '{ [string]: boolean }')
end

do
    node:reset()
    --[[
    ---@class A: B
    ---@field x 1

    ---@class B: A
    ---@field y 2
    ]]

    local a = node.type('A')
        : addClass(node.class('A', nil, { node.type 'B' })
            : addField {
                key   = node.value('x'),
                value = node.value(1)
            }
        )

    local b = node.type('B')
        : addClass(node.class('B', nil, { node.type 'A' })
            : addField {
                key   = node.value('y'),
                value = node.value(2)
            }
        )

    assert(a:view() == 'A')
    assert(a.value:view() == '{ x: 1, y: 2 }')

    assert(b:view() == 'B')
    assert(b.value:view() == '{ x: 1, y: 2 }')
end
