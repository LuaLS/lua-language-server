local rt = test.scope.rt

do
    -- 自引用 table：T.f = T（类型图成环）
    rt:reset()
    local T = rt.table()
    T:addField(rt.field('f', T))
    local ok, err = pcall(function ()
        return T.hasGeneric
    end)
    lt.assertEquals(ok, true, 'hasGeneric should not recurse, err=' .. tostring(err))
end

do
    -- 交叉引用：A.f = B，B.f = A
    rt:reset()
    local A = rt.table()
    local B = rt.table()
    A:addField(rt.field('f', B))
    B:addField(rt.field('f', A))
    local ok, err = pcall(function ()
        return A.hasGeneric or B.hasGeneric
    end)
    lt.assertEquals(ok, true, 'hasGeneric should not recurse, err=' .. tostring(err))
end

do
    -- 含泛型字段的自引用
    rt:reset()
    local T = rt.generic('T')
    local K = rt.generic('K')
    local table0 = rt.table()
    table0:addField(rt.field('f', table0))
    table0:addField(rt.field('g', K))
    local ok, err = pcall(function ()
        return table0.hasGeneric
    end)
    lt.assertEquals(ok, true, 'hasGeneric should not recurse, err=' .. tostring(err))
end
