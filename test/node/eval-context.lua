local rt = test.scope.rt

do
    rt:reset()
    local node = rt.variable 'x'
    node:addType(rt.STRING | rt.NIL)
    rt:withEval(function ()
        lt.assertEquals(node.value:view(), 'string | nil')
        node:setCurrentValue(rt.STRING)
        lt.assertEquals(node.value:view(), 'string')
        node:setCurrentValue(rt.NIL)
        lt.assertEquals(node.value:view(), 'nil')
    end)
end

do
    rt:reset()
    local outer = rt:enterEval()
    lt.assertEquals(rt:evalContext(), outer)

    local inner = rt:enterEval()
    lt.assertEquals(rt:evalContext(), inner)

    rt:exitEval()
    lt.assertEquals(rt:evalContext(), outer)

    rt:exitEval()
    lt.assertEquals(rt:evalContext(), nil)
end

do
    rt:reset()
    local ok = pcall(function ()
        ---@diagnostic disable-next-line: await-in-sync
        return rt:withEval(function ()
            error('boom')
        end)
    end)
    lt.assertEquals(ok, false)
    lt.assertEquals(rt:evalContext(), nil)
end

do
    rt:reset()
    local node = rt.variable 'x'
    node:setCurrentValue(rt.value(1))
    local cached = node.value
    lt.assertEquals(cached:view(), '1')

    rt:withEval(function ()
        node:flushCache()
        lt.assertEquals(node.value, cached)
    end)

    lt.assertEquals(node.value == cached, false)
end
