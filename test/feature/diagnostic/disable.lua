print('[feature.diagnostic.disable] 测试中...')

TEST_DIAGNOSTIC [[
---@diagnostic disable-next-line: break-outside
break
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable-next-line: miss-exp
<?break?>
]] { 'break-outside' }

TEST_DIAGNOSTIC [[
---@diagnostic disable: break-outside
break
break
]] {}

TEST_DIAGNOSTIC [[
---@diagnostic disable
<?break?>
]] { 'break-outside' }

TEST_DIAGNOSTIC [[
---@diagnostic disable: break-outside
break
---@diagnostic enable: break-outside
<?break?>
]] { 'break-outside' }

TEST_DIAGNOSTIC [[
break ---@diagnostic disable-line: break-outside
]] {}

print('[feature.diagnostic.disable] 测试完毕')