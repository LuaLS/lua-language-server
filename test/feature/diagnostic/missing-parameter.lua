TEST_DIAGNOSTIC [[
local function f(x, y)
end
<?f(1)?>
]] { 'missing-parameter' }

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
local t = {}
function t:m(x, y)
end
<?t:m(1)?>
]] { 'missing-parameter' }