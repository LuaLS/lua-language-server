local files  = require 'files'
local guide  = require 'parser.guide'
local infer  = require 'vm.infer'
local config = require 'config'
local catch  = require 'catch'

rawset(_G, 'TEST', true)

local function getSource(pos)
    local ast = files.getState('')
    local result
    guide.eachSourceContain(ast.ast, pos, function (source)
        if source.type == 'local'
        or source.type == 'getlocal'
        or source.type == 'setlocal'
        or source.type == 'setglobal'
        or source.type == 'getglobal'
        or source.type == 'field'
        or source.type == 'method'
        or source.type == 'function'
        or source.type == 'table' then
            result = source
        end
    end)
    return result
end

function TEST(wanted)
    return function (script)
        local newScript, catched = catch(script, '?')
        files.setText('', newScript)
        local source = getSource(catched['?'][1][1])
        assert(source)
        local result = infer.getInfer(source):view()
        if wanted ~= result then
            infer.getInfer(source):view()
        end
        assert(wanted == result)
        files.remove('')
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

TEST 'unknown' [[
local <?var?>
]]

TEST 'unknown' [[
local <?var?>
var = y
]]

TEST 'any' [[
function f(<?x?>)
    
end
]]

TEST 'any' [[
function f(<?x?>)
    x = 1
end
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
<?var?> = '111'
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

TEST 'unknown' [[
<?x?>()
]]

TEST 'boolean' [[
<?x?> = not y
]]

TEST 'integer' [[
<?x?> = #y
]]

TEST 'integer' [[
<?x?> = #'aaaa'
]]

TEST 'integer' [[
<?x?> = #{}
]]

TEST 'number' [[
<?x?> = - y
]]

TEST 'number' [[
<?x?> = - 1.0
]]

TEST 'integer' [[
<?x?> = ~ y
]]

TEST 'integer' [[
<?x?> = ~ 1
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

TEST 'integer' [[
<?x?> = 1 << 2
]]

TEST 'string' [[
<?x?> = a .. b
]]

TEST 'string' [[
<?x?> = 'a' .. 'b'
]]

TEST 'string' [[
<?x?> = 'a' .. 1
]]

TEST 'string' [[
<?x?> = 'a' .. 1.0
]]

TEST 'number' [[
<?x?> = a + b
]]

TEST 'number' [[
<?x?> = 1 + 2.0
]]

TEST 'integer' [[
<?x?> = 1 + 2
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

string.xxx = function () end

return ('x').<?xxx?>
]]

TEST 'function' [[
---@class stringlib
String = {}

String.xxx = function () end

return ('x').<?xxx?>
]]

TEST 'function' [[
---@class stringlib
local string

string.xxx = function () end

<?x?> = ('x').xxx
]]

TEST 'function' [[
---@class stringlib
local string

string.xxx = function () end

_VERSION = 'Lua 5.4'

<?x?> = _VERSION.xxx
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

TEST 'unknown|nil' [[
local function x()
    return a
    return nil
end
<?y?> = x()
]]

TEST 'unknown|nil' [[
local function x()
    return nil
    return f()
end
<?y?> = x()
]]

TEST 'unknown' [[
local function x()
    return nil
    return f()
end
_, <?y?> = x()
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
TEST 'unknown' [[
local function x(a)
    _ = a + 1
end
local b
x(<?b?>)
]]

TEST 'unknown' [[
local function x(a, ...)
    local _, <?b?>, _ = ...
end
x(nil, 'xx', 1, true)
]]

-- 引用不跨越参数
TEST 'unknown' [[
local function x(a, ...)
    return true, 'ss', ...
end
local _, _, _, <?b?>, _ = x(nil, true, 1, 'yy')
]]

TEST 'unknown' [[
local <?x?> = next()
]]

TEST 'unknown' [[
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

TEST '1' [[
---@type 1
local <?v?>
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

TEST [['enum1'|'enum2']] [[
---@type 'enum1' | 'enum2'
local <?x?>
]]

TEST [["enum1"|"enum2"]] [[
---@type "enum1" | "enum2"
local <?x?>
]]

config.set(nil, 'Lua.hover.expandAlias', false)
TEST 'A' [[
---@alias A 'enum1' | 'enum2'

---@type A
local <?x?>
]]

TEST 'A' [[
---@alias A 'enum1' | 'enum2' | A

---@type A
local <?x?>
]]

TEST 'A' [[
---@alias A 'enum1' | 'enum2' | B

---@type A
local <?x?>
]]
config.set(nil, 'Lua.hover.expandAlias', true)
TEST [['enum1'|'enum2']] [[
---@alias A 'enum1' | 'enum2'

---@type A
local <?x?>
]]

TEST [['enum1'|'enum2']] [[
---@alias A 'enum1' | 'enum2' | A

---@type A
local <?x?>
]]

TEST [['enum1'|'enum2'|B]] [[
---@alias A 'enum1' | 'enum2' | B

---@type A
local <?x?>
]]

TEST '1|true' [[
---@alias A 1 | true

---@type A
local <?x?>
]]

TEST 'fun()' [[
---@type fun()
local <?x?>
]]

TEST 'fun(a: string, b: any, ...: any)' [[
---@type fun(a: string, b, ...)
local <?x?>
]]

TEST 'fun(a: string, b: any, c?: boolean, ...: any):c, d?, ...' [[
---@type fun(a: string, b, c?: boolean, ...):c, d?, ...
local <?x?>
]]

TEST 'table' [[
---@type { [string]: string }
local <?x?>
]]

TEST 'table<string, number>' [[
---@class string
---@class number

---@type table<string, number>
local <?x?>
]]

TEST 'A<string, number>' [[
---@class A

---@type A<string, number>
local <?x?>
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
local t = {}
local <?v?> = setmetatable(t)
]]

TEST 'CCC' [[
---@class CCC

---@type table<string, CCC>
local t = {}

print(t.<?a?>)
]]

TEST [['aaa'|'bbb']] [[
---@type table<string, 'aaa'|'bbb'>
local t = {}

print(t.<?a?>)
]]

TEST 'integer' [[
---@generic K
---@type fun(a?: K):K
local f

local <?n?> = f(1)
]]

TEST 'unknown' [[
---@generic K
---@type fun(a?: K):K
local f

local <?n?> = f(nil)
]]

TEST 'unknown' [[
---@generic K
---@type fun(a: K|integer):K
local f

local <?n?> = f(1)
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

TEST 'fun(a: <V>):integer, <V>' [[
---@generic K, V
---@param a K
---@return fun(a: V):K, V
local function f(a) end

local <?f2?> = f(1)
]]

TEST 'integer' [[
---@generic K, V
---@param a K
---@return fun(a: V):K, V
local function f(a) end

local f2 = f(1)
local <?i?>, v = f2(true)
]]

TEST 'boolean' [[
---@generic K, V
---@param a K
---@return fun(a: V):K, V
local function f(a) end

local f2 = f(1)
local i, <?v?> = f2(true)
]]

TEST 'fun(table: table<<K>, <V>>, index?: <K>):<K>, <V>' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
---@return nil
local function pairs(t) end

local <?next?> = pairs(dummy)
]]

TEST 'string' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
---@return nil
local function pairs(t) end

local next = pairs(dummy)

---@type table<string, boolean>
local t
local <?k?>, v = next(t)
]]

TEST 'boolean' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
---@return nil
local function pairs(t) end

local next = pairs(dummy)

---@type table<string, boolean>
local t
local k, <?v?> = next(t)
]]

TEST 'string' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
---@return nil
local function pairs(t) end

local next = pairs(dummy)

---@type table<string, boolean>
local t
local <?k?>, v = next(t, nil)
]]

TEST 'boolean' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
---@return nil
local function pairs(t) end

local next = pairs(dummy)

---@type table<string, boolean>
local t
local k, <?v?> = next(t, nil)
]]

TEST 'string' [[
---@generic T: table, K, V
---@param t T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
---@return nil
local function pairs(t) end

local next = pairs(dummy)

---@type table<string, boolean>
local t

for <?k?>, v in next, t do
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
---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

---@type table<integer, boolean>
local t

for _, <?v?> in ipairs(t) do
end
]]

TEST 'boolean' [[
---@generic T: table, V
---@param t T
---@return fun(table: V[], i?: integer):integer, V
---@return T
---@return integer i
local function ipairs(t) end

---@class MyClass
---@field [integer] boolean
local t

for _, <?v?> in ipairs(t) do
end
]]

TEST 'boolean' [[
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

config.set(nil, 'Lua.hover.enumsLimit', 5)
TEST [['a'|'b'|'c'|'d'|'e'...(+5)]] [[
---@type 'a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'
local <?t?>
]]

config.set(nil, 'Lua.hover.enumsLimit', 1)
TEST [['a'...(+9)]] [[
---@type 'a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'
local <?t?>
]]

config.set(nil, 'Lua.hover.enumsLimit', 0)
TEST '...(+10)' [[
---@type 'a'|'b'|'c'|'d'|'e'|'f'|'g'|'h'|'i'|'j'
local <?t?>
]]

config.set(nil, 'Lua.hover.enumsLimit', 5)

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


TEST 'fun(value: Class)' [[
---@class Class

---@param callback fun(value: Class)
function work(callback)
end

work(<?function?> (value)
end)
]]

TEST 'Class' [[
---@class Class

---@param callback fun(value: Class)
function work(callback)
end

work(function (<?value?>)
end)
]]

TEST 'fun(value: Class)' [[
---@class Class

---@param callback fun(value: Class)
function work(callback)
end

pcall(work, <?function?> (value)
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

TEST 'string' [[
---@generic T
---@param x T
---@return { x: T }
local function f(x) end

local t = f('')

print(t.<?x?>)
]]

TEST 'string' [[
---@generic T
---@param t T[]
---@param callback fun(v: T)
local function f(t, callback) end

---@type string[]
local t

f(t, function (<?v?>) end)
]]

TEST 'unknown' [[
---@generic T
---@param t T[]
---@param callback fun(v: T)
local function f(t, callback) end

local t = {}

f(t, function (<?v?>) end)
]]

TEST 'table' [[
local <?t?> = setmetatable({}, { __index = function () end })
]]

TEST 'player' [[
---@class player
local t

<?t?>:getOwner()
]]

TEST 'string[][]' [[
---@type string[][]
local <?t?>
]]

TEST 'table' [[
---@type {}[]
local t

local <?v?> = t[1]
]]

TEST 'string' [[
---@type string[][]
local v = {}

for _, a in ipairs(v) do
    for i, <?b?> in ipairs(a) do
    end
end
]]

--TEST 'number' [[
-----@param x number
--local f
--
--f = function (<?x?>) end
--]]

TEST 'fun(i: integer)' [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field on fun(eventName: 'died', cb: fun(i: integer))
--- @field on fun(eventName: 'won', cb: fun(s: string))
local emit = {}

emit.on("died", <?function?> (i)
end)
]]

TEST 'integer' [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field on fun(eventName: 'died', cb: fun(i: integer))
--- @field on fun(eventName: 'won', cb: fun(s: string))
local emit = {}

emit.on("died", function (<?i?>)
end)
]]

TEST 'integer' [[
--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: 'died', cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: 'won', cb: fun(s: string))
local emit = {}

emit:on("died", function (<?i?>)
end)
]]

TEST 'integer' [[
--- @class Emit
--- @field on fun(self: Emit, eventName: string, cb: function)
--- @field on fun(self: Emit, eventName: '"died"', cb: fun(i: integer))
--- @field on fun(self: Emit, eventName: '"won"', cb: fun(s: string))
local emit = {}

emit.on(self, "died", function (<?i?>)
end)
]]

TEST '👍' [[
---@class 👍
local <?x?>
]]

TEST 'integer' [[
---@type boolean
local x

<?x?> = 1
]]

TEST 'integer' [[
---@class Class
local x

<?x?> = 1
]]

TEST 'unknown' [[
---@return number
local function f(x)
    local <?y?> = x()
end
]]

TEST 'unknown' [[
local mt

---@return number
function mt:f() end

local <?v?> = mt()
]]

TEST 'unknown' [[
local <?mt?>

---@class X
function mt:f(x) end
]]

TEST 'any' [[
local mt

---@class X
function mt:f(<?x?>) end
]]

TEST 'unknown' [[
local <?mt?>

---@type number
function mt:f(x) end
]]

TEST 'any' [[
local mt

---@type number
function mt:f(<?x?>) end
]]

TEST 'Test' [[
---@class Test
_G.<?Test?> = {}
]]

TEST 'integer' [[
local mt = {}

---@param callback fun(i: integer)
function mt:loop(callback) end

mt:loop(function (<?i?>)
    
end)
]]

TEST 'C' [[
---@class D
---@field y integer # D comment

---@class C
---@field x integer # C comment
---@field d D

---@param c C
local function f(c) end

f <?{?>
    x = ,
}
]]

TEST 'integer' [[
---@class D
---@field y integer # D comment

---@class C
---@field x integer # C comment
---@field d D

---@param c C
local function f(c) end

f {
    <?x?> = ,
}
]]

TEST 'integer' [[
---@class D
---@field y integer # D comment

---@class C
---@field x integer # C comment
---@field d D

---@param c C
local function f(c) end

f {
    d = {
        <?y?> = ,
    }
}
]]

TEST 'integer' [[
for <?i?> = a, b, c do end
]]

TEST 'number' [[
---@param x number
function F(<?x?>) end

---@param x boolean
function F(x) end
]]

TEST 'B' [[
---@class A
local A

---@return A
function A:x() end

---@class B: A
local B

---@return B
function B:x() end

---@type B
local t

local <?v?> = t.x()
]]

TEST 'function' [[
---@overload fun()
function <?f?>() end
]]

TEST 'integer' [[
---@type table<string, integer>
local t

t.<?a?>
]]

TEST '"a"|"b"|"c"' [[
---@type table<string, "a"|"b"|"c">
local t

t.<?a?>
]]

TEST 'integer' [[
---@class A
---@field x integer

---@type A
local t
t.<?x?>
]]

TEST 'boolean' [[
local <?var?> = true
var = 1
var = 1.0
]]

TEST 'unknown' [[
---@return ...
local function f() end

local <?x?> = f()
]]

TEST 'unknown' [[
---@return ...
local function f() end

local _, <?x?> = f()
]]

TEST 'unknown' [[
local t = {
    x = 1,
    y = 2,
}

local <?x?> = t[#t]
]]

TEST 'string' [[
local t = {
    x   = 1,
    [1] = 'x',
}

local <?x?> = t[#t]
]]

TEST 'string' [[
local t = { 'x' }

local <?x?> = t[#t]
]]

TEST '(string|integer)[]' [[
---@type (string|integer)[]
local <?x?>
]]

TEST 'boolean' [[
---@type table<string, boolean>
local t

---@alias uri string

---@type string
local uri

local <?v?> = t[uri]
]]

TEST 'A' [[
---@class A
G = {}

<?G?>:A()
]]

TEST 'A' [[
---@type A
local <?x?> = nil
]]

TEST 'A' [[
---@class A
---@field b B
local mt

function mt:f()
    self.b:x()
    print(<?self?>)
end
]]

TEST 'string?' [[
---@return string?
local function f() end

local <?x?> = f()
]]

TEST 'AA' [[
---@class AA
---@overload fun():AA
local AAA


local <?x?> = AAA()
]]

TEST 'string|integer' [[
local <?x?>
x = '1'
x = 1
]]

TEST 'string' [[
local x
<?x?> = '1'
x = 1
]]

TEST 'integer' [[
local x
x = '1'
<?x?> = 1
]]

TEST 'unknown' [[
local x
print(<?x?>)
x = '1'
x = 1
]]

TEST 'string' [[
local x
x = '1'
print(<?x?>)
x = 1
]]

TEST 'integer' [[
local x
x = '1'
x = 1
print(<?x?>)
]]

TEST 'unknown' [[
local x

function A()
    print(<?x?>)
end
]]

TEST 'unknown' [[
local x

function A()
    print(<?x?>)
end

x = '1'
x = 1
]]

TEST 'string' [[
local x

x = '1'

function A()
    print(<?x?>)
end

x = 1
]]

TEST 'integer' [[
local x

x = '1'
x = 1

function A()
    print(<?x?>)
end

]]

TEST 'boolean' [[
local x

function A()
    x = true
    print(<?x?>)
end

x = '1'
x = 1
]]

TEST 'unknown' [[
local x

function A()
    x = true
end

print(<?x?>)
x = '1'
x = 1
]]

TEST 'boolean' [[
local x

function A()
    x = true
    function B()
        print(<?x?>)
    end
end

x = '1'
x = 1
]]

TEST 'table' [[
local x

function A()
    x = true
    function B()
        x = {}
        print(<?x?>)
    end
end

x = '1'
x = 1
]]

TEST 'boolean' [[
local x

function A()
    x = true
    function B()
        x = {}
    end
    print(<?x?>)
end

x = '1'
x = 1
]]

TEST 'unknown' [[
local x

function A()
    x = true
    function B()
        x = {}
    end
end

function C()
    print(<?x?>)
end

x = '1'
x = 1
]]

TEST 'integer?' [[
---@type integer?
local <?x?>
]]

TEST 'integer?' [[
---@type integer?
local x

if <?x?> then
    print(x)
end
]]

TEST 'integer' [[
---@type integer?
local x

if x then
    print(<?x?>)
end
]]
--[[
#0 integer?
save 1 #1 integer? --ifblock --block中的初始状态
save 2 #2 integer? --ifblock --block外的状态
save 3 #3 integer? --ifblock --filter的状态
object get #3 integer? --if x then
load 2 #2 integer? --ifblock
falsy 2 #2 ? --ifblock
load 1 #1 integer? --ifblock
truly #1 integer --ifblock
object get #1 integer --print(x)
save 4 #?(1) integer --block中的最终状态
load 2 #2 ? --ifblock -- block
merge 4 #2 --if 最终状态
]]

TEST 'integer?' [[
---@type integer?
local x

if x then
    print(x)
end

print(<?x?>)
]]

TEST 'integer' [[
---@type integer?
local x

if not x then
    x = 1
end

print(<?x?>)
]]

TEST 'integer' [[
---@type integer?
local x

if xxx and x then
    print(<?x?>)
end
]]

TEST 'integer' [[
---@type integer?
local x

if x ~= nil then
    print(<?x?>)
end

print(x)
]]

TEST 'integer?' [[
---@type integer?
local x

if x ~= nil then
    print(x)
end

print(<?x?>)
]]

TEST 'nil' [[
---@type integer?
local x

if x == nil then
    print(<?x?>)
end

print(x)
]]

TEST 'integer|nil' [[
---@type integer?
local x

if x == nil then
    print(x)
end

print(<?x?>)
]]

TEST 'integer' [[
---@type integer?
local x

<?x?> = x or 1
]]

TEST 'integer' [=[
local x

print(<?x?>--[[@as integer]])
]=]

TEST 'integer' [=[
print(<?io?>--[[@as integer]])
]=]

TEST 'integer' [=[
print(io.<?open?>--[[@as integer]])
]=]

TEST 'integer' [=[
local <?x?> = io['open']--[[@as integer]])
]=]

TEST 'integer' [=[
local <?x?> = 1 + 1--[[@as integer]])
]=]

TEST 'integer' [=[
local <?x?> = not 1--[[@as integer]])
]=]

TEST 'integer' [=[
local <?x?> = ()--[[@as integer]])
]=]

TEST 'integer?' [[
---@param x? integer
local function f(<?x?>)

end
]]

TEST 'integer' [[
local x = 1
x = <?x?>
]]

TEST 'integer?' [[
---@class A
---@field x? integer
local t

t.<?x?>
]]

TEST 'integer?' [[
---@type { x?: integer }
local t

t.<?x?>
]]

TEST 'boolean' [[
---@class A
---@field [integer] boolean
local t

local <?x?> = t[1]
]]
