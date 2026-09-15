TEST_DIAGNOSTIC [[
---@diagnostic disable: <?unknown-rule-xyz?>
local x = 1
print(x)
]] { 'unknown-diag-code' }

TEST_DIAGNOSTIC [[
---@diagnostic disable: unused-local
local x = 1
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable: break-outside
break
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable: typo-rule
local _ =
]] { 'unknown-diag-code', 'miss-exp' }

-- 上游 master 已有、本仓库尚未实现的诊断码：不应报未知码
TEST_DIAGNOSTIC [[
---@diagnostic disable-next-line: missing-fields
local x = 1
print(x)
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable: duplicate-set-field
local x = 1
print(x)
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable: cast-local-type
local x = 1
print(x)
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable: missing-local-export-doc
local x = 1
print(x)
]] {}