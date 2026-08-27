print('[feature.diagnostic.global-in-nil-env] 测试中...')

TEST_DIAGNOSTIC [[
local _ENV = nil
<?print?>(1)
]] { 'global-in-nil-env' }

TEST_DIAGNOSTIC [[
local x = 1
print(x)
]] { '-global-in-nil-env' }

print('[feature.diagnostic.global-in-nil-env] 测试完毕')