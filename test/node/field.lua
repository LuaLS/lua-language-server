local rt = test.scope.rt

do
    assert(rt.NEVER:get('x') == rt.NEVER)
    assert(rt.NIL:get('x') == rt.NEVER)
    assert(rt.UNKNOWN:get('x') == rt.ANY)
    assert(rt.ANY:get('x') == rt.ANY)
    assert(rt.TABLE:get('x') == rt.ANY)
end

do
    local t = rt.table()
        : addField(rt.field('x', rt.type 'number'))
        : addField(rt.field('y', rt.type 'boolean'))
        : addField(rt.field('z', rt.type 'string'))
        : addField(rt.field(rt.union { rt.value(1), rt.value(2) }, rt.value('union')))
        : addField(rt.field(rt.type 'string', rt.value('string')))
        : addField(rt.field(rt.type 'integer', rt.value('integer')))
        : addField(rt.field(rt.type 'number', rt.value('number')))

    assert(t:get('x'):view() == 'number')
    assert(t:get('y'):view() == 'boolean')
    assert(t:get('z'):view() == 'string')
    assert(t:get(1):view() == '"union"')
    assert(t:get(2):view() == '"union"')
    assert(t:get('www'):view() == '"string"')
    assert(t:get(3):view() == '"integer"')
    assert(t:get(0.5):view() == '"number"')
    assert(t:get(true):view() == 'nil')
    assert(t:get(rt.ANY):view() == [["union" | number | boolean | string | "integer" | "number" | "string"]])
    assert(t.keys[1] == rt.value(1))
    assert(t.keys[2] == rt.value(2))
    assert(t.keys[3] == rt.value 'x')
    assert(t.keys[4] == rt.value 'y')
    assert(t.keys[5] == rt.value 'z')
    assert(t.keys[6] == rt.type 'integer')
    assert(t.keys[7] == rt.type 'number')
    assert(t.keys[8] == rt.type 'string')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('y', rt.value 'y'))

    local u = a | b

    assert(u:get('x'):view() == '"x" | nil')
    assert(u:get('y'):view() == '"y" | nil')
    assert(u:get(rt.ANY):view() == [["x" | "y"]])
end

do
    rt:reset()

    ---@type table<string, Node.Type>
    local t = {}
    ---@type table<string, Node.Class>
    local c = {}
    local names = {'A', 'A1', 'A2', 'A11', 'A12', 'A21', 'A22'}

    for _, name in ipairs(names) do
        rt.TYPE_POOL[name] = nil
        t[name] = rt.type(name)
        c[name] = rt.class(name)
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
        c[name]:addField(rt.field(rt.value(name), rt.value(name)))
    end

    assert(t.A:get('A1'):view() == '"A1"')
    assert(t.A:get('A11'):view() == '"A11"')
    assert(t.A:get('A33'):view() == 'nil')

    assert(t.A:get(rt.ANY):view() == [["A" | "A1" | "A11" | "A12" | "A2" | "A21" | "A22"]])
    local value = t.A.value
    assert(value.kind == 'table')
    ---@cast value Node.Table
    assert(value.keys[1] == rt.value "A")
    assert(value.keys[2] == rt.value "A1")
    assert(value.keys[3] == rt.value "A11")
    assert(value.keys[4] == rt.value "A12")
    assert(value.keys[5] == rt.value "A2")
    assert(value.keys[6] == rt.value "A21")
    assert(value.keys[7] == rt.value "A22")
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('y', rt.value 'y'))

    local u = a & b

    assert(u:view() == '{ x: "x" } & { y: "y" }')
    assert(u.kind == 'intersection')
    ---@cast u Node.Intersection
    assert(u.value:view() == '{ x: "x", y: "y" }')
    assert(u:get('x'):view() == '"x"')
    assert(u:get('y'):view() == '"y"')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('x', rt.value 'y'))
        : addField(rt.field('y', rt.value 'y'))

    local u = a & b

    assert(u:view() == '{ x: "x" } & { x: "y", y: "y" }')
    assert(u.kind == 'intersection')
    ---@cast u Node.Intersection
    assert(u.value:view() == '{ x: never, y: "y" }')
    assert(u:get('x'):view() == 'never')
    assert(u:get('y'):view() == '"y"')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('y', rt.value 'y'))

    local c = rt.table()
        : addField(rt.field('z', rt.value 'z'))

    local u = a & (b | c)

    assert(u:view() == '{ x: "x" } & ({ y: "y" } | { z: "z" })')
    assert(u.kind == 'intersection')
    ---@cast u Node.Intersection
    assert(u.value:view() == '{ x: "x", y: "y" } | { x: "x", z: "z" }')
    assert(u:get('x'):view() == '"x"')
    assert(u:get('y'):view() == '"y" | nil')
    assert(u:get('z'):view() == '"z" | nil')
end

do
    local t = rt.table()

    assert(t:get(rt.ANY):view() == 'nil')
    assert(t:get(rt.UNKNOWN):view() == 'nil')
end

do
    local t = rt.tuple()

    assert(t:get(rt.ANY):view() == 'nil')
    assert(t:get(rt.UNKNOWN):view() == 'nil')
end

do
    local t = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    assert(t:get(rt.ANY):view() == '"x" | "y" | "z"')
    assert(t:get(rt.UNKNOWN):view() == '"x" | "y" | "z"')

    assert(t:get(1):view() == '"x"')
    assert(t:get(2):view() == '"y"')
    assert(t:get(3):view() == '"z"')
    assert(t:get(4):view() == 'nil')

    assert(t:get(rt.value(1)):view() == '"x"')

    assert(t:get(rt.type 'number'):view() == '"x" | "y" | "z"')
    assert(t:get(rt.type 'integer'):view() == '"x" | "y" | "z"')
    assert(t:get(rt.type 'boolean'):view() == 'nil')

    assert(t:get(rt.value(1) | rt.value(2) | rt.value(9)):view() == '"x" | "y" | nil')
end

do
    local t = rt.array(rt.value(true))

    assert(t:get(rt.ANY):view() == 'true')
    assert(t:get(rt.UNKNOWN):view() == 'true')

    assert(t:get(0):view() == 'nil')
    assert(t:get(1):view() == 'true')
    assert(t:get(rt.value(1)):view() == 'true')

    assert(t:get(rt.type 'number'):view() == 'true')
    assert(t:get(rt.type 'integer'):view() == 'true')
    assert(t:get(rt.type 'boolean'):view() == 'nil')

    assert(t:get(rt.value(1) | rt.value(2)):view() == 'true')
    assert(t:get(rt.value(0) | rt.value(1)):view() == 'true | nil')
end

do
    local index = rt.index(
        rt.table()
            : addField(rt.field('x', rt.value(1)))
            : addField(rt.field('y', rt.value(2))),
        rt.value 'x'
    )
    assert(index:view() == '1')
end

do
    local t = rt.table {
        [1] = 100,
        [2] = 200,
    }

    local v = t:get(rt.INTEGER)
    assert(v:view() == '100 | 200')
end
