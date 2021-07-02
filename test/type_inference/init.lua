local files  = require 'files'
local vm     = require 'vm'
local guide  = require 'parser.guide'
local infer  = require 'core.infer'
local config = require 'config'

rawset(_G, 'TEST', true)

local function getSource(pos)
    local ast = files.getState('')
    return guide.eachSourceContain(ast.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method' then
            return source
        end
    end)
end

function TEST(wanted)
    return function (script)
        files.removeAll()
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local newScript = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        files.setText('', newScript)
        local source = getSource(pos)
        assert(source)
        local result = infer.searchAndViewInfers(source)
        if wanted ~= result then
            infer.searchAndViewInfers(source)
        end
        assert(wanted == result)
    end
end

TEST 'string' [[
local <?var?> = '111'
]]

TEST 'boolean' [[
local <?var?> = true
]]

TEST 'integer' [[
local <?var?> = 1
]]

TEST 'number' [[
local <?var?> = 1.0
]]

TEST 'string' [[
local var = '111'
t.<?x?> = var
]]

TEST 'string' [[
local <?var?>
var = '111'
]]

TEST 'string' [[
local var
var = '111'
print(<?var?>)
]]

TEST 'function' [[
function <?xx?>()
end
]]

TEST 'function' [[
local function <?xx?>()
end
]]

TEST 'function' [[
local xx
<?xx?> = function ()
end
]]

TEST 'table' [[
local <?t?> = {}
]]

TEST 'any' [[
<?x?>()
]]

TEST 'table' [[
<?t?>.x = 1
]]

TEST 'boolean' [[
<?x?> = not y
]]

TEST 'integer' [[
<?x?> = #y
]]

TEST 'number' [[
<?x?> = - y
]]

TEST 'integer' [[
<?x?> = ~ y
]]

TEST 'integer' [[
local a = true
local b = 1
<?x?> = a and b
]]

TEST 'integer' [[
local a = false
local b = 1
<?x?> = a or b
]]

TEST 'boolean' [[
<?x?> = a == b
]]

TEST 'integer' [[
<?x?> = a << b
]]

TEST 'string' [[
<?x?> = a .. b
]]

TEST 'number' [[
<?x?> = a + b
]]

TEST 'tablelib' [[
---@class tablelib
table = {}

<?table?>()
]]

TEST 'string' [[
_VERSION = 'Lua 5.4'

<?x?> = _VERSION
]]

TEST 'function' [[
---@class stringlib
local string

string.sub = function () end

return ('x').<?sub?>
]]

TEST 'function' [[
---@class stringlib
local string

string.sub = function () end

<?x?> = ('x').sub
]]

TEST 'function' [[
---@class stringlib
local string

string.sub = function () end

_VERSION = 'Lua 5.4'

<?x?> = _VERSION.sub
]]

TEST 'table' [[
<?x?> = setmetatable({})
]]

TEST 'integer' [[
local function x()
    return 1
end
<?y?> = x()
]]

TEST 'integer|nil' [[
local function x()
    return 1
    return nil
end
<?y?> = x()
]]

TEST 'any' [[
local function x()
    return a
    return nil
end
<?y?> = x()
]]

TEST 'integer' [[
local function x()
    return 1
end
_, <?y?> = pcall(x)
]]

TEST 'integer' [[
function x()
    return 1
end
_, <?y?> = pcall(x)
]]

TEST 'integer' [[
local function x()
    return 1
end
_, <?y?> = xpcall(x)
]]

TEST 'string|table' [[
local y = #<?x?>
]]

TEST 'integer' [[
local y = <?x?> << 0
]]

TEST 'integer' [[
local function f(<?a?>, b)
    return a << b
end
]]

TEST 'A' [[
---@class A

---@return A
local function f2() end

local function f()
    return f2()
end

local <?x?> = f()
]]

-- 不根据调用者的输入参数来推测
--TEST 'number' [[
--local function x(a)
--    return <?a?>
--end
--x(1)
--]]

--TEST 'table' [[
--setmetatable(<?b?>)
--]]

-- 不根据对方函数内的使用情况来推测
TEST 'any' [[
local function x(a)
    _ = a + 1
end
local b
x(<?b?>)
]]

TEST 'any' [[
local function x(a, ...)
    local _, <?b?>, _ = ...
end
x(nil, 'xx', 1, true)
]]

-- 引用不跨越参数
TEST 'any' [[
local function x(a, ...)
    return true, 'ss', ...
end
local _, _, _, <?b?>, _ = x(nil, true, 1, 'yy')
]]

TEST 'any' [[
local <?x?> = next()
]]

TEST 'any' [[
local a, b
function a()
    return b()
end
function b()
    return a()
end
local <?x?> = a()
]]

TEST 'class' [[
---@class class
local <?x?>
]]

TEST 'string' [[
---@class string

---@type string
local <?x?>
]]

TEST 'string[]' [[
---@class string

---@type string[]
local <?x?>
]]

TEST 'string|table' [[
---@class string
---@class table

---@type string | table
local <?x?>
]]

TEST '"enum1"|"enum2"' [[
---@type '"enum1"' | '"enum2"'
local <?x?>
]]

TEST 'fun()' [[
---@type fun()
local <?x?>
]]

TEST 'table<string, number>' [[
---@class string
---@class number

---@type table<string, number>
local <?x?>
]]

TEST 'table' [[
self.<?t?>[#self.t+1] = {}
]]

TEST 'string' [[
---@class string

---@type string[]
local x
local <?y?> = x[1]
]]

TEST 'string' [[
---@class string

---@return string[]
local function f() end
local x = f()
local <?y?> = x[1]
]]

TEST 'table' [[
local <?t?>
print(t.sub())
]]

TEST 'string|table' [[
local <?t?>
print(t:sub())
]]

TEST 'string' [[
local <?t?>
print(t:sub())
print(t .. 'a')
]]

TEST 'string' [[
local <?t?>
print(#t)
print(t .. 'a')
]]

TEST 'table' [[
local t = {}
local <?v?> = setmetatable(t)
]]

TEST 'CCC' [[
---@class CCC

---@type table<string, CCC>
local t = {}

print(t.<?a?>)
]]

TEST '"aaa"|"bbb"' [[
---@type table<string, '"aaa"'|'"bbb"'>
local t = {}

print(t.<?a?>)
]]

TEST 'integer' [[
---@class integer

---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
local function ipairs() end

for <?i?> in ipairs() do
end
]]

TEST 'table<string, boolean>' [[
---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local k, v = next(<?t?>)
]]

TEST 'string' [[
---@class string

---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local <?k?>, v = next(t)
]]

TEST 'boolean' [[
---@class boolean

---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local k, <?v?> = next(t)
]]

TEST 'boolean' [[
---@generic K
---@type fun(arg: K):K
local f

local <?r?> = f(true)
]]

TEST 'string' [[
---@class string

---@generic K, V
---@type fun(arg: table<K, V>):K, V
local f

---@type table<string, boolean>
local t

local <?k?>, v = f(t)
]]

TEST 'boolean' [[
---@class boolean

---@generic K, V
---@type fun(arg: table<K, V>):K, V
local f

---@type table<string, boolean>
local t

local k, <?v?> = f(t)
]]

TEST 'fun()' [[
---@return fun()
local function f() end

local <?r?> = f()
]]

TEST 'table<string, boolean>' [[
---@return table<string, boolean>
local function f() end

local <?r?> = f()
]]

TEST 'string' [[
---@class string

---@generic K, V
---@return fun(arg: table<K, V>):K, V
local function f() end

local f2 = f()

---@type table<string, boolean>
local t

local <?k?>, v = f2(t)
]]

TEST 'string' [[
---@class string

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

local f = pairs(t)

---@type table<string, boolean>
local t

for <?k?>, v in f, t do
end
]]

TEST 'boolean' [[
---@class boolean

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
local function pairs(t) end

local f = pairs(t)

---@type table<string, boolean>
local t

for k, <?v?> in f, t do
end
]]

TEST 'string' [[
---@class string

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
local function pairs(t) end

---@type table<string, boolean>
local t

for <?k?>, v in pairs(t) do
end
]]

TEST 'boolean' [[
---@class boolean

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

---@type table<string, boolean>
local t

for k, <?v?> in pairs(t) do
end
]]

TEST 'boolean' [[
---@class boolean

---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

---@type boolean[]
local t

for _, <?v?> in ipairs(t) do
end
]]

TEST 'boolean' [[
---@class boolean

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index: K):K, V
---@return T
---@return nil
local function pairs(t) end

---@type boolean[]
local t

for k, <?v?> in pairs(t) do
end
]]

TEST 'integer' [[
---@class integer

---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
local function pairs(t) end

---@type boolean[]
local t

for <?k?>, v in pairs(t) do
end
]]

TEST 'E' [[
---@class A
---@class B: A
---@class C: B
---@class D: C

---@class E: D
local m

function m:f()
    return <?self?>
end
]]

TEST 'Cls' [[
---@class Cls
local Cls = {}

---@generic T
---@param self T
---@return T
function Cls.new(self) return self end

local <?test?> = Cls:new()
]]

TEST 'Cls' [[
---@class Cls
local Cls = {}

---@generic T
---@param self T
---@return T
function Cls:new() return self end

local <?test?> = Cls:new()
]]

TEST 'Cls' [[
---@class Cls
local Cls = {}

---@generic T
---@param self T
---@return T
function Cls.new(self) return self end

local <?test?> = Cls.new(Cls)
]]

TEST 'Cls' [[
---@class Cls
local Cls = {}

---@generic T
---@param self T
---@return T
function Cls:new() return self end

local <?test?> = Cls.new(Cls)
]]

TEST 'Rct' [[
---@class Obj
local Obj = {}

---@generic T
---@param self T
---@return T
function Obj.new(self) return self end


---@class Pnt:Obj
local Pnt = {x = 0, y = 0}


---@class Rct:Pnt
local Rct = {w = 0, h = 0}


local <?test?> = Rct.new(Rct)

-- local test = Rct:new()

return test
]]

TEST 'function' [[
string.gsub():gsub():<?gsub?>()
]]

config.set('Lua.hover.enumsLimit', 5)
TEST 'a|b|c|d|e...(+5)' [[
---@type 'a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'
local <?t?>
]]

config.set('Lua.hover.enumsLimit', 1)
TEST 'a...(+9)' [[
---@type 'a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'
local <?t?>
]]

config.set('Lua.hover.enumsLimit', 0)
TEST '...(+10)' [[
---@type 'a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'
local <?t?>
]]

config.set('Lua.hover.enumsLimit', 5)

TEST 'string|fun():string' [[
---@type string | fun(): string
local <?t?>
]]

TEST 'string' [[
local valids = {
    ['Lua 5.1'] = false,
    ['Lua 5.2'] = false,
    ['Lua 5.3'] = false,
    ['Lua 5.4'] = false,
    ['LuaJIT']  = false,
}

for <?k?>, v in pairs(valids) do
end
]]

TEST 'boolean' [[
local valids = {
    ['Lua 5.1'] = false,
    ['Lua 5.2'] = false,
    ['Lua 5.3'] = false,
    ['Lua 5.4'] = false,
    ['LuaJIT']  = false,
}

for k, <?v?> in pairs(valids) do
end
]]

TEST 'string' [[
local t = {
    a = 1,
    b = 1,
}

for <?k?>, v in pairs(t) do
end
]]

TEST 'integer' [[
local t = {'a', 'b'}

for <?k?>, v in pairs(t) do
end
]]

TEST 'string' [[
local t = {'a', 'b'}

for k, <?v?> in pairs(t) do
end
]]

TEST 'fun():number, boolean' [[
---@type fun():number, boolean
local <?t?>
]]

--[[
l:value
l:work|&1|&1
f:|&1|&1
dfun:|&1
dn:Class
]]
TEST 'Class' [[
---@class Class

---@param callback fun(value: Class)
function work(callback)
end

work(function (<?value?>)
end)
]]

TEST 'Class' [[
---@class Class

---@param callback fun(value: Class)
function work(callback)
end

pcall(work, function (<?value?>)
end)
]]

TEST 'Class' [[
---@class Class

---@param callback fun(value: Class)
function work(callback)
end

xpcall(work, debug.traceback, function (<?value?>)
end)
]]
