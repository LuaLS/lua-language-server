TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end
f(<?'str'?>)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@generic T: table, V
---@param t T
---@return fun<V>(table: V[], i?: integer):integer, V
---@return T
function ipairs(t) end

---@class uri

---@class item
---@field uri? uri

---@param uri uri
---@return boolean
function check(uri) end

---@param items item[]
local function filter(items)
    for _, item in ipairs(items) do
        if check(<?item.uri?>) then
        end
    end
end

---@type item[]
local all
filter(all)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end
f(1)
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
local t = {}
---@param x number
function t:m(self, x)
end
t:m(t, <?'str'?>)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
local function f(...)
end
f(1, 'str', {})
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@overload fun(v: 1): 1
---@overload fun(v: 2): 2
local function f(v)
end
---@type 1 | 2
local x
f(x)
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@overload fun(v: 1): 1
---@overload fun(v: 2): 2
local function f(v)
end
f(3)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@overload fun(v: 1): 1
---@overload fun(v: 2): 2
local function f(v)
end
---@type 1 | 3
local x
f(x)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param s string
local function f(s) end
---@type string
local sp
f(sp == '' and '.' or sp)
]] { '-param-type-mismatch' }

-- 重载作为值传给单签名参数：重载应自动选择合适签名，而非 union 的"全部匹配"
TEST_DIAGNOSTIC [[
---@overload fun(n: integer): string
local function read(...) end
---@param reader fun(arg: integer): string
local function decode(reader) end
decode(read)
]] { '-param-type-mismatch' }

-- 基础签名不匹配、仅某个重载匹配：仍应通过（重载选择）
TEST_DIAGNOSTIC [[
---@overload fun(n: integer): string
local function read() end
---@param reader fun(arg: integer): string
local function decode(reader) end
decode(read)
]] { '-param-type-mismatch' }

-- 真正不确定的函数 union（非重载）仍按"全部成员匹配"：一个成员不匹配则失败
TEST_DIAGNOSTIC [[
---@type fun(): string | fun(n: number): string
local f
---@param reader fun(arg: integer): string
local function decode(reader) end
decode(f)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
--!include pairslib
local function decode(flag)
    if flag then
        return {}
    end
    return nil
end
local result = decode(FLAG)
for k, v in pairs(result) do
    for _, entry in ipairs(v) do
    end
end
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@type thread
local co
---@param co thread
local function close(co) end
local m = {}
m.needClose = {}
function m.stop()
    m.needClose[#m.needClose+1] = co
end
function m.step()
    for i = #m.needClose, 1, -1 do
        close(m.needClose[i])
        m.needClose[i] = nil
    end
end
m.step()
]] { '-param-type-mismatch' }

-- 临时探针：二元运算占位类型作为实参时是否被当作 any
TEST_DIAGNOSTIC [[
---@param s string
local function needString(s) end

---@type integer
local a
needString(a .. 'x')
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param n integer
local function needInt(n) end

---@type integer
local a
---@type integer
local b
needInt(a & b)
]] { '-param-type-mismatch' }

-- 动态键读取在中间码中共用一个槽位，不同键之间不得互相收窄
TEST_DIAGNOSTIC [[
---@param t table
local function need(t) end

---@param t table
---@param key string
local function f(t, key)
    if t[key] then
        return
    end
    local k = key
    need(t[k])
    need(t[key])
end
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param t table
local function need(t) end

---@param t table
local function f(t)
    if t.a then
        return
    end
    need(t.b)
end
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@param s string
local function needString(s) end

---@type string
local s
---@type any
local u
needString(s .. u)
]] { '-param-type-mismatch' }

-- 经动态键读取得到的变量，其字面量字段在分支内仍应收窄
TEST_DIAGNOSTIC [[
---@class S
---@field pattern? string

---@param s string
local function needString(s) end

---@param t S[]
---@param key string
local function f(t, key)
    local st = t[key]
    if st.pattern then
        needString(st.pattern)
    end
end
]] { '-param-type-mismatch' }

-- 类名字面量可作为该类使用（`Class 'X'` 这类用法的实参）
TEST_DIAGNOSTIC [[
---@class X
local XX = {}

---@param x X
local function take(x) end

take('X')
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class X
local XX = {}

---@param x X
local function take(x) end

take(<?'Y'?>)
]] { 'param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class X
local XX = {}

---@class Y
local YY = {}

---@param y Y
local function take(y) end

take(<?'X'?>)
]] { 'param-type-mismatch' }

-- 类实例传给可选参数（`Node?`）时只要求能转成某个非 nil 成员（子类上溯继承）
TEST_DIAGNOSTIC [[
---@class Base
---@field a string
local B = {}

---@class Node: Base
---@field b string
local N = {}

---@class Node.Value: Node
local V = {}

---@param n Node?
local function take(n) end

---@type Node.Value
local v
take(v)
]] { '-param-type-mismatch' }

TEST_DIAGNOSTIC [[
---@class Node
local N = {}

---@class Node.Value: Node
local V = {}

---@param n Node?
local function take(n) end

---@type string
local s
take(s)
]] { 'param-type-mismatch' }

-- 谓词调用的形参注解可选时，不该把实参收窄成含 nil 的形参变量
TEST_DIAGNOSTIC [[
---@alias uri string

---@param uri uri?
---@param key string
---@return boolean
local function check(uri, key) end

---@param u uri
local function needUri(u) end

---@return uri
local function getUri() end

local function f()
    local uri = getUri()
    if not check(uri, 'k') then
        return
    end
    needUri(uri)
end

f()
]] { '-param-type-mismatch' }

-- `---@cast x T` 之后按 T 使用
TEST_DIAGNOSTIC [[
---@class A
---@field a integer

---@class B
---@field b integer

---@param x A
local function needA(x) end

---@param x A | B
local function f(x)
    ---@cast x A
    needA(x)
end
]] { '-param-type-mismatch' }

-- `---@cast x -T` 只去掉同名成员，T 的子类要保留
TEST_DIAGNOSTIC [[
---@class Base
---@field id integer

---@class Derived: Base
---@field name string

---@param x Base | Derived
local function f(x, cond)
    if cond then
        ---@cast x -Base
        print(x.name)
    end
end
]] { '-undefined-field' }
