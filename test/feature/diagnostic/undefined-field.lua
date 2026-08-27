print('[feature.diagnostic.undefined-field] 测试中...')

TEST_DIAGNOSTIC [[
local t = { foo = 1 }
print(t.foo)
]] {}

TEST_DIAGNOSTIC [[
local t = { foo = 1 }
print(t.<?bar?>)
]] { 'undefined-field' }

TEST_DIAGNOSTIC [[
local t = {}
t.bar = 1
print(t.bar)
]] {}

TEST_DIAGNOSTIC [[
---@param t table
local function f(t)
    print(t.bar)
end
f({})
]] {}

TEST_DIAGNOSTIC [[
local t = nil
print(t.bar)
]] { '-undefined-field', 'need-check-nil' }

TEST_DIAGNOSTIC [[
---@class C
---@field foo number
local C = {}

---@param c C
local function f(c)
    print(c.foo)
end
f(C)
]] {}

TEST_DIAGNOSTIC [[
---@class C
---@field foo number
local C = {}

---@param c C
local function f(c)
    print(c.<?bar?>)
end
f(C)
]] { 'undefined-field' }

TEST_DIAGNOSTIC [[
local t = {}
print(t:<?m?>())
]] { 'undefined-field' }

TEST_DIAGNOSTIC [[
local t = {}
function t:m()
end
print(t:m())
]] {}

print('[feature.diagnostic.undefined-field] 测试完毕')