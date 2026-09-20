local rt = test.scope.rt

do
    -- 单值右值在多余位置上是 nil（不是 never）：`local a, b = 1`
    local _ <close> = TEST_INDEX [[
    local a, b = 1
    X = a
    Y = b
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), '1')
    lt.assertEquals(rt:globalGet('Y'):view(), 'nil')
end

do
    -- 多个右值时按位置对应；右值少于变量数时多余的是 nil
    local _ <close> = TEST_INDEX [[
    local a, b, c = 1, 'x'
    X = a
    Y = b
    Z = c
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), '1')
    lt.assertEquals(rt:globalGet('Y'):view(), "'x'")
    lt.assertEquals(rt:globalGet('Z'):view(), 'nil')
end

do
    -- 未知函数（any）：返回值个数未知，任意位置都应是 any（不能出现 never）
    local _ <close> = TEST_INDEX [[
    ---@type any
    local f
    local a, b, c = f()
    X = a
    Y = b
    Z = c
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'any')
    lt.assertEquals(rt:globalGet('Y'):view(), 'any')
    lt.assertEquals(rt:globalGet('Z'):view(), 'any')
end

do
    -- 表上的未知字段当函数调用（`---@return table` 的模块），同样是任意位置 any
    local _ <close> = TEST_INDEX [[
    ---@return table
    local function injectBuildScript() end

    local dirty_export = injectBuildScript()
    local ok, outPaths, err = dirty_export.serializeAndExport({}, 'x')
    X = ok
    Y = outPaths
    Z = err
    ]]

    lt.assertEquals(rt:globalGet('X'):view(), 'any')
    lt.assertEquals(rt:globalGet('Y'):view(), 'any')
    lt.assertEquals(rt:globalGet('Z'):view(), 'any')
end
