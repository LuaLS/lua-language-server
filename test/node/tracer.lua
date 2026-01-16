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
            { 'condition', {
                { 'ref', 'x', 'x1' },
            } },
            { 'block', {
                { 'ref', 'x', 'x2' }
            } }
        }, {
            { 'ref', 'x', 'x3' }
        } },
        { 'ref', 'x', 'x4' },
    }
end
