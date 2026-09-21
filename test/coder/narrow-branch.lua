local rt = test.scope.rt

do
    -- 被比较的调用反推出的形参类型（可选 `u?`）不该覆盖实参自己的注解类型
    local _ <close> = TEST_INDEX [[
    ---@param u string?
    ---@param key string
    ---@return any
    local function configGet(u, key) end

    ---@param u string
    local function f(u)
        local t = configGet(u, 'k')
        if t == 'v' then
            X = u
        end
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
end

do
    -- 已判空（guard 返回）的变量，比较其它变量时不该被反推成含 nil 的形参类型
    local _ <close> = TEST_INDEX [[
    ---@param u string?
    ---@param key string
    ---@return any
    local function configGet(u, key) end

    ---@param a? string
    ---@param b? string
    ---@return any
    local function calc(a, b) end

    local function f(args, other)
        if not args or not other then
            return
        end
        local t = calc(other, args)
        if t == 'x' then
            X = args
        end
    end
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'string')
end
