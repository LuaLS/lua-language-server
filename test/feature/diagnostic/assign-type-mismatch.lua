test.scope.config:set(test.rootUri, 'Lua.runtime.version', 'Lua 5.5')

TEST_DIAGNOSTIC [[
---@type number
local <?x?> = 'str'
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type number
local x = 1
]] { '-assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type number?
local x = nil
]] { '-assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type string
X = 1
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type integer
local <?x?> = 1.5
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type number
local x
<?x?> = 'str'
]] { 'assign-type-mismatch' }

-- 实际存在的字段仍要比较类型
TEST_DIAGNOSTIC [[
---@type { a: integer }
local <?t?> = 1
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type { a: integer }[]
local vars = {
    { a = 'str' },
}
]] { 'assign-type-mismatch' }

-- Lua 5.5 命名不定长 `...args`：元素类型跟随 `---@param ... T`
TEST_DIAGNOSTIC [[
---@param ... string
local function f(...args)
    ---@type integer
    local <?s?> = args[1]
end
]] { 'assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param ... string
local function f(...args)
    ---@type string
    local ok = args[1]
end
]] { '-assign-type-mismatch' }

-- `n` 固定为 integer
TEST_DIAGNOSTIC [[
---@param ... string
local function f(...args)
    ---@type string
    local <?n?> = args.n
end
]] { 'assign-type-mismatch' }

-- `---@vararg` 同理
TEST_DIAGNOSTIC [[
---@vararg integer
local function f(...args)
    ---@type string
    local <?s?> = args[1]
end
]] { 'assign-type-mismatch' }

-- 联合体里含 `any` 时按逆变允许：`A | any` 等价于 any，可赋给任何类型
TEST_DIAGNOSTIC [[
---@class UnionAny
---@field k integer

---@type UnionAny | any
local v

---@type string
local s = v
]] { '-assign-type-mismatch' }

-- 表字面量类型里的可选字段（`b?`）可以缺失
TEST_DIAGNOSTIC [[
---@param v string
local function strToBool(v)
    return v == 'true'
end

---@type { name: string, key: string, converter?: fun(value: string): any }[]
local vars = {
    { name = 'A', key = 'B' },
    { name = 'C', key = 'D', converter = strToBool },
}
]] { '-assign-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type { a: integer, b?: integer }[]
local vars = {
    { a = 1 },
    { a = 2, b = 3 },
}
]] { '-assign-type-mismatch' }

-- 非可选字段缺失仍要报
TEST_DIAGNOSTIC [[
---@type { a: integer, b: integer }[]
local vars = {
    { a = 1 },
    { a = 2, b = 3 },
}
]] { 'assign-type-mismatch' }

-- 收窄后的局部变量直接读取（嵌套函数/闭包内读取见 项目实践.md 已知未决）
TEST_DIAGNOSTIC [[
---@param chunk string | function
local function load(chunk) end

---@return string?
local function loadFile(path) end

local buf = loadFile('x')
if not buf then
    return
end
load(buf, 'name', 't')
]] { '-param-type-mismatch' }

-- 闭包内读取外层已收窄的变量
TEST_DIAGNOSTIC [[
---@param chunk string | function
local function load(chunk) end

---@return string?
local function loadFile(path) end

local buf = loadFile('x')
if not buf then
    return
end
local suc, res = pcall(function ()
    return load(buf, 'name', 't')
end)
print(suc, res)
]] { '-param-type-mismatch' }

-- 两层闭包：快照需要逐层传下去
TEST_DIAGNOSTIC [[
---@param chunk string | function
local function load(chunk) end

---@return string?
local function loadFile(path) end

local buf = loadFile('x')
if not buf then
    return
end
local outer = function ()
    return function ()
        return load(buf, 'name', 't')
    end
end
print(outer)
]] { '-param-type-mismatch' }

-- `---@class` 多次声明/多次绑定：由绑定值推断出来的字段只算「读取可见性」，不是赋值要求
-- （`---@class X` + 多次 `local x = ...` 的装配写法；目标工程 ffi/init.lua 同族）
TEST_DIAGNOSTIC [[
---@class Dup
local d1 = { a = 1 }

---@class Dup
local d2 = { b = 2 }

print(d1.a, d2.b)
]] { '-assign-type-mismatch' }

-- 类标注目标放宽「推断字段」不代表什么都能赋：非表值仍要报
TEST_DIAGNOSTIC [[
---@class Dup2
local d = 1

print(d)
]] { 'assign-type-mismatch' }
