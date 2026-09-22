local rt = test.scope.rt

do
    -- 内联 cast：读值按注解类型，且只作用于这一次读取
    local _ <close> = TEST_INDEX [==[
    ---@type string?
    local s
    X = s --[[@as string]]
    Y = s
    ]==]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
    lt.assertEquals(rt:globalGet('Y'):view(), 'string | nil')
end

do
    -- 普通长注释不参与 cast
    local _ <close> = TEST_INDEX [==[
    ---@type string?
    local s
    X = s --[[note]]
    ]==]

    lt.assertEquals(rt:globalGet('X'):view(), 'string | nil')
end
