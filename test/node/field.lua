local node = test.scope.node

do
    assert(node.NEVER:get('x') == node.NEVER)
    assert(node.NIL:get('x') == node.NEVER)
    assert(node.UNKNOWN:get('x') == node.ANY)
    assert(node.ANY:get('x') == node.ANY)
    assert(node.TABLE:get('x') == node.ANY)
end

do
    local t = node.table()
        : addField {
            key   = node.value 'x',
            value = node.type 'number'
        }
        : addField {
            key   = node.value 'y',
            value = node.type 'boolean'
        }
        : addField {
            key   = node.value 'z',
            value = node.type 'string'
        }
        : addField {
            key   = node.union { node.value(1), node.value(2) },
            value = node.value('union')
        }
        : addField {
            key   = node.type 'string',
            value = node.value('string')
        }
        : addField {
            key   = node.type 'integer',
            value = node.value('integer')
        }
        : addField {
            key   = node.type 'number',
            value = node.value('number')
        }

    assert(t:get('x'):view() == 'number')
    assert(t:get('y'):view() == 'boolean')
    assert(t:get('z'):view() == 'string')
    assert(t:get(1):view() == '"union"')
    assert(t:get(2):view() == '"union"')
    assert(t:get('www'):view() == '"string"')
    assert(t:get(3):view() == '"integer"')
    assert(t:get(0.5):view() == '"number"')
    assert(t:get(true):view() == 'nil')
    assert(t:get(node.ANY):view() == [["union" | number | boolean | string | "integer" | "number" | "string"]])
    assert(t.keys[1] == node.value(1))
    assert(t.keys[2] == node.value(2))
    assert(t.keys[3] == node.value 'x')
    assert(t.keys[4] == node.value 'y')
    assert(t.keys[5] == node.value 'z')
    assert(t.keys[6] == node.type 'integer')
    assert(t.keys[7] == node.type 'number')
    assert(t.keys[8] == node.type 'string')
end

do
    local a = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'x'
        }

    local b = node.table()
        : addField {
            key   = node.value 'y',
            value = node.value 'y'
        }

    local u = a | b

    assert(u:get('x'):view() == '"x" | nil')
    assert(u:get('y'):view() == '"y" | nil')
    assert(u:get(node.ANY):view() == [["x" | "y"]])
end

do
    node:reset()

    ---@type table<string, Node.Type>
    local t = {}
    ---@type table<string, Node.Class>
    local c = {}
    local names = {'A', 'A1', 'A2', 'A11', 'A12', 'A21', 'A22'}

    for _, name in ipairs(names) do
        node.TYPE_POOL[name] = nil
        t[name] = node.type(name)
        c[name] = node.class(name)
        t[name]:addClass(c[name])
    end

    c.A:addExtends(t.A1)
    c.A:addExtends(t.A2)
    c.A1:addExtends(t.A11)
    c.A1:addExtends(t.A12)
    c.A2:addExtends(t.A21)
    c.A2:addExtends(t.A22)
    c.A22:addExtends(t.A)

    local extends = t.A.fullExtends
    assert(extends[1] == t.A1)
    assert(extends[2] == t.A2)
    assert(extends[3] == t.A11)
    assert(extends[4] == t.A12)
    assert(extends[5] == t.A21)
    assert(extends[6] == t.A22)

    for _, name in ipairs(names) do
        c[name]:addField {
            key   = node.value(name),
            value = node.value(name),
        }
    end

    assert(t.A:get('A1'):view() == '"A1"')
    assert(t.A:get('A11'):view() == '"A11"')
    assert(t.A:get('A33'):view() == 'nil')

    assert(t.A:get(node.ANY):view() == [["A" | "A1" | "A11" | "A12" | "A2" | "A21" | "A22"]])
    local value = t.A.value
    assert(value.kind == 'table')
    ---@cast value Node.Table
    assert(value.keys[1] == node.value "A")
    assert(value.keys[2] == node.value "A1")
    assert(value.keys[3] == node.value "A11")
    assert(value.keys[4] == node.value "A12")
    assert(value.keys[5] == node.value "A2")
    assert(value.keys[6] == node.value "A21")
    assert(value.keys[7] == node.value "A22")
end

do
    local a = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'x'
        }

    local b = node.table()
        : addField {
            key   = node.value 'y',
            value = node.value 'y'
        }

    local u = a & b

    assert(u:view() == '{ x: "x" } & { y: "y" }')
    assert(u.kind == 'intersection')
    ---@cast u Node.Intersection
    assert(u.value:view() == '{ x: "x", y: "y" }')
    assert(u:get('x'):view() == '"x"')
    assert(u:get('y'):view() == '"y"')
end

do
    local a = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'x'
        }

    local b = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'y'
        }
        : addField {
            key   = node.value 'y',
            value = node.value 'y'
        }

    local u = a & b

    assert(u:view() == '{ x: "x" } & { x: "y", y: "y" }')
    assert(u.kind == 'intersection')
    ---@cast u Node.Intersection
    assert(u.value:view() == '{ x: never, y: "y" }')
    assert(u:get('x'):view() == 'never')
    assert(u:get('y'):view() == '"y"')
end

do
    local a = node.table()
        : addField {
            key   = node.value 'x',
            value = node.value 'x'
        }

    local b = node.table()
        : addField {
            key   = node.value 'y',
            value = node.value 'y'
        }

    local c = node.table()
        : addField {
            key   = node.value 'z',
            value = node.value 'z'
        }

    local u = a & (b | c)

    assert(u:view() == '{ x: "x" } & ({ y: "y" } | { z: "z" })')
    assert(u.kind == 'intersection')
    ---@cast u Node.Intersection
    assert(u.value:view() == '({ x: "x" } & { y: "y" }) | ({ x: "x" } & { z: "z" })')
    assert(u:get('x'):view() == '"x"')
    assert(u:get('y'):view() == '"y" | nil')
    assert(u:get('z'):view() == '"z" | nil')
end

do
    local t = node.table()

    assert(t:get(node.ANY):view() == 'nil')
    assert(t:get(node.UNKNOWN):view() == 'nil')
end

do
    local t = node.tuple()

    assert(t:get(node.ANY):view() == 'nil')
    assert(t:get(node.UNKNOWN):view() == 'nil')
end

do
    local t = node.tuple()
        : insert(node.value 'x')
        : insert(node.value 'y')
        : insert(node.value 'z')

    assert(t:get(node.ANY):view() == '"x" | "y" | "z"')
    assert(t:get(node.UNKNOWN):view() == '"x" | "y" | "z"')

    assert(t:get(1):view() == '"x"')
    assert(t:get(2):view() == '"y"')
    assert(t:get(3):view() == '"z"')
    assert(t:get(4):view() == 'nil')

    assert(t:get(node.value(1)):view() == '"x"')

    assert(t:get(node.type 'number'):view() == '"x" | "y" | "z"')
    assert(t:get(node.type 'integer'):view() == '"x" | "y" | "z"')
    assert(t:get(node.type 'boolean'):view() == 'nil')

    assert(t:get(node.value(1) | node.value(2) | node.value(9)):view() == '"x" | "y" | nil')
end

do
    local t = node.array(node.value(true))

    assert(t:get(node.ANY):view() == 'true')
    assert(t:get(node.UNKNOWN):view() == 'true')

    assert(t:get(0):view() == 'nil')
    assert(t:get(1):view() == 'true')
    assert(t:get(node.value(1)):view() == 'true')

    assert(t:get(node.type 'number'):view() == 'true')
    assert(t:get(node.type 'integer'):view() == 'true')
    assert(t:get(node.type 'boolean'):view() == 'nil')

    assert(t:get(node.value(1) | node.value(2)):view() == 'true')
    assert(t:get(node.value(0) | node.value(1)):view() == 'true | nil')
end

do
    local index = node.index(
        node.table()
            : addField {
                key   = node.value 'x',
                value = node.value(1)
            }
            : addField {
                key   = node.value 'y',
                value = node.value(2)
            },
        node.value 'x'
    )
    assert(index:view() == '{ x: 1, y: 2 }["x"]')
    assert(index.value:view() == '1')
end
