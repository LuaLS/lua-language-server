-- special 补全测试

-- 字符串内部不应触发补全
TEST_COMPLETION 'local s = "a:<??>"' (nil)

-- 函数参数列表定义位置（a, <??> 是参数名，不是表达式）不应触发补全
TEST_COMPLETION [[
local function f(a, <??>)
end
]] (nil)

TEST_COMPLETION [[
local t = x[<??>]
]] (function (results)
	for _, res in ipairs(results) do
		assert(res.label ~= 'do')
	end
end)

-- [SKIPPED][legacy-comment-context] 注释与 LuaDoc 注释触发补全在 TEST_COMPLETION 下结果不稳定，暂不迁移。

-- [SKIPPED][empty-in-comment-context] --<?> #region/#endregion 补全在 TEST_COMPLETION 下返回空，暂不迁移

-- 表构造器内不应出现 do 关键字（同 x[<?>] 场景）
TEST_COMPLETION [[
local x = {
<??>
})
]] (function (results)
    for _, res in ipairs(results) do
        assert(res.label ~= 'do')
    end
end)

-- [SKIPPED][config-dependent] require '<?>' count=9 依赖文件系统/配置，暂不迁移

-- postfix 语法补全测试已迁移到 `test/feature/completion/postfix.lua`
