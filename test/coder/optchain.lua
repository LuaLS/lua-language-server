-- 可选链（?. ?: ?[ ?(）的类型语义测试
-- 需要启用 Lua.runtime.nonstandardSymbol 配置
local OPT = { '?.', '?:', '?[', '?(' }

-- 设置配置（测试结束后清理）
test.scope.config:set(test.rootUri, 'Lua.runtime.nonstandardSymbol', OPT)

do
    TEST_INDEX [[
        ---@class Obj
        ---@field field string
        ---@field method fun(self): integer
        ---@type Obj
        local obj
        ---@type fun(): string
        local f

        R1 = obj?.field
        R2 = obj?:method()
        R3 = obj?.x?.y
        R4 = obj.field
        R5 = f?()
    ]]
    local rt = test.scope.rt
    lt.assertEquals(rt:globalGet('R1').value:view(), 'string | nil')
    lt.assertEquals(rt:globalGet('R2').value:view(), 'integer | nil')
    lt.assertEquals(rt:globalGet('R3').value:view(), 'any')
    lt.assertEquals(rt:globalGet('R4').value:view(), 'string')
    lt.assertEquals(rt:globalGet('R5').value:view(), 'string | nil')
end

-- 安全索引
do
    TEST_INDEX [[
        ---@class Arr
        ---@field [number] string
        ---@type Arr
        local t
        S1 = t?[1]
        S2 = t[1]
    ]]
    local rt = test.scope.rt
    lt.assertEquals(rt:globalGet('S1').value:view(), 'string | nil')
    lt.assertEquals(rt:globalGet('S2').value:view(), 'string')
end

-- 清理配置，避免影响其他测试
test.scope.config:set(test.rootUri, 'Lua.runtime.nonstandardSymbol', nil)
