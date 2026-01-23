local rt = test.scope.rt

do
    --[[
    ---@type string?
    local x
    if x then
        x
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.STRING | rt.NIL)

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', { 'ref', 'x', 'x1' } },
            { 'ref', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), 'string | nil')
    lt.assertEquals(r['x1']:view(), 'string | nil')
    lt.assertEquals(r['x2']:view(), 'string')
    lt.assertEquals(r['x3']:view(), 'nil')
    lt.assertEquals(r['x4']:view(), 'string | nil')
end

do
    --[[
    ---@type 1 | 2
    local x
    if x == 1 then
        x
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.value(1) | rt.value(2))

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    r['value'] = rt.value(1)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', { 'equal', { 'ref', 'x', 'x1' }, { 'value', 'value' } } },
            { 'ref', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), '1 | 2')
    lt.assertEquals(r['x1']:view(), '1 | 2')
    lt.assertEquals(r['x2']:view(), '1')
    lt.assertEquals(r['x3']:view(), '2')
    lt.assertEquals(r['x4']:view(), '1 | 2')
end

do
    --[[
    ---@type 1 | 2
    local x
    if 1 == x then
        x
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.value(1) | rt.value(2))

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    r['value'] = rt.value(1)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', { 'equal', { 'value', 'value' }, { 'ref', 'x', 'x1' } } },
            { 'ref', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), '1 | 2')
    lt.assertEquals(r['x1']:view(), '1 | 2')
    lt.assertEquals(r['x2']:view(), '1')
    lt.assertEquals(r['x3']:view(), '2')
    lt.assertEquals(r['x4']:view(), '1 | 2')
end

do
    --[[
    ---@type { a: 1 } | { b: 2 }
    local x
    if x.a then
        x
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}
    local p = {}

    local tracer = rt.tracer(r, p)

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.table {
        a = rt.value(1)
    } | rt.table {
        b = rt.value(2)
    })


    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x.a1'] = r['x0']:getChild('a')
    r['x.a1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    p['x.a'] = { 'x', 'a' }

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'ref', 'x', 'x1' },
            { 'condition', { 'ref', 'x.a', 'x.a1' } },
            { 'ref', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), '{ a: 1 } | { b: 2 }')
    lt.assertEquals(r['x1']:view(), '{ a: 1 } | { b: 2 }')
    lt.assertEquals(r['x2']:view(), '{ a: 1 }')
    lt.assertEquals(r['x3']:view(), '{ b: 2 }')
    lt.assertEquals(r['x4']:view(), '{ a: 1 } | { b: 2 }')
end

do
    --[[
    ---@type { a: 1 } | { a: 2 }
    local x
    if x.a == 1 then
        x
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}
    local p = {}

    local tracer = rt.tracer(r, p)

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.table {
        a = rt.value(1)
    } | rt.table {
        a = rt.value(2)
    })

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x.a1'] = r['x0']:getChild('a')
    r['x.a1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    r['value'] = rt.value(1)

    p['x.a'] = { 'x', 'a' }

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'ref', 'x', 'x1' },
            { 'condition', { 'equal', { 'ref', 'x.a', 'x.a1' }, { 'value', 'value' } } },
            { 'ref', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), '{ a: 1 } | { a: 2 }')
    lt.assertEquals(r['x1']:view(), '{ a: 1 } | { a: 2 }')
    lt.assertEquals(r['x2']:view(), '{ a: 1 }')
    lt.assertEquals(r['x3']:view(), '{ a: 2 }')
    lt.assertEquals(r['x4']:view(), '{ a: 1 } | { a: 2 }')
end

do
    --[[
    ---@class A
    ---@field a { x: 1 }

    ---@class B
    ---@field a { x: 2 }
    
    ---@type A | B
    local x
    if x.a.x == 1 then
        x
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}
    local p = {}

    local A = rt.class('A')
        : addField(rt.field('a', rt.table { x = rt.value(1) }))

    local B = rt.class('B')
        : addField(rt.field('a', rt.table { x = rt.value(2) }))

    local tracer = rt.tracer(r, p)

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.type 'A' | rt.type 'B')

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x.a1'] = r['x0']:getChild('a')
    r['x.a1']:setTracer(tracer)
    r['x.a.x1'] = r['x.a1']:getChild('x')
    r['x.a.x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    r['value'] = rt.value(1)

    p['x.a'] = { 'x', 'a' }
    p['x.a.x'] = { 'x.a', 'x' }

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'ref', 'x', 'x1' },
            { 'ref', 'x.a', 'x.a1' },
            { 'condition', { 'equal', { 'ref', 'x.a.x', 'x.a.x1' }, { 'value', 'value' } } },
            { 'ref', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), 'A | B')
    lt.assertEquals(r['x1']:view(), 'A | B')
    lt.assertEquals(r['x2']:view(), 'A')
    lt.assertEquals(r['x3']:view(), 'B')
    lt.assertEquals(r['x4']:view(), 'A | B')
end

do
    --[[
    ---@type 1 | 2
    local x
    if x == 1 then
        x = 3
    else
        x
    end
    x
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.value(1) | rt.value(2))

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow(rt.value(3))
    r['x2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)

    r['value'] = rt.value(1)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', { 'equal', { 'ref', 'x', 'x1' }, { 'value', 'value' } } },
            { 'var', 'x', 'x2' }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }

    lt.assertEquals(r['x0']:view(), '1 | 2')
    lt.assertEquals(r['x1']:view(), '1 | 2')
    lt.assertEquals(r['x2']:view(), '3')
    lt.assertEquals(r['x3']:view(), '2')
    lt.assertEquals(r['x4']:view(), '2 | 3')
end
