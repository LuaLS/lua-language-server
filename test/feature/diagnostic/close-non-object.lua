print('[feature.diagnostic.close-non-object] 测试中...')

TEST_DIAGNOSTIC [[
local <?x <close>?>
]] { 'close-non-object' }

TEST_DIAGNOSTIC [[
local x <close> = 1
]] {}

print('[feature.diagnostic.close-non-object] 测试完毕')