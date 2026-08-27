print('[feature.diagnostic.redundant-return-value] 测试中...')

TEST_DIAGNOSTIC [[
---@return number
local function f()
    return 1, <?true?>
end
f()
]] { 'redundant-return-value' }

TEST_DIAGNOSTIC [[
---@return number, number?
local function f()
    return 1, 1, <?1?>
end
f()
]] { 'redundant-return-value' }

TEST_DIAGNOSTIC [[
---@return number, number?
local function f()
    return 1, 1
end
f()
]] { '-redundant-return-value' }

TEST_DIAGNOSTIC [[
---@return number
local function f()
    return 1
end
f()
]] { '-redundant-return-value' }

print('[feature.diagnostic.redundant-return-value] 测试完毕')