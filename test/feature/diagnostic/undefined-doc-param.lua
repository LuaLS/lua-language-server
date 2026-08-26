TEST_DIAGNOSTIC [[
---@param <?y?> number
local function f(x)
end
f(1)
]] { 'undefined-doc-param' }

TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end
f(1)
]] {}

TEST_DIAGNOSTIC [[
---@param <?x?> number
local function f()
end
f()
]] { 'undefined-doc-param' }

TEST_DIAGNOSTIC [[
---@param self table
---@param x number
function t.m(self, x)
end
t.m({}, 1)
]] {}
