do
    assert(test.scope.node.NEVER:get('x') == test.scope.node.NEVER)
    assert(test.scope.node.NIL:get('x') == test.scope.node.NEVER)
    assert(test.scope.node.UNKNOWN:get('x') == test.scope.node.ANY)
    assert(test.scope.node.ANY:get('x') == test.scope.node.ANY)
    assert(test.scope.node.TABLE:get('x') == test.scope.node.ANY)
end

do
    local t = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.type 'number'
        }
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.type 'boolean'
        }
        : addField {
            key   = test.scope.node.value 'z',
            value = test.scope.node.type 'string'
        }
        : addField {
            key   = test.scope.node.union { test.scope.node.value(1), test.scope.node.value(2) },
            value = test.scope.node.value('union')
        }
        : addField {
            key   = test.scope.node.type 'string',
            value = test.scope.node.value('string')
        }
        : addField {
            key   = test.scope.node.type 'integer',
            value = test.scope.node.value('integer')
        }
        : addField {
            key   = test.scope.node.type 'number',
            value = test.scope.node.value('number')
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
    assert(t:get(test.scope.node.ANY):view() == [["union" | number | boolean | string | "integer" | "number" | "string"]])
    assert(t.sortedFields[1].key == test.scope.node.value(1))
    assert(t.sortedFields[2].key == test.scope.node.value(2))
    assert(t.sortedFields[3].key == test.scope.node.value 'x')
    assert(t.sortedFields[4].key == test.scope.node.value 'y')
    assert(t.sortedFields[5].key == test.scope.node.value 'z')
    assert(t.sortedFields[6].key == test.scope.node.type 'integer')
    assert(t.sortedFields[7].key == test.scope.node.type 'number')
    assert(t.sortedFields[8].key == test.scope.node.type 'string')
end

do
    local a = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }

    local b = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
        }

    local u = a | b

    assert(u:get('x'):view() == '"x" | nil')
    assert(u:get('y'):view() == '"y" | nil')
    assert(u:get(test.scope.node.ANY):view() == [["x" | "y"]])
end

do
    ---@type table<string, Node.Type>
    local t = {}
    local names = {'A', 'A1', 'A2', 'A11', 'A12', 'A21', 'A22'}

    for _, name in ipairs(names) do
        test.scope.node.TYPE_POOL[name] = nil
        t[name] = test.scope.node.type(name)
    end

    t.A:addExtends(t.A1)
    t.A:addExtends(t.A2)
    t.A1:addExtends(t.A11)
    t.A1:addExtends(t.A12)
    t.A2:addExtends(t.A21)
    t.A2:addExtends(t.A22)
    t.A22:addExtends(t.A)

    local extends = t.A.fullExtends
    assert(extends[1] == t.A1)
    assert(extends[2] == t.A2)
    assert(extends[3] == t.A11)
    assert(extends[4] == t.A12)
    assert(extends[5] == t.A21)
    assert(extends[6] == t.A22)

    for _, name in ipairs(names) do
        t[name]:addField {
            key   = test.scope.node.value(name),
            value = test.scope.node.value(name),
        }
    end

    assert(t.A:get('A1'):view() == '"A1"')
    assert(t.A:get('A11'):view() == '"A11"')
    assert(t.A:get('A33'):view() == 'nil')

    assert(t.A:get(test.scope.node.ANY):view() == [["A" | "A1" | "A11" | "A12" | "A2" | "A21" | "A22"]])
    local value = t.A.value
    assert(value.kind == 'table')
    ---@cast value Node.Table
    assert(value.sortedFields[1].key == test.scope.node.value "A")
    assert(value.sortedFields[2].key == test.scope.node.value "A1")
    assert(value.sortedFields[3].key == test.scope.node.value "A11")
    assert(value.sortedFields[4].key == test.scope.node.value "A12")
    assert(value.sortedFields[5].key == test.scope.node.value "A2")
    assert(value.sortedFields[6].key == test.scope.node.value "A21")
    assert(value.sortedFields[7].key == test.scope.node.value "A22")
end

do
    local a = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }

    local b = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
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
    local a = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }

    local b = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'y'
        }
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
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
    local a = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'x',
            value = test.scope.node.value 'x'
        }

    local b = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'y',
            value = test.scope.node.value 'y'
        }

    local c = test.scope.node.table()
        : addField {
            key   = test.scope.node.value 'z',
            value = test.scope.node.value 'z'
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
    local t = test.scope.node.table()

    assert(t:get(test.scope.node.ANY):view() == 'nil')
    assert(t:get(test.scope.node.UNKNOWN):view() == 'nil')
end

do
    local t = test.scope.node.tuple()

    assert(t:get(test.scope.node.ANY):view() == 'nil')
    assert(t:get(test.scope.node.UNKNOWN):view() == 'nil')
end

do
    local t = test.scope.node.tuple()
        : insert(test.scope.node.value 'x')
        : insert(test.scope.node.value 'y')
        : insert(test.scope.node.value 'z')

    assert(t:get(test.scope.node.ANY):view() == '"x" | "y" | "z"')
    assert(t:get(test.scope.node.UNKNOWN):view() == '"x" | "y" | "z"')

    assert(t:get(1):view() == '"x"')
    assert(t:get(2):view() == '"y"')
    assert(t:get(3):view() == '"z"')
    assert(t:get(4):view() == 'nil')

    assert(t:get(test.scope.node.value(1)):view() == '"x"')

    assert(t:get(test.scope.node.type 'number'):view() == '"x" | "y" | "z"')
    assert(t:get(test.scope.node.type 'integer'):view() == '"x" | "y" | "z"')
    assert(t:get(test.scope.node.type 'boolean'):view() == 'nil')

    assert(t:get(test.scope.node.value(1) | test.scope.node.value(2) | test.scope.node.value(9)):view() == '"x" | "y" | nil')
end

do
    local t = test.scope.node.array(test.scope.node.value(true))

    assert(t:get(test.scope.node.ANY):view() == 'true')
    assert(t:get(test.scope.node.UNKNOWN):view() == 'true')

    assert(t:get(0):view() == 'nil')
    assert(t:get(1):view() == 'true')
    assert(t:get(test.scope.node.value(1)):view() == 'true')

    assert(t:get(test.scope.node.type 'number'):view() == 'true')
    assert(t:get(test.scope.node.type 'integer'):view() == 'true')
    assert(t:get(test.scope.node.type 'boolean'):view() == 'nil')

    assert(t:get(test.scope.node.value(1) | test.scope.node.value(2)):view() == 'true')
    assert(t:get(test.scope.node.value(0) | test.scope.node.value(1)):view() == 'true | nil')
end

do
    local t = test.scope.node.array(test.scope.node.value(true), 3)

    assert(t:get(test.scope.node.ANY):view() == 'true')
    assert(t:get(test.scope.node.UNKNOWN):view() == 'true')

    assert(t:get(0):view() == 'nil')
    assert(t:get(1):view() == 'true')
    assert(t:get(test.scope.node.value(1)):view() == 'true')
    assert(t:get(test.scope.node.value(4)):view() == 'nil')

    assert(t:get(test.scope.node.type 'number'):view() == 'true')
    assert(t:get(test.scope.node.type 'integer'):view() == 'true')
    assert(t:get(test.scope.node.type 'boolean'):view() == 'nil')

    assert(t:get(test.scope.node.value(1) | test.scope.node.value(2)):view() == 'true')
    assert(t:get(test.scope.node.value(0) | test.scope.node.value(1)):view() == 'true | nil')
    assert(t:get(test.scope.node.value(1) | test.scope.node.value(4)):view() == 'true | nil')
end
