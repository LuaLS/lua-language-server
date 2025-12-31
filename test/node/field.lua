local rt = test.scope.rt

do
    lt.assertEquals(rt.NEVER:get('x'), rt.NEVER)
    lt.assertEquals(rt.NIL:get('x'), rt.NEVER)
    lt.assertEquals(rt.UNKNOWN:get('x'), rt.ANY)
    lt.assertEquals(rt.ANY:get('x'), rt.ANY)
    lt.assertEquals(rt.TABLE:get('x'), rt.ANY)
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

    lt.assertEquals(t:get('x'):view(), 'number')
    lt.assertEquals(t:get('y'):view(), 'boolean')
    lt.assertEquals(t:get('z'):view(), 'string')
    lt.assertEquals(t:get(1):view(), '"union"')
    lt.assertEquals(t:get(2):view(), '"union"')
    lt.assertEquals(t:get('www'):view(), '"string"')
    lt.assertEquals(t:get(3):view(), '"integer"')
    lt.assertEquals(t:get(0.5):view(), '"number"')
    lt.assertEquals(t:get(true):view(), 'nil')
    lt.assertEquals(t:get(rt.ANY):view(), [["union" | "integer" | "number" | "string" | number | boolean | string]])
    lt.assertEquals(t.keys[1], rt.value(1))
    lt.assertEquals(t.keys[2], rt.value(2))
    lt.assertEquals(t.keys[3], rt.value 'x')
    lt.assertEquals(t.keys[4], rt.value 'y')
    lt.assertEquals(t.keys[5], rt.value 'z')
    lt.assertEquals(t.keys[6], rt.type 'integer')
    lt.assertEquals(t.keys[7], rt.type 'number')
    lt.assertEquals(t.keys[8], rt.type 'string')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('y', rt.value 'y'))

    local u = a | b

    lt.assertEquals(u:get('x'):view(), '"x" | nil')
    lt.assertEquals(u:get('y'):view(), '"y" | nil')
    lt.assertEquals(u:get(rt.ANY):view(), [["x" | "y"]])
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
    lt.assertEquals(extends[1], t.A1)
    lt.assertEquals(extends[2], t.A2)
    lt.assertEquals(extends[3], t.A11)
    lt.assertEquals(extends[4], t.A12)
    lt.assertEquals(extends[5], t.A21)
    lt.assertEquals(extends[6], t.A22)

    for _, name in ipairs(names) do
        c[name]:addField(rt.field(rt.value(name), rt.value(name)))
    end

    lt.assertEquals(t.A:get('A1'):view(), '"A1"')
    lt.assertEquals(t.A:get('A11'):view(), '"A11"')
    lt.assertEquals(t.A:get('A33'):view(), 'nil')

    lt.assertEquals(t.A:get(rt.ANY):view(), [["A" | "A1" | "A11" | "A12" | "A2" | "A21" | "A22"]])
    local value = t.A.value
    lt.assertEquals(value.kind, 'table')
    ---@cast value Node.Table
    lt.assertEquals(value.keys[1], rt.value "A")
    lt.assertEquals(value.keys[2], rt.value "A1")
    lt.assertEquals(value.keys[3], rt.value "A11")
    lt.assertEquals(value.keys[4], rt.value "A12")
    lt.assertEquals(value.keys[5], rt.value "A2")
    lt.assertEquals(value.keys[6], rt.value "A21")
    lt.assertEquals(value.keys[7], rt.value "A22")
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('y', rt.value 'y'))

    local u = a & b

    lt.assertEquals(u:view(), '{ x: "x" } & { y: "y" }')
    lt.assertEquals(u.kind, 'intersection')
    ---@cast u Node.Intersection
    lt.assertEquals(u.value:view(), [[
{
    x: "x",
    y: "y",
}]])
    lt.assertEquals(u:get('x'):view(), '"x"')
    lt.assertEquals(u:get('y'):view(), '"y"')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('x', rt.value 'y'))
        : addField(rt.field('y', rt.value 'y'))

    local u = a & b

    lt.assertEquals(u:view(), [[
{ x: "x" } & {
    x: "y",
    y: "y",
}]])
    lt.assertEquals(u.kind, 'intersection')
    ---@cast u Node.Intersection
    lt.assertEquals(u.value:view(), [[{
    x: never,
    y: "y",
}]])
    lt.assertEquals(u:get('x'):view(), 'never')
    lt.assertEquals(u:get('y'):view(), '"y"')
end

do
    local a = rt.table()
        : addField(rt.field('x', rt.value 'x'))

    local b = rt.table()
        : addField(rt.field('y', rt.value 'y'))

    local c = rt.table()
        : addField(rt.field('z', rt.value 'z'))

    local u = a & (b | c)

    lt.assertEquals(u:view(), '({ x: "x" } & { y: "y" }) | ({ x: "x" } & { z: "z" })')
    lt.assertEquals(u.kind, 'intersection')
    lt.assertEquals(u:get('x'):view(), '"x"')
    lt.assertEquals(u:get('y'):view(), '"y" | nil')
    lt.assertEquals(u:get('z'):view(), '"z" | nil')
end

do
    local t = rt.table()

    lt.assertEquals(t:get(rt.ANY):view(), 'nil')
    lt.assertEquals(t:get(rt.UNKNOWN):view(), 'nil')
end

do
    local t = rt.tuple()

    lt.assertEquals(t:get(rt.ANY):view(), 'nil')
    lt.assertEquals(t:get(rt.UNKNOWN):view(), 'nil')
end

do
    local t = rt.tuple()
        : insert(rt.value 'x')
        : insert(rt.value 'y')
        : insert(rt.value 'z')

    lt.assertEquals(t:get(rt.ANY):view(), '"x" | "y" | "z"')
    lt.assertEquals(t:get(rt.UNKNOWN):view(), '"x" | "y" | "z"')

    lt.assertEquals(t:get(1):view(), '"x"')
    lt.assertEquals(t:get(2):view(), '"y"')
    lt.assertEquals(t:get(3):view(), '"z"')
    lt.assertEquals(t:get(4):view(), 'nil')

    lt.assertEquals(t:get(rt.value(1)):view(), '"x"')

    lt.assertEquals(t:get(rt.type 'number'):view(), '"x" | "y" | "z"')
    lt.assertEquals(t:get(rt.type 'integer'):view(), '"x" | "y" | "z"')
    lt.assertEquals(t:get(rt.type 'boolean'):view(), 'nil')

    lt.assertEquals(t:get(rt.value(1) | rt.value(2) | rt.value(9)):view(), '"x" | "y" | nil')
end

do
    local t = rt.array(rt.value(true))

    lt.assertEquals(t:get(rt.ANY):view(), 'true')
    lt.assertEquals(t:get(rt.UNKNOWN):view(), 'true')

    lt.assertEquals(t:get(0):view(), 'nil')
    lt.assertEquals(t:get(1):view(), 'true')
    lt.assertEquals(t:get(rt.value(1)):view(), 'true')

    lt.assertEquals(t:get(rt.type 'number'):view(), 'true')
    lt.assertEquals(t:get(rt.type 'integer'):view(), 'true')
    lt.assertEquals(t:get(rt.type 'boolean'):view(), 'nil')

    lt.assertEquals(t:get(rt.value(1) | rt.value(2)):view(), 'true')
    lt.assertEquals(t:get(rt.value(0) | rt.value(1)):view(), 'true | nil')
end

do
    local index = rt.index(
        rt.table()
            : addField(rt.field('x', rt.value(1)))
            : addField(rt.field('y', rt.value(2))),
        rt.value 'x'
    )
    lt.assertEquals(index:view(), '1')
end

do
    local t = rt.table {
        [1] = 100,
        [2] = 200,
    }

    local v = t:get(rt.INTEGER)
    lt.assertEquals(v:view(), '100 | 200')
end

do
    local index = rt.index(
        rt.generic 'T',
        rt.value 'xyz'
    )

    lt.assertEquals(index:view(), '<T>["xyz"]')
end

do
    local t = rt.table()
        : addField(rt.field('x', rt.value 'x', true))
        : addField(rt.field('y', rt.value 'y', true))

    lt.assertEquals(t:view(), [[
{
    x?: "x" | nil,
    y?: "y" | nil,
}]])
    lt.assertEquals(t:get('x'):view(), '"x" | nil')
    lt.assertEquals(t:get('y'):view(), '"y" | nil')
end
