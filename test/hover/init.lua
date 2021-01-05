local core  = require 'core.hover'
local files = require 'files'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        files.removeAll()
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        files.setText('', new_script)
        local hover = core.byUri('', pos)
        assert(hover)
        expect = expect:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
        local label = hover.label:gsub('^[\r\n]*(.-)[\r\n]*$', '%1'):gsub('\r\n', '\n')
        assert(expect == label)
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
function mt:init(a: any, b: any, c: any)
]]

TEST [[
local mt = {}
mt.__index = mt
mt.type = 'Class'

function mt:init(a, b, c)
    return
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]]
[[
function Class:init(a: any, b: any, c: any)
]]

TEST [[
local mt = {}
mt.__index = mt
mt.__name = 'Class'

function mt:init(a, b, c)
    return
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]]
[[
function Class:init(a: any, b: any, c: any)
]]

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
function mt:init(a: any, b: any, c: any)
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
function mt:init(a: any, b: any, c: any)
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
[[global obj.xxx: any]]

TEST [[
local <?x?> = 1
]]
"local x: integer = 1"

TEST [[
<?x?> = 1
]]
"global x: integer = 1"

TEST [[
local t = {}
t.<?x?> = 1
]]
"field t.x: integer = 1"

TEST [[
t = {}
t.<?x?> = 1
]]
"global t.x: integer = 1"

TEST [[
t = {
    <?x?> = 1
}
]]
"field x: integer = 1"

TEST [[
local <?obj?> = {}
]]
"local obj: {}"

TEST [[
local mt = {}
mt.__name = 'class'

local <?obj?> = setmetatable({}, mt)
]]
"local obj: class {}"

TEST [[
local mt = {}
mt.name = 'class'
mt.__index = mt

local <?obj?> = setmetatable({}, mt)
]]
[[
local obj: class {
    __index: table,
    name: string = "class",
}
]]

TEST [[
local mt = {}
mt.TYPE = 'class'
mt.__index = mt

local <?obj?> = setmetatable({}, mt)
]]
[[
local obj: class {
    TYPE: string = "class",
    __index: table,
}
]]

TEST [[
local mt = {}
mt.Class = 'class'
mt.__index = mt

local <?obj?> = setmetatable({}, mt)
]]
[[
local obj: class {
    Class: string = "class",
    __index: table,
}
]]

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
function print(...)
]]

TEST [[
string.<?sub?>()
]]
[[
function string.sub(s: string, i: integer, j?: integer)
  -> string
]]

TEST[[
('xx'):<?sub?>()
]]
[[function string:sub(i: integer, j?: integer)
  -> string]]

TEST [[
local <?v?> = collectgarbage()
]]
"local v: any"

TEST [[
local type
w2l:get_default()[<?type?>]
]]
"local type: any"

-- TODO 可选参数（或多原型）
TEST [[
<?load?>()
]]
[=[
function load(chunk: string|function, chunkname?: string, mode?: "b"|"t"|"bt", env?: table)
  -> function
  2. error_message: string
]=]

TEST [[
string.<?lower?>()
]]
[[
function string.lower(s: string)
  -> string
]]

-- 不根据传入值推测参数类型
TEST [[
local function x(a, ...)
end

<?x?>(1, 2, 3, 4, 5, 6, 7)
]]
[[
function x(a: any, ...)
]]

TEST [[
local function x()
    return y()
end

<?x?>()
]]
[[
function x()
  -> any
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
function mt:add(a: any, b: any)
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
function mt:add(a: any, b: any)
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
[[local n: any]]

TEST [[
local <?n?> = table.unpack(t)
]]
[[local n: any]]

TEST [[
local <?n?>
table.pack(n)
]]
[[
local n: any
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
    [table]: integer = 5,
    [function]: integer = 6,
    b: integer = 7,
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
local t: {
    [integer]: integer = 1,
}
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
function mt:test(a: any, b: any)
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
local self: obj {
    __index: table,
    __name: string = "obj",
    id: integer = 1,
    remove: function,
}
]]

TEST [[
print(<?utf8?>)
]]
[[
global utf8: utf8* {
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
global io.stderr: file* {
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
global io: io* {
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
local sssss: utf8* {
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
(3 个定义，2 个原型)
(2) function F(a: any)
(1) function F(b: any)
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
local r: string = "a"
]]

TEST[[
function a(v)
    return 'a'
end
local _, <?r?> = pcall(a, 1)
]]
[[
local r: string = "a"
]]

TEST[[
local <?n?> = rawlen()
]]
[[
local n: integer
]]

TEST[[
<?next?>()
]]
[[
function next(table: table, index?: any)
  -> key: any
  2. value: any
]]

-- TODO 暂未实现
--TEST[[
--local <?n?> = pairs()
--]]
--[[
--function n<next>(table: table [, index: any])
--  -> key: any, value: any
--]]

TEST[[
local <?x?> = '\a'
]]
[[local x: string = "\007"]]

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
field t.v: {
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
    f: file*,
}
]]

TEST [[
io.<?popen?>()
]]
[[
function io.popen(prog: string, mode?: "r"|"w")
  -> file*?
  2. errmsg?: string
]]

TEST [[
<?_G?>
]]
[[
global _G: _G {
    _G: _G,
    _VERSION: string = "Lua 5.4",
    arg: table,
    assert: function,
    bit32: bit32*,
    collectgarbage: function,
    coroutine: coroutine*,
    debug: debug*,
    dofile: function,
    error: function,
    getfenv: function,
    getmetatable: function,
    io: io*,
    ipairs: function,
    jit: jit*,
    load: function,
    loadfile: function,
    loadstring: function,
    math: math*,
    module: function,
    next: function,
    os: os*,
    package: package*,
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
    string: string*,
    table: table*,
    tonumber: function,
    tostring: function,
    type: function,
    unpack: function,
    utf8: utf8*,
    warn: function,
    xpcall: function,
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

TEST [[
local function <?a?>(b)
    return (b.c and a(b.c) or b)
end
]]
[[
function a(b: table)
  -> table
]]

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
global x: Class
]]

TEST[[
local t = {
    ---@class Class
    <?x?> = class()
}
]]
[[
field x: Class
]]

TEST[[
---@type Class
local <?x?> = class()
]]
[[
local x: Class
]]

TEST[[
---@type Class
<?x?> = class()
]]
[[
global x: Class
]]

TEST[[
local t = {
    ---@type Class
    <?x?> = class()
}
]]
[[
field x: Class
]]

TEST[[
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
local t: Class
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
local t: Class {}
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

--TEST [[
-----@type table<ClassA, ClassB>
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: *ClassB
--]]

--TEST [[
-----@type table<ClassA, ClassB>
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: *ClassA
--]]

TEST [[
---@type fun(x: number, y: number):boolean
local <?f?>
]]
[[
function f(x: number, y: number)
  -> boolean
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
---@param f fun():void
function t(<?f?>) end
]]
[[
function ()
  -> void
]]

TEST [[
---@type fun(a:any, b:any)
local f
local t = {f = f}
t:<?f?>()
]]
[[
function f(a: any, b: any)
]]

TEST [[
---@param names string[]
local function f(<?names?>)
end
]]
[[
local names: string[]
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
(2 个定义，2 个原型)
(1) function f(x: number, y: boolean, z: string)
(1) function f(y: boolean)
]]

TEST [[
---@type fun(x?: boolean):boolean?
local <?f?>
]]
[[
function f(x?: boolean)
  -> boolean?
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
  2. second?: string
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
class A
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
展开为 string|'enum1'|'enum2'
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
global t: c {
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
(2 个定义，1 个原型)
(2) function c.f()
]]

TEST [[
---@class c
t = {}

---@overload fun()
function t.<?f?>() end
]]
[[
(2 个定义，1 个原型)
(2) function t.f()
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
function (x: integer, ...)
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
local y: any
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
local x: any
]]
