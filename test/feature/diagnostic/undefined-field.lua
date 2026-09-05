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

-- setmetatable 的 __index 为函数时，字段访问应走 __index 返回值，不应误报
TEST_DIAGNOSTIC [[
--!include setmetatable
local lang = setmetatable({ id = 'en-us' }, {
    __index = function(self, name)
        return function(key) end
    end,
})
lang.script('CLI_CHECK_PROGRESS')
]] { '-undefined-field' }

-- __index 函数的返回值类型应被正确推断（防止退化为 unknown 的假绿）
TEST_DIAGNOSTIC [[
--!include setmetatable
local t = setmetatable({}, {
    __index = function(self, key)
        return 42
    end,
})
---@type string
local s = t.anything
]] { 'assign-type-mismatch' }