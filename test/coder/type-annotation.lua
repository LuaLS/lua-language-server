local rt = test.scope.rt

do
    -- ---@type A, B 分别绑定 local 的第 1/2 个变量
    local _ <close> = TEST_INDEX [[
    ---@type integer, boolean
    local x, y
    X = x
    Y = y
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'integer')
    lt.assertEquals(rt:globalGet('Y'):view(), 'boolean')
end

do
    -- 单类型只绑定第一个变量，剩下的不覆盖
    local _ <close> = TEST_INDEX [[
    ---@type integer
    local x, y
    X = x
    Y = y
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'integer')
end

do
    -- 注解应覆盖 RHS 的推断结果
    local _ <close> = TEST_INDEX [[
    ---@type string?, integer
    local x, y = unknownCall()
    X = x
    Y = y
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string | nil')
    lt.assertEquals(rt:globalGet('Y'):view(), 'integer')
end
