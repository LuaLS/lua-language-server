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
            { 'condition', { '==', { 'value', 'value' }, 'v', { 'ref', 'x', 'x1' }, 'v' } },
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
            { 'condition', { '==', { 'value', 'value' }, 'v', { 'ref', 'x', 'x1' }, 'v' } },
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
    --r['x.a1']:setTracer(tracer)
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
            { 'condition', { 'ref', 'x', 'x1' }, { 'ref', 'x.a', 'x.a1' } },
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
            { 'condition', { '==', { 'ref', 'x', 'x1' }, { 'ref', 'x.a', 'x.a1' }, 'v', { 'value', 'value' }, 'v' } },
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
            { 'condition', { '==', { 'ref', 'x', 'x1' }, { 'ref', 'x.a', 'x.a1' }, { 'ref', 'x.a.x', 'x.a.x1' }, 'v', { 'value', 'value' }, 'v' } },
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
            { 'condition', { '==', { 'ref', 'x', 'x1' }, 'v', { 'value', 'value' }, 'v' } },
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

do
    --[[
    ---@type string?
    local x
    ---@type string?
    local y
    if x and y then
        x
        y
    else
        x
        y
    end
    x
    y
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.STRING | rt.NIL)
    r['y0'] = rt.variable 'y'
    r['y0']:addType(rt.STRING | rt.NIL)

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['y1'] = r['y0']:shadow()
    r['y1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['y2'] = r['y0']:shadow()
    r['y2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['y3'] = r['y0']:shadow()
    r['y3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)
    r['y4'] = r['y0']:shadow()
    r['y4']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', { 'and', { 'ref', 'x', 'x1' }, 'v', { 'ref', 'y', 'y1' }, 'v' } },
            { 'ref', 'x', 'x2' },
            { 'ref', 'y', 'y2' },
        }, {
            { 'ref', 'x', 'x3' },
            { 'ref', 'y', 'y3' },
        } },
        { 'ref', 'x', 'x4' },
        { 'ref', 'y', 'y4' },
    }

    lt.assertEquals(r['x0']:view(), 'string | nil')
    lt.assertEquals(r['x1']:view(), 'string | nil')
    lt.assertEquals(r['x2']:view(), 'string')
    lt.assertEquals(r['x3']:view(), 'string | nil')
    lt.assertEquals(r['x4']:view(), 'string | nil')
    lt.assertEquals(r['y0']:view(), 'string | nil')
    lt.assertEquals(r['y1']:view(), 'string | nil')
    lt.assertEquals(r['y2']:view(), 'string')
    lt.assertEquals(r['y3']:view(), 'string | nil')
    lt.assertEquals(r['y4']:view(), 'string | nil')
end

do
    --[[
    ---@type 1 | 2
    local x
    ---@type 3 | 4
    local y
    if x == 1 and y == 3 then
        x
        y
    else
        x
        y
    end
    x
    y
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.value(1) | rt.value(2))
    r['y0'] = rt.variable 'y'
    r['y0']:addType(rt.value(3) | rt.value(4))

    r['v1'] = rt.value(1)
    r['v3'] = rt.value(3)

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['y1'] = r['y0']:shadow()
    r['y1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['y2'] = r['y0']:shadow()
    r['y2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['y3'] = r['y0']:shadow()
    r['y3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)
    r['y4'] = r['y0']:shadow()
    r['y4']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', {
                'and',
                { '==', { 'ref', 'x', 'x1' }, 'v', {'value', 'v1'}, 'v' }, 'v',
                { '==', { 'ref', 'y', 'y1' }, 'v', {'value', 'v3'}, 'v' }, 'v'
            } },
            { 'ref', 'x', 'x2' },
            { 'ref', 'y', 'y2' },
        }, {
            { 'ref', 'x', 'x3' },
            { 'ref', 'y', 'y3' },
        } },
        { 'ref', 'x', 'x4' },
        { 'ref', 'y', 'y4' },
    }

    lt.assertEquals(r['x0']:view(), '1 | 2')
    lt.assertEquals(r['x1']:view(), '1 | 2')
    lt.assertEquals(r['x2']:view(), '1')
    lt.assertEquals(r['x3']:view(), '1 | 2')
    lt.assertEquals(r['x4']:view(), '1 | 2')
    lt.assertEquals(r['y0']:view(), '3 | 4')
    lt.assertEquals(r['y1']:view(), '3 | 4')
    lt.assertEquals(r['y2']:view(), '3')
    lt.assertEquals(r['y3']:view(), '3 | 4')
    lt.assertEquals(r['y4']:view(), '3 | 4')
end

do
    --[[
    ---@type string?
    local x
    ---@type string?
    local y
    if x or y then
        x
        y
    else
        x
        y
    end
    x
    y
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.STRING | rt.NIL)
    r['y0'] = rt.variable 'y'
    r['y0']:addType(rt.STRING | rt.NIL)

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['y1'] = r['y0']:shadow()
    r['y1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['y2'] = r['y0']:shadow()
    r['y2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['y3'] = r['y0']:shadow()
    r['y3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)
    r['y4'] = r['y0']:shadow()
    r['y4']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', { 'or', { 'ref', 'x', 'x1' }, 'v', { 'ref', 'y', 'y1' }, 'v' } },
            { 'ref', 'x', 'x2' },
            { 'ref', 'y', 'y2' },
        }, {
            { 'ref', 'x', 'x3' },
            { 'ref', 'y', 'y3' },
        } },
        { 'ref', 'x', 'x4' },
        { 'ref', 'y', 'y4' },
    }

    lt.assertEquals(r['x0']:view(), 'string | nil')
    lt.assertEquals(r['x1']:view(), 'string | nil')
    lt.assertEquals(r['x2']:view(), 'string | nil')
    lt.assertEquals(r['x3']:view(), 'nil')
    lt.assertEquals(r['x4']:view(), 'string | nil')
    lt.assertEquals(r['y0']:view(), 'string | nil')
    lt.assertEquals(r['y1']:view(), 'string | nil')
    lt.assertEquals(r['y2']:view(), 'string | nil')
    lt.assertEquals(r['y3']:view(), 'nil')
    lt.assertEquals(r['y4']:view(), 'string | nil')
end

do
    --[[
    ---@type 1 | 2
    local x
    ---@type 3 | 4
    local y
    if x == 1 or y == 3 then
        x
        y
    else
        x
        y
    end
    x
    y
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.value(1) | rt.value(2))
    r['y0'] = rt.variable 'y'
    r['y0']:addType(rt.value(3) | rt.value(4))

    r['v1'] = rt.value(1)
    r['v3'] = rt.value(3)

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['y1'] = r['y0']:shadow()
    r['y1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)
    r['y2'] = r['y0']:shadow()
    r['y2']:setTracer(tracer)
    r['x3'] = r['x0']:shadow()
    r['x3']:setTracer(tracer)
    r['y3'] = r['y0']:shadow()
    r['y3']:setTracer(tracer)
    r['x4'] = r['x0']:shadow()
    r['x4']:setTracer(tracer)
    r['y4'] = r['y0']:shadow()
    r['y4']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'if' , {
            { 'condition', {
                'or',
                { '==', { 'ref', 'x', 'x1' }, 'v', {'value', 'v1'}, 'v' }, 'v',
                { '==', { 'ref', 'y', 'y1' }, 'v', {'value', 'v3'}, 'v' }, 'v'
            } },
            { 'ref', 'x', 'x2' },
            { 'ref', 'y', 'y2' },
        }, {
            { 'ref', 'x', 'x3' },
            { 'ref', 'y', 'y3' },
        } },
        { 'ref', 'x', 'x4' },
        { 'ref', 'y', 'y4' },
    }

    lt.assertEquals(r['x0']:view(), '1 | 2')
    lt.assertEquals(r['x1']:view(), '1 | 2')
    lt.assertEquals(r['x2']:view(), '1 | 2')
    lt.assertEquals(r['x3']:view(), '2')
    lt.assertEquals(r['x4']:view(), '1 | 2')
    lt.assertEquals(r['y0']:view(), '3 | 4')
    lt.assertEquals(r['y1']:view(), '3 | 4')
    lt.assertEquals(r['y2']:view(), '3 | 4')
    lt.assertEquals(r['y3']:view(), '4')
    lt.assertEquals(r['y4']:view(), '3 | 4')
end

do
    --[[
    ---@type [1,1] | [1,2] | [2,1] | [2,2]
    local t
    if t[1] == 1 and t[2] == 1 thent
        t
    else
        t
    end
    t
    ]]

    rt:reset()
    local r = {}
    local p = {}

    local tracer = rt.tracer(r, p)

    r['t0'] = rt.variable 't'
    r['t0']:addType(rt.union {
        rt.tuple { rt.value(1), rt.value(1) },
        rt.tuple { rt.value(1), rt.value(2) },
        rt.tuple { rt.value(2), rt.value(1) },
        rt.tuple { rt.value(2), rt.value(2) },
    })

    r['v1'] = rt.value(1)

    r['t1'] = r['t0']:shadow()
    r['t1']:setTracer(tracer)
    r['t2'] = r['t0']:shadow()
    r['t2']:setTracer(tracer)
    r['t3'] = r['t0']:shadow()
    r['t3']:setTracer(tracer)
    r['t4'] = r['t0']:shadow()
    r['t4']:setTracer(tracer)
    r['t5'] = r['t0']:shadow()
    r['t5']:setTracer(tracer)
    r['t[1]'] = r['t0']:getChild(1)
    r['t[2]'] = r['t0']:getChild(2)

    tracer:setFlow {
        { 'var', 't', 't0' },
        { 'if' , {
            { 'condition', {
                'and',
                { '==', { 'ref', 't', 't1' }, { 'ref', 't[1]', 't[1]'}, 'v', {'value', 'v1'}, 'v' }, 'v',
                { '==', { 'ref', 't', 't2' }, { 'ref', 't[2]', 't[2]'}, 'v', {'value', 'v1'}, 'v' }, 'v'
            } },
            { 'ref', 't', 't3' },
        }, {
            { 'ref', 't', 't4' },
        } },
        { 'ref', 't', 't5' },
    }

    p['t[1]'] = {'t', 1}
    p['t[2]'] = {'t', 2}

    lt.assertEquals(r['t0']:view(), '[1, 1] | [1, 2] | [2, 1] | [2, 2]')
    lt.assertEquals(r['t1']:view(), '[1, 1] | [1, 2] | [2, 1] | [2, 2]')
    lt.assertEquals(r['t2']:view(), '[1, 1] | [1, 2]')
    lt.assertEquals(r['t3']:view(), '[1, 1]')
    lt.assertEquals(r['t4']:view(), '[1, 2] | [2, 1] | [2, 2]')
    lt.assertEquals(r['t5']:view(), '[1, 1] | [1, 2] | [2, 1] | [2, 2]')
end
