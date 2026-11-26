TEST_DIAGNOSTIC [[
---@return number
local function f()
    return <?'str'?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number
local function f()
    return 1
end
f()
]] { '-return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number
---@return string
local function f()
    return 1, <?{}?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number ~ nil
local function f()
    return 1
end
f()
]] { '-return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@return number ~ nil
local function f()
    return <?'str'?>
end
f()
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@return A | [A] | string | number | boolean | nil
local function g(x)
    return nil
end

---@return A | [A] | string | number | boolean | nil
local function f(source)
    local objs = {}
    objs[1] = g(source)
    return <?objs?>
end
f(1)
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@return A | [A] | string | number | boolean | nil
local function g(x)
    return nil
end

---@return A | [A] | string | number | boolean | nil
local function f(source)
    local obj = {
        name = g(source),
    }
    return obj
end
f(1)
]] { 'return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@generic T: table
---@param t T
---@return fun<V>(table: V[], i?: integer):integer, V ~ nil
---@return T
---@return integer i
function ipairs(t) end

---@class D
---@field severity string

local function report(diags)
    for _, d in ipairs(diags) do
        print(d.severity)
    end
end

report({})
]] { '-need-check-nil' }

TEST_DIAGNOSTIC [[
---@class A
---@field name string

---@return A
local function g(x)
    return {
        name = 'x',
    }
end

---@return A[]
local function f(source)
    local objs = {}
    objs[1] = g(source)
    return objs
end
f(1)
]] { '-return-type-mismatch' }

TEST_DIAGNOSTIC [[
---@generic T
---@param v T
---@return T & { x: number }
local function f(v)
    return v
end

---@type string
local s
local r = f(s)
local bad = r.x + 1
print(bad)
]] { '-return-type-mismatch' }

-- 返回值是变量时，诊断消息需要能 view 变量节点（此前会抛 "Cannot view node of kind variable"）
TEST_DIAGNOSTIC [[
---@return number
local function f()
    ---@type string
    local s
    return <?s?>
end
f()
]] { 'return-type-mismatch' }

-- `X | any` 等价于 any：返回值类型里带 any 成员时不应报
TEST_DIAGNOSTIC [[
---@class AnyMemberNode
---@field n AnyMemberNode | any

---@param o AnyMemberNode
---@return string
local function f(o)
    return o.n
end
f({})
]] { '-return-type-mismatch' }

-- 对照：没有 any 成员时必须报
TEST_DIAGNOSTIC [[
---@class NoAnyMemberNode
---@field n NoAnyMemberNode

---@param o NoAnyMemberNode
---@return string
local function f(o)
    return o.n
end
f({})
]] { 'return-type-mismatch' }
