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

TEST_DIAGNOSTIC [[
---@overload fun(f: integer|async fun(...):..., index: integer): string, any
---@param thread thread
---@param f integer|async fun(...):...
---@param index integer
---@return string name
---@return any value
local function getlocal(thread, f, index) end

local n, l = getlocal(1, 2)
]] { '-redundant-parameter' }