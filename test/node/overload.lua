local rt = test.scope.rt

-- 重载语义：一类函数多个签名，匹配时自动选择合适原型（非 union 的"全部匹配"）。

do
    -- 基础签名 fun(n: integer): string；重载签名 fun(x: string): number
    local f = rt.func()
        : addParamDef('n', rt.INTEGER)
        : addReturnDef(nil, rt.STRING)
    f:addOverload(rt.func()
        : addParamDef('x', rt.STRING)
        : addReturnDef(nil, rt.NUMBER))

    -- 用基础签名匹配：应通过（自动选择基础签名）
    local t1 = rt.func()
        : addParamDef('n', rt.INTEGER)
        : addReturnDef(nil, rt.STRING)
    lt.assertEquals(f >> t1, true)

    -- 用重载签名匹配：应通过（自动选择重载签名）
    local t2 = rt.func()
        : addParamDef('x', rt.STRING)
        : addReturnDef(nil, rt.NUMBER)
    lt.assertEquals(f >> t2, true)

    -- 完全不匹配的签名：应失败
    local t3 = rt.func()
        : addParamDef('x', rt.BOOLEAN)
        : addReturnDef(nil, rt.NUMBER)
    lt.assertEquals(f >> t3, false)
    lt.assertEquals(t3 >> f, false)
end

do
    -- 基础签名不匹配、仅某个重载匹配：仍应通过
    local g = rt.func()
        : addParamDef('x', rt.BOOLEAN)
    g:addOverload(rt.func()
        : addParamDef('n', rt.INTEGER)
        : addReturnDef(nil, rt.STRING))

    local t = rt.func()
        : addParamDef('n', rt.INTEGER)
        : addReturnDef(nil, rt.STRING)
    lt.assertEquals(g >> t, true)
end

do
    -- 真正的不确定性函数 union 仍按"全部成员匹配"：任一成员不匹配则失败
    local u = rt.union {
        rt.func():addParamDef('n', rt.INTEGER),
        rt.func():addParamDef('x', rt.STRING),
    }
    local t = rt.func():addParamDef('n', rt.INTEGER)
    lt.assertEquals(u >> t, false)

    local t2 = rt.union {
        rt.func():addParamDef('n', rt.INTEGER),
        rt.func():addParamDef('n', rt.INTEGER),
    }
    lt.assertEquals(t2 >> t, true)
end

do
    -- 无重载的普通函数行为不变
    local g = rt.func():addParamDef('n', rt.INTEGER)
    local t = rt.func():addParamDef('n', rt.INTEGER)
    lt.assertEquals(g >> t, true)
    lt.assertEquals(t >> g, true)
end
