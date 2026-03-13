-- special 补全测试

-- 字符串内部不应触发补全
TEST_COMPLETION 'local s = "a:<??>"' (nil)

-- 函数参数列表定义位置（a, <??> 是参数名，不是表达式）不应触发补全
TEST_COMPLETION [[
local function f(a, <??>)
end
]] (nil)
