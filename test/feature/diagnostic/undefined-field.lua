TEST_DIAGNOSTIC [[
local t = { foo = 1 }
print(t.foo)
]] {}

-- 未注解的表字面量是开放结构：任意具名字段都可能存在（master 亦不报）
TEST_DIAGNOSTIC [[
local t = { foo = 1 }
print(t.bar)
]] { '-undefined-field' }

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

-- 未注解表字面量上的方法调用同样不报（master 也不报）
TEST_DIAGNOSTIC [[
local t = {}
print(t:m())
]] { '-undefined-field' }

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

-- 变量已有静态值（非表字面量赋值）时，后续字段赋值不应丢失
TEST_DIAGNOSTIC [[
local function f() return {} end
local t = f()
t.foo = 1
print(t.foo)
]] { '-undefined-field' }

-- 守卫：收窄为 nil 后字段不应复活（need-check-nil 语义不被削弱）
TEST_DIAGNOSTIC [[
local function f() return {} end
local t = f()
t.foo = 1
t = nil
print(t.foo)
]] { 'need-check-nil' }

TEST_DIAGNOSTIC [[
local function f(k)
    local t = {}
    t[k] = 1
    print(t.foo)
end
]] { '-undefined-field' }

TEST_DIAGNOSTIC [[
local function f(k)
    local t = {}
    t[k] = 1
    local u = t
    print(u.foo)
end
]] { '-undefined-field' }

TEST_DIAGNOSTIC [[
local function f(k, cond)
    local t = {}
    t[k] = { C = 1 }
    local u = cond and t or {}
    print(u.C)
end
]] { '-undefined-field' }

TEST_DIAGNOSTIC [[
local A = {}
local function f(k)
    A[k] = { C = 1 }
end
print(A.C)
]] { '-undefined-field' }

-- `table & { n: integer }`：n 参与字段检查
TEST_DIAGNOSTIC [[
---@type fun(...): table & { n: integer }
local pack

local t = pack(1, 2)
print(t.n)
]] { '-undefined-field' }

-- `T & { n: integer }`：n 存在，其他字段仍是未定义
TEST_DIAGNOSTIC [[
---@generic T
---@param ... T
---@return T & { n: integer }
local function pack(...) end

local t = pack(1, 2)
print(t.n)
print(t.zzz)
]] { 'undefined-field' }

-- open-table flag must survive merging literal + written fields
TEST_DIAGNOSTIC [[
local t = {}
t.foo = 1
print(t.bar)
]] { '-undefined-field' }

-- 开放表上的字面量键读取：读取本身创建的子变量不是字段写记录，
-- 读到的值不可判定，不应拿它去报未定义字段
TEST_DIAGNOSTIC [[
local t = {}
local w = t[1]
print(w:match('x'))
]] { '-undefined-field' }

-- 开放表上的写入仍是字段写记录（读值不该退化成 any）
TEST_DIAGNOSTIC [[
local t = {}
t[1] = 'a'
local w = t[1]
---@type integer
local n = w
]] { 'assign-type-mismatch' }

-- 嵌套写入的中间层同样保留（其子变量自身无赋值，但后代有）
TEST_DIAGNOSTIC [[
local t = {}
t.a.b = 1
---@type string
local s = t.a.b
]] { 'assign-type-mismatch' }
