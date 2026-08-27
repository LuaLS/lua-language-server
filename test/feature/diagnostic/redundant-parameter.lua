print('[feature.diagnostic.redundant-parameter] 测试中...')

TEST_DIAGNOSTIC [[
local function f(x)
end
f(1, <?2?>)
]] { 'redundant-parameter' }

TEST_DIAGNOSTIC [[
local function f(x)
end
f(1)
]] { '-redundant-parameter' }

TEST_DIAGNOSTIC [[
local function f(...)
end
f(1, 2, 3)
]] { '-redundant-parameter' }

TEST_DIAGNOSTIC [[
local t = {}
function t:m(x)
end
t:m(1, <?2?>)
]] { 'redundant-parameter' }

TEST_DIAGNOSTIC [[
---@overload fun(x: number, y: number)
local function f(x)
end
f(1, 2)
]] { '-redundant-parameter' }

print('[feature.diagnostic.redundant-parameter] 测试完毕')