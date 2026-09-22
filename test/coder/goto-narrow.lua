local rt = test.scope.rt

do
    -- `goto` 守护：跳走的分支不会顺序落到 if 之后，守护后的读值应为去掉 nil 的类型
    local _ <close> = TEST_INDEX [[
    ---@type string?
    local s
    local function f()
        if not s then
            goto SKIP
        end
        X = s
        ::SKIP::
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
end

do
    -- 字段读取的守护 + goto
    local _ <close> = TEST_INDEX [[
    ---@class Box
    ---@field uri? string

    ---@param box Box
    local function f(box)
        if not box.uri then
            goto SKIP
        end
        X = box.uri
        ::SKIP::
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
end

do
    -- `break` 守护：循环体里的分支跳出循环，同样不落到 if 之后
    local _ <close> = TEST_INDEX [[
    ---@type string?
    local s
    local function f()
        for _ = 1, 3 do
            if not s then
                break
            end
            X = s
        end
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
end

do
    -- 循环里的 `goto continue` 守护（`for` + 标签在循环体末尾）
    local _ <close> = TEST_INDEX [[
    ---@type string?
    local s
    local function f()
        for _ = 1, 3 do
            if not s then
                goto CONTINUE
            end
            X = s
            ::CONTINUE::
        end
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
end

do
    -- 两侧变量比较（`a == b`）守护 + goto：收窄结果不能掺进别的类型
    local _ <close> = TEST_INDEX [[
    ---@class P
    ---@field t? string

    ---@param a P
    ---@param b P
    local function f(a, b)
        if a == b then
            goto SKIP
        end
        X = a
        ::SKIP::
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'P')
end
