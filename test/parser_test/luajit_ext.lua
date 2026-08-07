-- LuaJIT 扩展语法测试
-- 需要启用 Lua.runtime.enableLuaJITExtensions 且 version = LuaJIT
local parser = require 'parser'

local LuaJITExtOptions = {
    enableLuaJITExtensions = true,
}

-- 启用扩展时：编译应无错误
---@param script string
local function TestLuaJITExt(script)
    local state = parser.compile(script, 'Lua', 'LuaJIT', LuaJITExtOptions)
    if #state.errs > 0 then
        error(('语法错误：%s [%s]'):format(script, state.errs[1].type))
    end
end

-- 未启用扩展时：应报错
---@param script string
local function TestLuaJITExtDisabled(script)
    local state = parser.compile(script, 'Lua', 'LuaJIT')
    if #state.errs == 0 then
        error(('应报错但未报错：%s'):format(script))
    end
end

-- 其他版本（非 LuaJIT）启用扩展：应报错
---@param script string
local function TestOtherVersion(script)
    local state = parser.compile(script, 'Lua', 'Lua 5.4', LuaJITExtOptions)
    if #state.errs == 0 then
        error(('非 LuaJIT 版本应报错：%s'):format(script))
    end
end

-- 加载 LuaJIT 官方测试文件（内容包裹为 return [[...]]）
---@param name string
---@return string
local function loadLuaJITFile(name)
    local path = 'test/parser_test/LuaJIT/' .. name
    local f = assert(io.open(path), '无法打开: ' .. path)
    local content = f:read '*a'
    f:close()
    local chunk = assert(load(content), 'load 失败: ' .. path)
    return chunk()
end

-- ==================== 基本语法用例 ====================

-- 位运算 ~>>
TestLuaJITExt 'local a = 3 ~>> 1'
TestLuaJITExt 'local a = 3 ~>> 1 + 2'

-- 复合赋值
TestLuaJITExt 'local a = 3; a ~>>= 1'
TestLuaJITExt 'local a = "x"; a ..= "y"'
TestLuaJITExt 'local t = {}; t.x += 1'
TestLuaJITExt 'local t = {}; t[1] += 1'
TestLuaJITExtDisabled 'local a = 3; a ~>>= 1'

-- 数字下划线
TestLuaJITExt 'local a = 1_234'
TestLuaJITExt 'local a = 1_2_3__4__'
TestLuaJITExt 'local a = 0x1_2'
TestLuaJITExt 'local a = 0b1_0'
TestLuaJITExt 'local a = 0__x__1__2__'
TestLuaJITExt 'local a = 1_2.3_4'
TestLuaJITExt 'local a = 1e1_0'
TestLuaJITExtDisabled 'local a = 1_234'

-- 空值合并 ??
TestLuaJITExt 'local a = b ?? c'
TestLuaJITExt 'local a = (b ?? c) + 1'
TestLuaJITExt 'local a = b ?? c ?? d'
TestLuaJITExtDisabled 'local a = b ?? c'

-- 自定义运算符
TestLuaJITExt 'local a = x && y'
TestLuaJITExt 'local a = x || y'
TestLuaJITExt 'local a = x != y'
TestLuaJITExt 'local a = !x'
TestLuaJITExtDisabled 'local a = x && y'

-- 安全导航 ?.
TestLuaJITExt 'local a = obj?.field'
TestLuaJITExt 'local a = obj?.field?.sub'
TestLuaJITExt 'local a = obj?.[key]'
TestLuaJITExt 'local a = f?.()'
TestLuaJITExt 'local a = f?.{1, 2}'
TestLuaJITExt 'local a = f?."str"'
TestLuaJITExt 'local a = obj?.:method()'
TestLuaJITExt 'local a = obj:method?.()'
TestLuaJITExt 'local a = obj?.:method?.()'
TestLuaJITExt 'obj?.field = 1'
TestLuaJITExt 'obj?.[key] = 1'
TestLuaJITExt 'obj?.field += 1'
TestLuaJITExtDisabled 'local a = obj?.field'
TestOtherVersion 'local a = obj?.field'

-- const 声明
TestLuaJITExt 'const x = 1'
TestLuaJITExt 'const x, y = 1, 2'
TestLuaJITExt 'const foo'
TestLuaJITExt 'local const = 1'
TestLuaJITExtDisabled 'const x = 1'

-- 短函数
TestLuaJITExt 'local f = x -> x + 1'
TestLuaJITExt 'local f = |x| -> x + 1'
TestLuaJITExt 'local f = || -> 11'
TestLuaJITExt 'local f = |a, b| -> a + b'
TestLuaJITExt 'local f = |...| -> ...'
TestLuaJITExt 'local f = || -> do return 11 end'
TestLuaJITExt 'local f = x -> do return x end'
TestLuaJITExt 'local f = x -> y -> x + y'
TestLuaJITExtDisabled 'local f = x -> x + 1'

-- continue
TestLuaJITExt 'while true do continue end'
TestLuaJITExt 'for i = 1, 10 do continue end'
TestLuaJITExt 'repeat continue until false'
TestLuaJITExtDisabled 'while true do continue end'

print('LuaJIT 扩展基本语法用例通过')

-- ==================== LuaJIT 官方测试文件 ====================

-- 三元 ?: 已搁置，以下文件实际代码混用了三元运算符，编译预期报错：
-- expr_cond.lua（纯三元）、expr_coal.lua（?? 与三元混合）、expr_nav.lua（?. 与三元混合）
local okFiles = {
    'expr_bit.lua',
    'expr_bit_bitop.lua',
    'expr_customary.lua',
    'expr_shortfunc.lua',
    'ffi_expr_bit.lua',
    'ffi_expr_bit_bit64.lua',
    'ffi_expr_bit_bitop.lua',
    'number_underscore.lua',
    'stmt_compound.lua',
    'stmt_const.lua',
    'stmt_continue.lua',
}
for _, name in ipairs(okFiles) do
    local code = loadLuaJITFile(name)
    local state = parser.compile(code, 'Lua', 'LuaJIT', LuaJITExtOptions)
    if #state.errs > 0 then
        error(('LuaJIT 测试文件编译出错：%s [%s]'):format(name, state.errs[1].type))
    end
    print(('LuaJIT 官方测试文件编译通过：%s'):format(name))
end

-- 混用三元 ?: 的文件：预期报错（三元已搁置）
local ternaryFiles = {
    'expr_cond.lua',
    'expr_coal.lua',
    'expr_nav.lua',
}
for _, name in ipairs(ternaryFiles) do
    local code = loadLuaJITFile(name)
    local state = parser.compile(code, 'Lua', 'LuaJIT', LuaJITExtOptions)
    if #state.errs == 0 then
        error(('应因三元运算符报错：%s'):format(name))
    end
    print(('预期报错 OK（含三元 ?: 已搁置）：%s [%s]'):format(name, state.errs[1].type))
end

print('LuaJIT 扩展语法测试完成')
