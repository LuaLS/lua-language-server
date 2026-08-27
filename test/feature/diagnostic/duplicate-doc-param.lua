print('[feature.diagnostic.duplicate-doc-param] 测试中...')

TEST_DIAGNOSTIC [[
---@param x number
---@param <?x?> string
local function _(x)
end
]] { 'duplicate-doc-param' }

TEST_DIAGNOSTIC [[
---@param x number
---@param y string
local function _(x, y)
end
]] {}

TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end

---@param x number
local function g(x)
end

f(1)
g(1)
]] {}

TEST_DIAGNOSTIC [[
---@param x number
---@return number
---@param <?x?> string
local function _(x)
end
]] { 'duplicate-doc-param' }

print('[feature.diagnostic.duplicate-doc-param] 测试完毕')