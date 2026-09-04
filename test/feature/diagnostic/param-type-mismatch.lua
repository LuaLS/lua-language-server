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

TEST_DIAGNOSTIC [[
---@overload fun(v: 1): 1
---@overload fun(v: 2): 2
local function f(v)
end
---@type 1 | 2
local x
f(x)
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@overload fun(v: 1): 1
---@overload fun(v: 2): 2
local function f(v)
end
f(3)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@overload fun(v: 1): 1
---@overload fun(v: 2): 2
local function f(v)
end
---@type 1 | 3
local x
f(x)
]] { 'param-type-mismatch' }