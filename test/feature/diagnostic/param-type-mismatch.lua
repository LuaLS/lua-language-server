TEST_DIAGNOSTIC [[
---@param x number
local function f(x)
end
f(<?'str'?>)
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