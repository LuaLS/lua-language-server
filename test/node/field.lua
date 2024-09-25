do
    assert(ls.node.NEVER:get('x') == ls.node.NEVER)
    assert(ls.node.NIL:get('x') == ls.node.NEVER)
    assert(ls.node.UNKNOWN:get('x') == ls.node.ANY)
    assert(ls.node.ANY:get('x') == ls.node.ANY)
    assert(ls.node.TABLE:get('x') == ls.node.ANY)
end

do
    local t = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.type 'number'
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.type 'boolean'
        }
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.type 'string'
        }
        : addField {
            key   = ls.node.union { ls.node.value(1), ls.node.value(2) },
            value = ls.node.value('union')
        }
        : addField {
            key   = ls.node.type 'string',
            value = ls.node.value('string')
        }
        : addField {
            key   = ls.node.type 'integer',
            value = ls.node.value('integer')
        }
        : addField {
            key   = ls.node.type 'number',
            value = ls.node.value('number')
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
    assert(t:get(ls.node.ANY):view() == [["union" | number | boolean | string | "integer" | "number" | "string"]])
    assert(t.sortedFields[1].key == ls.node.value(1))
    assert(t.sortedFields[2].key == ls.node.value(2))
    assert(t.sortedFields[3].key == ls.node.value 'x')
    assert(t.sortedFields[4].key == ls.node.value 'y')
    assert(t.sortedFields[5].key == ls.node.value 'z')
    assert(t.sortedFields[6].key == ls.node.type 'integer')
    assert(t.sortedFields[7].key == ls.node.type 'number')
    assert(t.sortedFields[8].key == ls.node.type 'string')
end

do
    local a = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }

    local b = ls.node.table()
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
        }

    local u = a | b

    assert(u:get('x'):view() == '"x" | nil')
    assert(u:get('y'):view() == '"y" | nil')
    assert(u:get(ls.node.ANY):view() == [["x" | "y"]])
end

do
    ---@type table<string, Node.Type>
    local t = {}
    local names = {'A', 'A1', 'A2', 'A11', 'A12', 'A21', 'A22'}

    for _, name in ipairs(names) do
        ls.node.TYPE_POOL[name] = nil
        t[name] = ls.node.type(name)
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
            key   = ls.node.value(name),
            value = ls.node.value(name),
        }
    end

    assert(t.A:get('A1'):view() == '"A1"')
    assert(t.A:get('A11'):view() == '"A11"')
    assert(t.A:get('A33'):view() == 'nil')

    assert(t.A:get(ls.node.ANY):view() == [["A" | "A1" | "A11" | "A12" | "A2" | "A21" | "A22"]])
    local value = t.A.value
    assert(value.kind == 'table')
    ---@cast value Node.Table
    assert(value.sortedFields[1].key == ls.node.value "A")
    assert(value.sortedFields[2].key == ls.node.value "A1")
    assert(value.sortedFields[3].key == ls.node.value "A11")
    assert(value.sortedFields[4].key == ls.node.value "A12")
    assert(value.sortedFields[5].key == ls.node.value "A2")
    assert(value.sortedFields[6].key == ls.node.value "A21")
    assert(value.sortedFields[7].key == ls.node.value "A22")
end

do
    local a = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }

    local b = ls.node.table()
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
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
    local a = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }

    local b = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'y'
        }
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
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
    local a = ls.node.table()
        : addField {
            key   = ls.node.value 'x',
            value = ls.node.value 'x'
        }

    local b = ls.node.table()
        : addField {
            key   = ls.node.value 'y',
            value = ls.node.value 'y'
        }

    local c = ls.node.table()
        : addField {
            key   = ls.node.value 'z',
            value = ls.node.value 'z'
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
    local t = ls.node.table()

    assert(t:get(ls.node.ANY):view() == 'nil')
    assert(t:get(ls.node.UNKNOWN):view() == 'nil')
end

do
    local t = ls.node.tuple()

    assert(t:get(ls.node.ANY):view() == 'nil')
    assert(t:get(ls.node.UNKNOWN):view() == 'nil')
end

do
    local t = ls.node.tuple()
        : insert(ls.node.value 'x')
        : insert(ls.node.value 'y')
        : insert(ls.node.value 'z')

    assert(t:get(ls.node.ANY):view() == '"x" | "y" | "z"')
    assert(t:get(ls.node.UNKNOWN):view() == '"x" | "y" | "z"')

    assert(t:get(1):view() == '"x"')
    assert(t:get(2):view() == '"y"')
    assert(t:get(3):view() == '"z"')
    assert(t:get(4):view() == 'nil')

    assert(t:get(ls.node.value(1)):view() == '"x"')

    assert(t:get(ls.node.type 'number'):view() == '"x" | "y" | "z"')
    assert(t:get(ls.node.type 'integer'):view() == '"x" | "y" | "z"')
    assert(t:get(ls.node.type 'boolean'):view() == 'nil')

    assert(t:get(ls.node.value(1) | ls.node.value(2) | ls.node.value(9)):view() == '"x" | "y" | nil')
end

do
    local t = ls.node.array(ls.node.value(true))

    assert(t:get(ls.node.ANY):view() == 'true')
    assert(t:get(ls.node.UNKNOWN):view() == 'true')

    assert(t:get(0):view() == 'nil')
    assert(t:get(1):view() == 'true')
    assert(t:get(ls.node.value(1)):view() == 'true')

    assert(t:get(ls.node.type 'number'):view() == 'true')
    assert(t:get(ls.node.type 'integer'):view() == 'true')
    assert(t:get(ls.node.type 'boolean'):view() == 'nil')

    assert(t:get(ls.node.value(1) | ls.node.value(2)):view() == 'true')
    assert(t:get(ls.node.value(0) | ls.node.value(1)):view() == 'true | nil')
end
