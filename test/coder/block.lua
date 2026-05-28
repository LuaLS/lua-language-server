local rt = test.scope.rt

-- 回归测试：table 构造器中 call/binary/unary 作为 [key] 时不应抛 'No such key'
do
    TEST_INDEX [[
        local sb = string.byte
        local t = {
            [string.byte '"'] = 1,
            [1 + 2]            = 2,
            [not false]        = 3,
        }
    ]]
end

-- Bug 3 回归测试：多个 ---@return 注解含行内注释时，解析器不应为同一源位置
-- 产生重复的 cat 节点，否则 coder 会触发 "Key already exists" 错误。
do
    TEST_INDEX [[
        ---@return string baseDir       -- normalized path
        ---@return string nativeBaseDir -- original OS path
        ---@return string pattern
        local function parseGlob(pathGlob)
            return './', './', pathGlob
        end
    ]]
    -- 只要 vfile:index() 不抛出异常即可，无需额外断言
end

do
    TEST_INDEX [[
    do
        X = 1
    end
    ]]

    local X = rt:globalGet('X')
    lt.assertEquals(X:view(), '1')
end

do
    TEST_INDEX [[
    if true then
        X = 1
    elseif true then
        Y = 2
    else
        Z = 3
    end
    ]]

    local X = rt:globalGet('X')
    local Y = rt:globalGet('Y')
    local Z = rt:globalGet('Z')

    lt.assertEquals(X:view(), '1')
    lt.assertEquals(Y:view(), '2')
    lt.assertEquals(Z:view(), '3')
end

do
    TEST_INDEX [[
    function F(a, b)
    end
    ]]

    local F = rt:globalGet('F')
    lt.assertEquals(F:view(), 'fun(a: any, b: any)')
end

do
    TEST_INDEX [[
    function F(a, b)
        return
    end
    ]]

    local F = rt:globalGet('F')
    lt.assertEquals(F:view(), 'fun(a: any, b: any)')
end

do
    TEST_INDEX [[
    function F(a, b)
        return 1
    end
    ]]

    local F = rt:globalGet('F')
    lt.assertEquals(F:view(), 'fun(a: any, b: any):1')
end

do
    TEST_INDEX [[
    function F(a, b)
        return 1, 2
    end
    ]]

    local F = rt:globalGet('F')
    lt.assertEquals(F:view(), 'fun(a: any, b: any):(1, 2)')
end

do
    TEST_INDEX [[
    function F(a, b)
        return 1, 2
        return 3, 4
    end
    ]]

    local F = rt:globalGet('F')
    lt.assertEquals(F:view(), 'fun(a: any, b: any):(1 | 3, 2 | 4)')
end

do
    TEST_INDEX [[
    local function next()
        return 1, 2
    end
    for x, y in next do
        X = x
        Y = y
    end
    ]]

    local X = rt:globalGet('X')
    local Y = rt:globalGet('Y')
    lt.assertEquals(X:view(), '1')
    lt.assertEquals(Y:view(), '2')
end

do
    TEST_INDEX [[
    local function next()
        return 1, 2
    end
    local function pairs()
        return next
    end
    for x, y in pairs() do
        X = x
        Y = y
    end
    ]]

    local X = rt:globalGet('X')
    local Y = rt:globalGet('Y')
    lt.assertEquals(X:view(), '1')
    lt.assertEquals(Y:view(), '2')
end
