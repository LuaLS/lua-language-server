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
            { 'condition', { '==', { 'ref', 'x', 'x1' }, { 'value', 'value' } } },
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
            { 'condition', { '==', { 'value', 'value' }, { 'ref', 'x', 'x1' } } },
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
            { 'condition', { 'ref', 'x', 'x1' }, { 'ref', 'x.a', 'x.a1' }, { '==', { 'ref', 'x.a', 'x.a1' }, { 'value', 'value' } } },
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
            { 'condition', { 'ref', 'x', 'x1' }, { 'ref', 'x.a', 'x.a1' }, { 'ref', 'x.a.x', 'x.a.x1' }, { '==', { 'ref', 'x.a.x', 'x.a.x1' }, { 'value', 'value' } } },
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
            { 'condition', { '==', { 'ref', 'x', 'x1' }, { 'value', 'value' } } },
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
            { 'condition', { 'and', { 'ref', 'x', 'x1' }, { 'ref', 'y', 'y1' } } },
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
                { '==', { 'ref', 'x', 'x1' }, {'value', 'v1'} },
                { '==', { 'ref', 'y', 'y1' }, {'value', 'v3'} }
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
            { 'condition', { 'or', { 'ref', 'x', 'x1' }, { 'ref', 'y', 'y1' } } },
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
                { '==', { 'ref', 'x', 'x1' }, {'value', 'v1'} },
                { '==', { 'ref', 'y', 'y1' }, {'value', 'v3'} }
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
                { '==', { 'ref', 't', 't1' }, { 'ref', 't[1]', 't[1]'}, {'value', 'v1'} },
                { '==', { 'ref', 't', 't2' }, { 'ref', 't[2]', 't[2]'}, {'value', 'v1'} }
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

do
    --[[
    ---@type 1
    local x
    x   -- 第一次访问触发 Tracer 收窄，x1 的 currentValue 被快照为 1
    -- 之后 master 新增定义 2（模拟新文件加入全局变量定义）
    x   -- 收窄缓存应失效，显示 1 | 2
    ]]

    rt:reset()
    local r = {}

    local tracer = rt.tracer(r, {})

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.value(1))

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'ref', 'x', 'x1' },
        { 'ref', 'x', 'x2' },
    }

    -- 第一次访问：触发 trace 收窄，x1/x2 均为 1
    lt.assertEquals(r['x1']:view(), '1')
    lt.assertEquals(r['x2']:view(), '1')

    -- master 新增类型（模拟新定义加入，flushCache 级联到 shadow）
    r['x0']:addType(rt.value(2))

    -- 收窄缓存必须失效：x1/x2 应回退到 master 实时值 1 | 2，
    -- 而不是残留的收窄快照 1
    lt.assertEquals(r['x1']:view(), '1 | 2')
    lt.assertEquals(r['x2']:view(), '1 | 2')
    lt.assertEquals(r['x0']:view(), '1 | 2')
end

do
    --[[
    ---@type string?
    local x
    assert(x)
    x
    ]]
    -- 语句级 assert 调用后，x 收窄为 truthy（去掉 nil）

    rt:reset()
    local r = {}
    local p = {}

    local tracer = rt.tracer(r, p)

    r['assert'] = rt.func():addParamDef('v', rt.ANY, true):addNarrowDef('v', nil)

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.STRING | rt.NIL)

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'ref', 'x', 'x1' },
        { 'call', 'call1', 'assert', { 'x1' } },
        { 'ref', 'x', 'x2' },
    }

    lt.assertEquals(r['x0']:view(), 'string | nil')
    lt.assertEquals(r['x1']:view(), 'string | nil')
    lt.assertEquals(r['x2']:view(), 'string')
end

do
    --[[
    ---@type A | B
    local x
    assertIsType(x)
    x
    ]]
    -- narrow 注解带类型：调用后 x 收窄为指定类型 A

    rt:reset()
    local r = {}
    local p = {}

    local A = rt.class('A')
        : addField(rt.field('a', rt.value(1)))
    local B = rt.class('B')
        : addField(rt.field('b', rt.value(2)))

    local tracer = rt.tracer(r, p)

    r['assertType'] = rt.func():addParamDef('v', rt.ANY, true):addNarrowDef('v', rt.type 'A')

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.type 'A' | rt.type 'B')

    r['x1'] = r['x0']:shadow()
    r['x1']:setTracer(tracer)
    r['x2'] = r['x0']:shadow()
    r['x2']:setTracer(tracer)

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'ref', 'x', 'x1' },
        { 'call', 'call2', 'assertType', { 'x1' } },
        { 'ref', 'x', 'x2' },
    }

    lt.assertEquals(r['x0']:view(), 'A | B')
    lt.assertEquals(r['x1']:view(), 'A | B')
    lt.assertEquals(r['x2']:view(), 'A')
end

do
    --[[
    ---@class A
    ---@field a string?

    ---@type A
    local x
    assert(x.a)
    x.a
    ]]
    -- 嵌套字段窄化：语句级 assert 调用后，x.a 收窄为 truthy（去掉 nil）。
    -- 字段子变量共享 master，顺序持久收窄后该 child 后续读取均收窄。

    rt:reset()
    local r = {}
    local p = {}

    local A = rt.class('A')
        : addField(rt.field('a', rt.STRING | rt.NIL))

    local tracer = rt.tracer(r, p)

    r['assert'] = rt.func():addParamDef('v', rt.ANY, true):addNarrowDef('v', nil)

    r['x0'] = rt.variable 'x'
    r['x0']:addType(rt.type 'A')

    r['x.a'] = r['x0']:getChild('a')
    r['x.a']:setTracer(tracer)

    p['x.a'] = { 'x', 'a' }

    tracer:setFlow {
        { 'var', 'x', 'x0' },
        { 'ref', 'x.a', 'x.a' },
        { 'call', 'call1', 'assert', { 'x.a' } },
        { 'ref', 'x.a', 'x.a' },
    }

    lt.assertEquals(r['x0']:view(), 'A')
    lt.assertEquals(r['x.a']:view(), 'string')
end

do
    --[[
    ---@type string?
    local v

    assert(v)

    g = v
    ]]
    -- 全局变量引用窄化：assert(v) 收窄 v 后，g = v 的全局值应收窄。

    rt:reset()
    local r = {}
    local p = {}

    local tracer = rt.tracer(r, p)

    r['assert'] = rt.func():addParamDef('v', rt.ANY, true):addNarrowDef('v', nil)

    r['v0'] = rt.variable 'v'
    r['v0']:addType(rt.STRING | rt.NIL)

    r['v1'] = r['v0']:shadow()
    r['v1']:setTracer(tracer)

    r['g0'] = rt.variable 'g'
    r['g1'] = r['g0']:shadow()
    r['g1']:addAssign(rt.field('g', r['v1']))
    r['g1']:setStaticValue(r['v1'])

    p['g'] = { 'g' }

    tracer:setFlow {
        { 'var', 'v', 'v0' },
        { 'ref', 'v', 'v1' },
        { 'call', 'call1', 'assert', { 'v1' } },
        { 'ref', 'v', 'v1' },
    }

    lt.assertEquals(r['v1']:view(), 'string')
    lt.assertEquals(r['g1']:view(), 'string')
    lt.assertEquals(r['g0']:view(), 'string')
end
