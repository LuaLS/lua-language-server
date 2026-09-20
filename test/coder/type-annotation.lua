local rt = test.scope.rt

do
    -- 残缺下标（如 C# 生成工具写出的 float[*,*]）不应让整个文件编译失败
    local _ <close> = TEST_INDEX [[
    ---@param results float[*,*]
    local function f(results) end
    X = f
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'fun(results: float)')
end

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

do
    -- 循环体内第一句的 ---@type 也应绑定到多值 local 的第一个变量
    local _ <close> = TEST_INDEX [[
    for i = 1, 10 do
        ---@type string?
        local key, tail = unknownCall()
        K = key
    end
    ]]

    lt.assertEquals(rt:globalGet('K'):view(), 'string | nil')
end

do
    -- `?` 后缀的数组类型也要并入 nil
    local _ <close> = TEST_INDEX [[
    ---@type integer[]?
    local a = unknownCall()
    A = a
    ]]

    lt.assertEquals(rt:globalGet('A'):view(), 'integer[] | nil')
end
