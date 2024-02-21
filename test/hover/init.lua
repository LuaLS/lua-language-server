local core       = require 'core.hover'
local files      = require 'files'
local catch      = require 'catch'
local config     = require 'config'

rawset(_G, 'TEST', true)

---@diagnostic disable: await-in-sync
function TEST(script)
    return function (expect)
        local newScript, catched = catch(script, '?')
        files.setText(TESTURI, newScript)
        local hover = core.byUri(TESTURI, catched['?'][1][1])
        assert(hover)
        expect = expect:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
        local label = hover:string():gsub('\r\n', '\n'):match('```lua[\r\n]*(.-)[\r\n]*```')
        assert(expect == label)
        files.remove(TESTURI)
    end
end

TEST [[
local function <?x?>(a, b)
end
]]
"function x(a: any, b: any)"

TEST [[
local <?function?> x(a, b)
end
]]
"function x(a: any, b: any)"

TEST [[
local function x(a, b)
end
<?x?>()
]]
"function x(a: any, b: any)"

TEST [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]]
[[
(method) mt:init(a: any, b: any, c: any)
]]

--TEST [[
--local mt = {}
--mt.__index = mt
--mt.type = 'Class'
--
--function mt:init(a, b, c)
--    return
--end
--
--local obj = setmetatable({}, mt)
--
--obj:<?init?>(1, '测试')
--]]
--[[
--function Class:init(a: any, b: any, c: any)
--]]

--TEST [[
--local mt = {}
--mt.__index = mt
--mt.__name = 'Class'
--
--function mt:init(a, b, c)
--    return
--end
--
--local obj = setmetatable({}, mt)
--
--obj:<?init?>(1, '测试')
--]]
--[[
--function Class:init(a: any, b: any, c: any)
--]]

TEST [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]]
[[
(method) mt:init(a: any, b: any, c: any)
  -> table
]]

TEST [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:init(1, '测试')
obj.<?init?>(obj, 1, '测试')
]]
[[
(method) mt:init(a: any, b: any, c: any)
  -> table
]]

TEST [[
function obj.xxx()
end

obj.<?xxx?>()
]]
"function obj.xxx()"

TEST [[
obj.<?xxx?>()
]]
[[(global) obj.xxx: unknown]]

TEST [[
local <?x?> = 1
]]
"local x: integer = 1"

TEST [[
<?x?> = 1
]]
"(global) x: integer = 1"

TEST [[
local t = {}
t.<?x?> = 1
]]
"(field) t.x: integer = 1"

TEST [[
t = {}
t.<?x?> = 1
]]
"(global) t.x: integer = 1"

TEST [[
t = {
    <?x?> = 1
}
]]
"(field) x: integer = 1"

TEST [[
local <?obj?> = {}
]]
"local obj: table"

--TEST [[
--local mt = {}
--mt.__name = 'class'
--
--local <?obj?> = setmetatable({}, mt)
--]]
--"local obj: class {}"

--TEST [[
--local mt = {}
--mt.name = 'class'
--mt.__index = mt
--
--local <?obj?> = setmetatable({}, mt)
--]]
--[[
--local obj: class {
--    __index: table,
--    name: string = "class",
--}
--]]

--TEST [[
--local mt = {}
--mt.TYPE = 'class'
--mt.__index = mt
--
--local <?obj?> = setmetatable({}, mt)
--]]
--[[
--local obj: class {
--    TYPE: string = "class",
--    __index: table,
--}
--]]

--TEST [[
--local mt = {}
--mt.Class = 'class'
--mt.__index = mt
--
--local <?obj?> = setmetatable({}, mt)
--]]
--[[
--local obj: class {
--    Class: string = "class",
--    __index: table,
--}
--]]

-- TODO 支持自定义的函数库
--TEST[[
--local fs = require 'bee.filesystem'
--local <?root?> = fs.current_path()
--]]
--"local root: bee::filesystem"

TEST [[
<?print?>()
]]
[[
function print(...any)
]]

TEST [[
string.<?sub?>()
]]
[[
function string.sub(s: string|number, i: integer, j?: integer)
  -> string
]]

TEST[[
('xx'):<?sub?>()
]]
[[function string.sub(s: string|number, i: integer, j?: integer)
  -> string]]

TEST [[
local <?v?> = collectgarbage()
]]
"local v: any"

TEST [[
local type
w2l:get_default()[<?type?>]
]]
"local type: unknown"

TEST [[
<?load?>()
]]
[=[
function load(chunk: string|function, chunkname?: string, mode?: "b"|"bt"|"t", env?: table)
  -> function?
  2. error_message: string?
]=]

TEST [[
string.<?lower?>()
]]
[[
function string.lower(s: string|number)
  -> string
]]

-- 不根据传入值推测参数类型
TEST [[
local function x(a, ...)
end

<?x?>(1, 2, 3, 4, 5, 6, 7)
]]
[[
function x(a: any, ...any)
]]

TEST [[
local function x()
    return y()
end

<?x?>()
]]
[[
function x()
]]

TEST [[
local mt = {}

function mt:add(a, b)
end

local function init()
    return mt
end

local t = init()
t:<?add?>()
]]
[[
(method) mt:add(a: any, b: any)
]]

TEST [[
local mt = {}
mt.__index = mt

function mt:add(a, b)
end

local function init()
    return setmetatable({}, mt)
end

local t = init()
t:<?add?>()
]]
[[
(method) mt:add(a: any, b: any)
]]

TEST [[
local <?t?> = - 1000
]]
[[local t: integer = -1000]]

-- TODO 暂不支持
--TEST [[
--for <?c?> in io.lines() do
--end
--]]
--[[local c: string]]

TEST [[
local function f()
    return ...
end
local <?n?> = f()
]]
[[local n: unknown]]

TEST [[
local <?n?> = table.unpack(t)
]]
[[local n: unknown]]

TEST [[
local <?n?>
table.pack(n)
]]
[[
local n: unknown
]]

TEST [[
local s = <?'abc中文'?>
]]
[[9 个字节，5 个字符]]

TEST [[
local n = <?0xff?>
]]
[[255]]

TEST [[
local <?t?> = {
    a = 1,
    b = 2,
    c = 3,
}
]]
[[
local t: {
    a: integer = 1,
    b: integer = 2,
    c: integer = 3,
}
]]

TEST [[
local <?t?> = {}
t.a = 1
t.a = true
]]
[[
local t: {
    a: boolean|integer = 1|true,
}
]]

TEST [[
local <?t?> = {
    a = 1,
    [1] = 2,
    [true] = 3,
    [5.5] = 4,
    [{}] = 5,
    [function () end] = 6,
    ["b"] = 7,
    ["012"] = 8,
}
]]
[[
local t: {
    a: integer = 1,
    [1]: integer = 2,
    [true]: integer = 3,
    [5.5]: integer = 4,
    ["b"]: integer = 7,
    ["012"]: integer = 8,
}
]]

TEST [[
local <?t?> = {}
t[#t+1] = 1
t[#t+1] = 1

local any = collectgarbage()
t[any] = any
]]
[[
local t: table
]]

TEST[[
local x = 1
local y = x
print(<?y?>)
]]
[[
local y: integer = 1
]]

TEST[[
local mt = {}
mt.a = 1
mt.b = 2
mt.c = 3
local <?obj?> = setmetatable({}, {__index = mt})
]]
[[
local obj: {
    a: integer = 1,
    b: integer = 2,
    c: integer = 3,
}
]]

TEST[[
local mt = {}
mt.__index = {}

function mt:test(a, b)
    self:<?test?>()
end
]]
[[
(method) mt:test(a: any, b: any)
]]

TEST[[
local mt = {}
mt.__index = mt
mt.__name = 'obj'

function mt:remove()
end

local <?self?> = setmetatable({
    id = 1,
}, mt)
]]
[[
local self: {
    id: integer = 1,
    remove: function,
    __index: table,
    __name: string = 'obj',
}
]]

TEST [[
print(<?utf8?>)
]]
[[
(global) utf8: utf8lib {
    char: function,
    charpattern: string,
    codepoint: function,
    codes: function,
    len: function,
    offset: function,
}
]]

TEST [[
print(io.<?stderr?>)
]]
[[
(global) io.stderr: file* {
    close: function,
    flush: function,
    lines: function,
    read: function,
    seek: function,
    setvbuf: function,
    write: function,
}
]]

TEST [[
print(<?io?>)
]]
[[
(global) io: iolib {
    close: function,
    flush: function,
    input: function,
    lines: function,
    open: function,
    output: function,
    popen: function,
    read: function,
    stderr: file*,
    stdin: file*,
    stdout: file*,
    tmpfile: function,
    type: function,
    write: function,
}
]]

TEST [[
local <?sssss?> = require 'utf8'
]]
[[
local sssss: utf8lib {
    char: function,
    charpattern: string,
    codepoint: function,
    codes: function,
    len: function,
    offset: function,
}
]]

TEST [[
function F(a)
end
function F(b)
end
function F(a)
end
<?F?>()
]]
[[
function F(a: any)
]]

-- 不根据参数推断
--TEST[[
--function a(v)
--    print(<?v?>)
--end
--a(1)
--]]
--[[
--local v: number = 1
--]]
--
--TEST[[
--function a(v)
--    print(<?v?>)
--end
--pcall(a, 1)
--]]
--[[
--local v: number = 1
--]]

--TEST[[
--function a(v)
--    print(<?v?>)
--end
--xpcall(a, log.error, 1)
--]]
--[[
--local v: number = 1
--]]

TEST[[
function a(v)
    return 'a'
end
local <?r?> = a(1)
]]
[[
local r: string = 'a'
]]

TEST[[
function a(v)
    return 'a'
end
local _, <?r?> = pcall(a, 1)
]]
[[
local r: string = 'a'
]]

TEST[[
local <?n?> = rawlen()
]]
[[
local n: integer
]]

TEST[[
local <?x?> = '\a'
]]
[[local x: string = '\007']]

TEST [[
local <?t?> = {
    b = 1,
    c = 2,
    d = 3,
    a = 4,
    s = 5,
    y = 6,
    z = 7,
    q = 8,
    g = 9,
    p = 10,
    l = 11,
}
]]
[[
local t: {
    b: integer = 1,
    c: integer = 2,
    d: integer = 3,
    a: integer = 4,
    s: integer = 5,
    y: integer = 6,
    z: integer = 7,
    q: integer = 8,
    g: integer = 9,
    p: integer = 10,
    l: integer = 11,
}
]]

TEST [[
local function <?f?>()
    return nil, nil
end
]]
[[
function f()
  -> nil
  2. nil
]]

TEST [[
local function f()
    return nil
end
local <?x?> = f()
]]
[[
local x: nil
]]

TEST [[
local function <?f?>()
    return 1
    return nil
end
]]
[[
function f()
  -> integer|nil
]]

TEST [[
local <?t?> = {
    b = 1,
    c = 2,
    d = 3,
}
local e = t.b
]]
[[
local t: {
    b: integer = 1,
    c: integer = 2,
    d: integer = 3,
}
]]

TEST [[
local <?t?> = {
    b = 1,
    c = 2,
    d = 3,
}
g.e = t.b
]]
[[
local t: {
    b: integer = 1,
    c: integer = 2,
    d: integer = 3,
}
]]

TEST [[
local t = {
    v = {
        b = 1,
        c = 2,
        d = 3,
    }
}
print(t.<?v?>)
]]
[[
(field) t.v: {
    b: integer = 1,
    c: integer = 2,
    d: integer = 3,
}
]]

TEST [[
local <?t?> = {
    f = io.open(),
}
]]
[[
local t: {
    f?: file*,
}
]]

TEST [[
io.<?popen?>()
]]
[[
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg: string?
]]

TEST [[
<?_G?>
]]
[[
(global) _G: _G {
    arg: string[],
    assert: function,
    collectgarbage: function,
    coroutine: coroutinelib,
    debug: debuglib,
    dofile: function,
    error: function,
    getfenv: function,
    getmetatable: function,
    io: iolib,
    ipairs: function,
    load: function,
    loadfile: function,
    loadstring: function,
    math: mathlib,
    module: function,
    newproxy: function,
    next: function,
    os: oslib,
    package: packagelib,
    pairs: function,
    pcall: function,
    print: function,
    rawequal: function,
    rawget: function,
    rawlen: function,
    rawset: function,
    require: function,
    select: function,
    setfenv: function,
    setmetatable: function,
    string: stringlib,
    table: tablelib,
    tonumber: function,
    tostring: function,
    type: function,
    unpack: function,
    utf8: utf8lib,
    warn: function,
    xpcall: function,
    _G: _G,
    _VERSION: string = "Lua 5.4",
}
]]

TEST [[
local <?t?> = {
    'aaa',
    'bbb',
    'ccc',
}
]]
[[
local t: {
    [1]: string = 'aaa',
    [2]: string = 'bbb',
    [3]: string = 'ccc',
}
]]

TEST [[
local x
x = 1
x = 1.0

print(<?x?>)
]]
[[
local x: number = 1
]]

TEST [[
local <?x?> <close> = 1
]]
[[
local x <close>: integer = 1
]]

TEST [[
local x <close> = 1
print(<?x?>)
]]
[[
local x <close>: integer = 1
]]

--TEST [[
--local function <?a?>(b)
--    return (b.c and a(b.c) or b)
--end
--]]
--[[
--function a(b: table)
--  -> table
--]]

TEST [[
local <?t?> = {
    a = true
}

local t2 = {
    [t.a] = function () end,
}
]]
[[
local t: {
    a: boolean = true,
}
]]

TEST [[
local <?t?> = {
    [-1] = -1,
    [0]  = 0,
    [1]  = 1,
}
]]
[[
local t: {
    [-1]: integer = -1,
    [0]: integer = 0,
    [1]: integer = 1,
}
]]

TEST[[
---@class Class
local <?x?> = class()
]]
[[
local x: Class
]]

TEST[[
---@class Class
<?x?> = class()
]]
[[
(global) x: Class
]]

TEST[[
local t = {
    ---@class Class
    <?x?> = class()
}
]]
[[
(field) x: Class
]]

TEST[[
---@class Class
local <?x?> = class()
]]
[[
local x: Class
]]

TEST[[
---@class Class
<?x?> = class()
]]
[[
(global) x: Class
]]

TEST[[
---@class A
---@class B
---@class C

---@type A|B|C
local <?x?> = class()
]]
[[
local x: A|B|C
]]

TEST[[
---@class Class
local <?x?> = {
    b = 1
}
]]
[[
local x: Class {
    b: integer = 1,
}
]]

TEST [[
---@class Class
local mt = {}

---@param t Class
function f(<?t?>)
end
]]
[[
(parameter) t: Class
]]

TEST [[
---@class Class
local mt = {}

---@param t Class
function f(t)
    print(<?t?>)
end
]]
[[
(parameter) t: Class
]]

TEST [[
---@class Class

---@param k Class
for <?k?> in pairs(t) do
end
]]
[[
local k: Class
]]

TEST [[
---@class Class

---@param v Class
for k, <?v?> in pairs(t) do
end
]]
[[
local v: Class
]]

TEST [[
---@class A
---@class B
---@class C

---@return A|B
---@return C
local function <?f?>()
end
]]
[[
function f()
  -> A|B
  2. C
]]

TEST [[
---@generic T
---@param x T
---@return T
local function <?f?>(x)
end
]]
[[
function f(x: <T>)
  -> <T>
]]

TEST [[
---@return number
local function f()
end

local <?r?> = f()
]]
[[
local r: number
]]

TEST [[
---@generic T
---@param x T
---@return T
local function f(x)
end

local <?r?> = f(1)
]]
[[
local r: integer = 1
]]

TEST [[
---@param x number
---@param y boolean
local function <?f?>(x, y)
end
]]
[[
function f(x: number, y: boolean)
]]

TEST [[
---@class Class

---@vararg Class
local function f(...)
    local _, <?x?> = ...
end
f(1, 2, 3)
]]
[[
local x: Class
]]

TEST [[
---@class Class

---@vararg Class
local function f(...)
    local <?t?> = {...}
end
]]
[[
local t: Class[]
]]

TEST [[
---@class Class

---@vararg Class
local function f(...)
    local t = {...}
    local <?v?> = t[1]
end
]]
[[
local v: Class
]]

TEST [[
---@class Class

---@vararg Class
local function f(...)
    local <?t?> = {...}
end
f(1, 2, 3)
]]
[[
local t: Class[]
]]

TEST [[
---@class Class

---@param ... Class
local function f(...)
    local _, <?x?> = ...
end
f(1, 2, 3)
]]
[[
local x: Class
]]

TEST [[
---@class Class

---@param ... Class
local function f(...)
    local t = {...}
    local <?v?> = t[1]
end
]]
[[
local v: Class
]]

TEST [[
---@class Class

---@param ... Class
local function f(...)
    local <?t?> = {...}
end
f(1, 2, 3)
]]
[[
local t: Class[]
]]

TEST [[
---@type string[]
local <?x?>
]]
[[
local x: string[]
]]

TEST [[
---@type string[]|boolean
local <?x?>
]]
[[
local x: boolean|string[]
]]

TEST [[
---@type string[]
local t
local <?x?> = t[1]
]]
[[
local x: string
]]

-- TODO
--TEST [[
-----@type string[]
--local t
--for _, <?x?> in ipairs(t) do
--end
--]]
--[[
--local x: string
--]]

--TEST [[
-----@type string[]
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: string
--]]

--TEST [[
-----@type string[]
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: integer
--]]

TEST [[
---@type table<ClassA, ClassB>
local <?x?>
]]
[[
local x: table<ClassA, ClassB>
]]

TEST [[
---@type [ClassA, ClassB]
local <?x?>
]]
[[
local x: [ClassA, ClassB] {
    [1]: ClassA,
    [2]: ClassB,
}
]]

--TEST [[
-----@class ClassA
-----@class ClassB
--
-----@type table<ClassA, ClassB>
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: ClassB
--]]

--TEST [[
-----@class ClassA
-----@class ClassB
--
-----@type table<ClassA, ClassB>
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: ClassA
--]]

TEST [[
---@type fun(x: number, y: number):boolean
local <?f?>
]]
[[
local f: fun(x: number, y: number):boolean
]]

TEST [[
---@type fun(x: number, y: number):boolean
local f
local <?r?> = f()
]]
[[
local r: boolean
]]

TEST [[
---@class void

---@param f fun():void
function t(<?f?>) end
]]
[[
(parameter) f: fun():void
]]

TEST [[
---@type fun(a:any, b:any)
local f
local t = {f = f}
t:<?f?>()
]]
[[
(field) t.f: fun(a: any, b: any)
]]

TEST [[
---@param names string[]
local function f(<?names?>)
end
]]
[[
(parameter) names: string[]
]]

TEST [[
---@return any
function <?f?>()
    ---@type integer
    local a
    return a
end
]]
[[
function f()
  -> any
]]

TEST [[
---@return any
function f()
    ---@type integer
    local a
    return a
end

local <?x?> = f()
]]
[[
local x: any
]]

TEST [[
---@overload fun(y: boolean)
---@param x number
---@param y boolean
---@param z string
function f(x, y, z) end

print(<?f?>)
]]
[[
function f(x: number, y: boolean, z: string)
]]

TEST [[
---@type fun(x?: boolean):boolean?
local <?f?>
]]
[[
local f: fun(x?: boolean):boolean?
]]

TEST [[
---@param x? number
---@param y? boolean
---@return table?, string?
local function <?f?>(x, y)
end
]]
[[
function f(x?: number, y?: boolean)
  -> table?
  2. string?
]]

TEST [[
---@return table first, string? second
local function <?f?>(x, y)
end
]]
[[
function f(x: any, y: any)
  -> first: table
  2. second: string?
]]

TEST [[
---@class Class
---@field x number
---@field y number
---@field z string
local <?t?>
]]
[[
local t: Class {
    x: number,
    y: number,
    z: string,
}
]]

TEST [[
---@class A

---@type <?A?>
]]
[[
(class) A
]]

TEST [[
---@type string | "'enum1'" | "'enum2'"
local <?t?>
]]
[[
local t: string|'enum1'|'enum2'
]]

TEST [[
---@alias A string | "'enum1'" | "'enum2'"

---@type <?A?>
]]
[[
(alias) A 展开为 string|'enum1'|'enum2'
]]

TEST [[
---@alias A string | "'enum1'" | "'enum2'"

---@type A
local <?t?>
]]
[[
local t: string|'enum1'|'enum2'
]]

TEST [[
---@type string
---| "'enum1'"
---| "'enum2'"
local <?t?>
]]
[[
local t: string|'enum1'|'enum2'
]]

TEST [[
---@class c
t = {}

---@overload fun()
function <?t?>.f() end
]]
[[
(global) t: c {
    f: function,
}
]]

TEST [[
---@class c
local t = {}

---@overload fun()
function t.<?f?>() end
]]
[[
function c.f()
]]

TEST [[
---@class c
t = {}

---@overload fun()
function t.<?f?>() end
]]
[[
function t.f()
]]

TEST [[
---@class C
---@field field any

---@type C
local <?c?>
]]
[[
local c: C {
    field: any,
}
]]

TEST [[
---@class C
---@field field any

---@return C
local function f() end

local <?c?> = f()
]]
[[
local c: C {
    field: any,
}
]]

TEST [[
---@param callback fun(x: integer, ...)
local function f(<?callback?>) end
]]
[[
(parameter) callback: fun(x: integer, ...any)
]]

TEST [[
local <?x?> --- @type boolean
]]
[[
local x: boolean
]]

TEST [[
local x --- @type boolean
local <?y?>
]]
[[
local y: unknown
]]

TEST [[
---@class Object
---@field a string

---@type Object[]
local t

local <?v?> = t[1]

print(v.a)
]]
[[
local v: Object {
    a: string,
}
]]

TEST [[
---@class Object
---@field a string

---@type Object[]
local t

local <?v?> = t[i]

print(v.a)
]]
[[
local v: Object {
    a: string,
}
]]

TEST [[
---@class C
---@field x string
local t

---@generic T
---@param v T
---@param message any
---@return T
local function assert(v, message) end

local <?v?> = assert(t)
]]
[[
local v: C {
    x: string,
}
]]

TEST [[
local <?x?>--测试
]]
[[
local x: unknown
]]

TEST [[
---@type unknown
local <?t?>
t.a = 1
]]
[[
local t: {
    a: integer = 1,
}
]]

TEST [[
---@return number
local function f() end
local <?u?> = f()
print(u.x)
]]
[[
local u: number {
    x: unknown,
}
]]

TEST [[
---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local k, v = next(<?t?>)
]]
[[
local t: table<string, boolean>
]]

TEST [[
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
[[
(self) self: E {
    f: function,
}
]]

TEST [[
local f

<?f?>()
]]
[[
local f: unknown
]]

TEST [[
---@class Position
---@field x  number
---@field y  number
---@field z? number
---@field [3]? number
local <?t?>

t.z = any
]]
[[
local t: Position {
    x: number,
    y: number,
    z?: number,
    [3]?: number,
}
]]

TEST [[
---@type { x: string, y: number, z: boolean }
local <?t?>
]]
[[
local t: { x: string, y: number, z: boolean } {
    x: string,
    y: number,
    z: boolean,
}
]]

TEST [[
<?a?>.b = 10 * 60
]]
[[
(global) a: {
    b: integer = 600,
}
]]

TEST [[
a.<?b?> = 10 * 60
]]
[[
(global) a.b: integer = 600
]]

TEST [[
a.<?b?>.c = 1 * 1
]]
[[
(global) a.b: {
    c: integer = 1,
}
]]

TEST [[
local <?t?> = {
    'a', 'b', 'c',
    [10]  = 'd',
    x     = 'e',
    y     = 'f',
    ['z'] = 'g',
    [3]   = 'h',
}
]]
[[
local t: {
    x: string = 'e',
    y: string = 'f',
    ['z']: string = 'g',
    [10]: string = 'd',
    [1]: string = 'a',
    [2]: string = 'b',
    [3]: string = 'c'|'h',
}
]]

TEST [[
function f1.f2.<?f3?>() end
]]
[[
function f1.f2.f3()
]]

TEST [[
local t = nil
t.<?x?>()
]]
[[
(field) t.x: unknown
]]

--TEST [[
-----@class A
--local a
--
--local b
--b = a
--
--print(b.<?x?>)
--]]
--[[
--(field) A.x: unknown
--]]

TEST [[
---@return nil
local function <?f?>() end
]]
[[
function f()
  -> nil
]]

TEST [[
---@async
local function <?f?>() end
]]
[[
(async) function f()
]]

TEST [[
---@type function
local <?f?>
]]
[[
local f: function
]]

TEST [[
---@type async fun()
local <?f?>
]]
[[
local f: async fun()
]]

config.set(nil, 'Lua.runtime.nonstandardSymbol', { '//' })
TEST [[
local <?x?> = 1 // 2
]]
[[
local x: integer = 1
]]
config.set(nil, 'Lua.runtime.nonstandardSymbol', {})

config.set(nil, 'Lua.hover.expandAlias', false)
TEST [[
---@alias uri string

---@type uri
local <?uri?>
]]
[[
local uri: uri
]]

config.set(nil, 'Lua.hover.expandAlias', true)
TEST [[
---@alias uri string

---@type uri
local <?uri?>
]]
[[
local uri: string
]]

TEST [[
local <?x?> = '1' .. '2'
]]
[[
local x: string = "12"
]]

TEST [[
local t = {
    x   = 1,
    [1] = 'x',
}

local <?x?> = t[#t]
]]
[[
local x: string = 'x'
]]

TEST [[
local x = {
    a = 1,
    b = 2,
    [1] = 10,
}

local y = {
    _   = x.a,
    _   = x.b,
    [1] = <?x?>,
}
]]
[[
local x: {
    a: integer = 1,
    b: integer = 2,
    [1]: integer = 10,
}
]]

TEST [[
local <?x?> = {
    _x = '',
    _y = '',
    x  = '',
    y  = '',
}
]]
[[
local x: {
    x: string = '',
    y: string = '',
    _x: string = '',
    _y: string = '',
}
]]

TEST [[
---@class A
---@field x string

---@class B: A
---@field y string

---@type B
local <?t?>
]]
[[
local t: B {
    x: string,
    y: string,
}
]]

TEST [[
---@class A
---@field x string

---@class B: A
---@field x integer
---@field y string

---@type B
local <?t?>
]]
[[
local t: B {
    x: integer,
    y: string,
}
]]

TEST [[
local <?x?>
local function f()
    x
end
]]
[[
local x: unknown
]]

TEST [[
local x
local function f()
    <?x?>
end
]]
[[
(upvalue) x: unknown
]]

TEST [[
---@type `123 ????` | ` x | y `
local <?x?>
]]
[[
local x: ` x | y `|`123 ????`
]]

TEST [[
---@type any
local x

print(x.<?y?>)
]]
[[
(field) x.y: unknown
]]

TEST [[
---@async
x({}, <?function?> () end)
]]
[[
(async) function ()
]]

TEST [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = <?f?>()
local n2 = f(0)
local n3 = f(0, 0)
]]
[[
function f()
  -> boolean
]]

TEST [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = <?f?>(0)
local n3 = f(0, 0)
]]
[[
local f: fun(x: number):number
]]

TEST [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = f(0)
local n3 = <?f?>(0, 0)
]]
[[
local f: fun(x: number, y: number):string
]]

TEST [[
---@class A
local mt

---@type integer
mt.x = 1

mt.y = true

---@type A
local <?t?>
]]
[[
local t: A {
    x: integer,
    y: boolean = true,
}
]]

TEST [[
---@param ... boolean
---@return number ...
local function <?f?>(...) end
]]
[[
function f(...boolean)
  -> ...number
]]

TEST [[
---@param ... boolean
---@return ...
local function <?f?>(...) end
]]
[[
function f(...boolean)
  -> ...unknown
]]

TEST [[
---@type fun():x: number
local <?f?>
]]
[[
local f: fun():(x: number)
]]

TEST [[
---@type fun(...: boolean):...: number
local <?f?>
]]
[[
local f: fun(...boolean):...number
]]

TEST [[
---@type fun():x: number, y: boolean
local <?f?>
]]
[[
local f: fun():(x: number, y: boolean)
]]

TEST [[
---@class MyClass
local MyClass = {
    a = 1
}

function MyClass:Test()
    <?self?>
end
]]
[[
(self) self: MyClass {
    Test: function,
    a: integer = 1,
}
]]

TEST [[
local y
if X then
    y = true
else
    y = false
end

local bool = y

bool = bool and y

if bool then
end

print(<?bool?>)
]]
[[
local bool: boolean = true|false
]]

TEST [[
---@type 'a'
local <?s?>
]]
[[
local s: 'a'
]]

TEST [[
---@enum <?A?>
local m = {
    x = 1,
}
]]
[[
(enum) A
]]

TEST [[
local <?x?> = 1 << 2
]]
[[
local x: integer = 4
]]

TEST [[
local function test1()
    return 1, 2, 3
end

local function <?test2?>()
    return test1()
end
]]
[[
function test2()
  -> integer
  2. integer
  3. integer
]]

TEST [[
---@param x number
---@return boolean
local function <?f?>(
    x
)
end
]]

TEST [[
---@class A
---@field private x number
---@field y number
local <?t?>
]]
[[
local t: A {
    x: number,
    y: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field y number

---@type A
local <?t?>
]]
[[
local t: A {
    y: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field y number
<?t?> = {}
]]
[[
(global) t: A {
    x: number,
    y: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field y number

---@type A
<?t?> = {}
]]
[[
(global) t: A {
    y: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field y number

---@type A
v.<?t?> = {}
]]
[[
(global) v.t: A {
    y: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@type A
local <?t?>
]]
[[
local t: A {
    z: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
local <?t?>
]]
[[
local t: B {
    y: number,
    z: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
---@field private a number
local <?t?>
]]
[[
local t: B {
    a: number,
    y: number,
    z: number,
}
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
---@field private a number

---@type B
local <?t?>
]]
[[
local t: B {
    z: number,
}
]]

TEST [[
---@class A
local mt = {}

---@private
function mt:init()
end

---@protected
function mt:update()
end

function mt:get()
end

print(<?mt?>)
]]
[[
local mt: A {
    get: function,
    init: function,
    update: function,
}
]]

TEST [[
---@class A
local mt = {}

---@private
function mt:init()
end

---@protected
function mt:update()
end

function mt:get()
end

---@type A
local <?obj?>
]]
[[
local obj: A {
    get: function,
}
]]

TEST [[
---@class A
local mt = {}

---@private
function mt:init()
end

---@protected
function mt:update()
end

function mt:get()
end

---@class B: A
local <?obj?>
]]
[[
local obj: B {
    get: function,
    update: function,
}
]]

TEST [[
---@class A
local mt = {}

---@private
function mt:init()
end

---@protected
function mt:update()
end

function mt:get()
end

---@class B: A

---@type B
local <?obj?>
]]
[[
local obj: B {
    get: function,
}
]]

TEST [[
---@class A
local M = {}

---@private
M.x = 0

---@private
function M:init()
    self.x = 1
end

---@type A
local <?a?>
]]
[[
local a: A
]]

TEST [[
---@class A
---@field x fun(): string

---@type table<string, A>
local obj

local x = obj[''].<?x?>()
]]
[[
(field) A.x: fun():string
]]

TEST [[
---@class A
---@field x number

---@see <?A.x?>
]]
[[
(field) A.x: number
]]

TEST [[
---@type { [string]: string }[]
local t

print(<?t?>.foo)
]]
[[
local t: { [string]: string }[] {
    foo: unknown,
}
]]

TEST [[
local t = {
    ['x'] = 1,
    ['y'] = 2,
}

print(t.x, <?t?>.y)
]]
[[
local t: {
    ['x']: integer = 1,
    ['y']: integer = 2,
}
]]

TEST [[
local enum = { a = 1, b = 2 }

local <?t?> = {
    [enum.a] = true,
    [enum.b] = 2,
    [3] = {}
}
]]
[[
local t: {
    [1]: boolean = true,
    [2]: integer = 2,
    [3]: table,
}
]]

TEST [[
---@class A
---@overload fun(x: number): boolean
local <?x?>
]]
[[
local x: A
]]

TEST [[
---@type A
local <?f?>

---@enum A
local t = {
    x = f,
}
]]
[[
local f: A
]]
