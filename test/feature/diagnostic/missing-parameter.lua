TEST_DIAGNOSTIC [[
local function f(x, y)
end
f(1)
]] { '-missing-parameter' }

TEST_DIAGNOSTIC [[
local function f(x)
end
f(1)
]] { '-missing-parameter' }

TEST_DIAGNOSTIC [[
---@param x number
---@param y? number
local function f(x, y)
end
f(1)
]] { '-missing-parameter' }

TEST_DIAGNOSTIC [[
---@param a any
---@param b boolean
---@param c any
local function f(a, b, c)
end
<?f(1)?>
]] { 'missing-parameter' }

TEST_DIAGNOSTIC [[
---@param a any
---@param b boolean
---@param c any
local function f(a, b, c)
end
f(1, true)
]] { '-missing-parameter' }

TEST_DIAGNOSTIC [[
local t = {}
function t:m(x, y)
end
t:m(1)
]] { '-missing-parameter' }

TEST_DIAGNOSTIC [[
local lines = {}
---@type any
local line
table.insert(lines, line)
]] { '-missing-parameter' }