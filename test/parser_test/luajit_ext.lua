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
TestLuaJITExt 'local a = 3; a ~= 2' -- 语句上下文 ~= 是异或复合赋值
TestLuaJITExt 'local t = {}; t.x += 1'
TestLuaJITExt 'local t = {}; t[1] += 1'
TestLuaJITExtDisabled 'local a = 3; a ~>>= 1'
TestLuaJITExtDisabled 'local a = 3; a ~= 2'

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

-- 三元 ?:
TestLuaJITExt 'local a = b ? c : d'
TestLuaJITExt 'local a = (b ? c : d) + 1'
TestLuaJITExt 'local a = b + c ? d : e'
TestLuaJITExt 'local a = b ? c : d + e'
TestLuaJITExt 'local a = b ? c : d ? e : f'
TestLuaJITExt 'local a = b ? (obj:method()) : c'
TestLuaJITExt 'local a = b ? c : d():e()'
TestLuaJITExt 'local a = b ? c?.field : d'
TestLuaJITExtDisabled 'local a = b ? c : d'
TestOtherVersion 'local a = b ? c : d'

-- continue
TestLuaJITExt 'while true do continue end'
TestLuaJITExt 'for i = 1, 10 do continue end'
TestLuaJITExt 'repeat continue until false'
TestLuaJITExtDisabled 'while true do continue end'

print('LuaJIT 扩展基本语法用例通过')

-- ==================== 单独启用（Lua.runtime.nonstandardSymbol） ====================
-- 通过 nonstandardSymbol 单独启用某项时，即使 version 非 LuaJIT 也可用（不依赖主开关）

-- 非 LuaJIT 版本下仅开启指定 symbol：应无错误
---@param symbol string
---@param script string
local function TestIndividual(symbol, script)
    local state = parser.compile(script, 'Lua', 'Lua 5.4', { nonstandardSymbol = { [symbol] = true } })
    if #state.errs > 0 then
        error(('单独启用 %s 仍报错：%s [%s]'):format(symbol, script, state.errs[1].type))
    end
end

-- 非 LuaJIT 版本下未启用该 symbol（也未开主开关）：应报错
---@param symbol string
---@param script string
local function TestIndividualDisabled(symbol, script)
    local state = parser.compile(script, 'Lua', 'Lua 5.4', { nonstandardSymbol = {} })
    if #state.errs == 0 then
        error(('未启用 %s 应报错：%s'):format(symbol, script))
    end
end

-- ?. 安全导航（字段/方法）
TestIndividual('?.', 'local a = obj?.field')
TestIndividual('?.', 'local a = obj?.:method()')
TestIndividualDisabled('?.', 'local a = obj?.field')
-- ?.( 安全导航调用 / ?.[ 安全导航索引
TestIndividual('?.(', 'local a = f?.()')
TestIndividual('?.(', 'local a = f?.{1, 2}')
TestIndividual('?.(', 'local a = f?."str"')
TestIndividual('?.(', 'local a = obj:method?.()')
TestIndividual('?.[', 'local a = obj?.[key]')
TestIndividual('?.[', 'local a = obj?.[key].field')
TestIndividualDisabled('?.(', 'local a = f?.()')
TestIndividualDisabled('?.[', 'local a = obj?.[key]')
-- ?( / ?[ 无点号可选链（非 LuaJIT 语法，仅 nonstandardSymbol 单独启用）
TestIndividual('?(', 'local a = f?()')
TestIndividual('?(', 'local a = f?(x, y)')
TestIndividual('?(', 'local a = f?().field')
TestIndividual('?[', 'local a = t?[1]')
TestIndividual('?[', 'local a = t?[key]')
TestIndividual('?[', 'local a = t?[1].field')
TestIndividualDisabled('?(', 'local a = f?()')
TestIndividualDisabled('?[', 'local a = t?[1]')
-- 无点号可选链与 LuaJIT 无关：主开关 enableLuaJITExtensions 不启用它
---@param script string
local function TestMasterSwitchDisabled(script)
    local state = parser.compile(script, 'Lua', 'LuaJIT', { enableLuaJITExtensions = true })
    if #state.errs == 0 then
        error(('主开关不应启用无点号可选链：%s'):format(script))
    end
end
TestMasterSwitchDisabled 'local a = f?()'
TestMasterSwitchDisabled 'local a = t?[1]'
-- ?? 空值合并
TestIndividual('??', 'local a = b ?? c')
TestIndividualDisabled('??', 'local a = b ?? c')
-- ?: 三元
TestIndividual('?:', 'local a = b ? c : d')
TestIndividualDisabled('?:', 'local a = b ? c : d')
-- ~>> 算术右移
TestIndividual('~>>', 'local a = 3 ~>> 1')
TestIndividualDisabled('~>>', 'local a = 3 ~>> 1')
-- ~>>= 复合赋值
TestIndividual('~>>=', 'local a = 3; a ~>>= 1')
TestIndividualDisabled('~>>=', 'local a = 3; a ~>>= 1')
-- ..= 复合赋值
TestIndividual('..=', 'local a = "x"; a ..= "y"')
TestIndividualDisabled('..=', 'local a = "x"; a ..= "y"')
-- ~= 异或复合赋值（仅语句上下文）；表达式上下文的"不等于"不受影响
TestIndividual('~=', 'local a = 3; a ~= 2')
TestIndividual('~=', 'local a = 3; a ~= 2; local b = (a ~= 1)')
TestIndividualDisabled('~=', 'local a = 3; a ~= 2')
-- const 声明
TestIndividual('const', 'const x = 1')
TestIndividual('const', 'const x, y = 1, 2')
TestIndividualDisabled('const', 'const x = 1')
-- -> 短函数
TestIndividual('->', 'local f = x -> x + 1')
TestIndividual('->', 'local f = |x| -> x + 1')
TestIndividual('->', 'local f = || -> 11')
TestIndividual('->', 'local f = x -> do return x end')
TestIndividualDisabled('->', 'local f = x -> x + 1')
-- number_underscore 数字下划线
TestIndividual('number_underscore', 'local a = 1_234')
TestIndividual('number_underscore', 'local a = 0x1_2')
TestIndividual('number_underscore', 'local a = 1_2.3_4')
TestIndividual('number_underscore', 'local a = 1e1_0')
TestIndividualDisabled('number_underscore', 'local a = 1_234')

print('LuaJIT 扩展单独启用用例通过')

-- ==================== LuaJIT 官方测试文件 ====================

local okFiles = {
    'expr_bit.lua',
    'expr_bit_bitop.lua',
    'expr_coal.lua',
    'expr_cond.lua',
    'expr_customary.lua',
    'expr_nav.lua',
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

print('LuaJIT 扩展语法测试完成')
