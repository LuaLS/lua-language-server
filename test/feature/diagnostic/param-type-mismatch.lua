TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end
f(<?'str'?>)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end
f(1)
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
local t = {}
---@param x number
function t:m(self, x)
end
t:m(t, <?'str'?>)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
local function f(...)
end
f(1, 'str', {})
]] { '-param-type-mismatch' }