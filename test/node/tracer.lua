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

    local tracer = rt.tracer(r)

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

    assert(r['x0']:view() == 'string | nil')
    assert(r['x1']:view() == 'string | nil')
    assert(r['x2']:view() == 'string')
    assert(r['x3']:view() == 'nil')
    assert(r['x4']:view() == 'string | nil')
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

    local tracer = rt.tracer(r)

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

    assert(r['x0']:view() == '1 | 2')
    assert(r['x1']:view() == '1 | 2')
    assert(r['x2']:view() == '1')
    assert(r['x3']:view() == '2')
    assert(r['x4']:view() == '1 | 2')
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

    local tracer = rt.tracer(r)

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

    assert(r['x0']:view() == '1 | 2')
    assert(r['x1']:view() == '1 | 2')
    assert(r['x2']:view() == '1')
    assert(r['x3']:view() == '2')
    assert(r['x4']:view() == '1 | 2')
end
