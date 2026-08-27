print('[feature.diagnostic.unknown-diag-code] 测试中...')

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

print('[feature.diagnostic.unknown-diag-code] 测试完毕')