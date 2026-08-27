print('[feature.diagnostic.unknown-cast-variable] 测试中...')

TEST_DIAGNOSTIC [[
---@cast <?x?> integer
]] { 'unknown-cast-variable' }

TEST_DIAGNOSTIC [[
local x, y
---@cast y number
]] { '-unknown-cast-variable' }

TEST_DIAGNOSTIC [[
global x
---@cast x integer
]] { '-unknown-cast-variable' }

print('[feature.diagnostic.unknown-cast-variable] 测试完毕')