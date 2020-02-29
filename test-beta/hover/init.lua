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

-- 不不同调用方式推断定义
--TEST [[
--obj.<?xxx?>()
--]]
--[[function obj.xxx()
--  -> any
--]]

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
    __index: class,
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
    __index: class,
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
    __index: class,
}
]]

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
function string.sub(string, i: integer, j: integer)
  -> string
]]

TEST[[
('xx'):<?sub?>()
]]
[[function string:sub(i: integer, j: integer)
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
function load(chunk: string|function, chunkname: string, mode: string, env: table)
  -> function
  2. error_message: string
]=]

TEST [[
string.<?lower?>()
]]
[[
function string.lower(string)
  -> string
]]

-- TODO 不根据传入值推测参数类型
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

-- TODO 暂不支持跨越函数调用的函数field
--TEST [[
--local mt = {}
--
--function mt:add(a, b)
--end
--
--local function init()
--    return mt
--end
--
--local t = init()
--t:<?add?>()
--]]
--[[
--function mt:add(a: any, b: any)
--]]
--
--TEST [[
--local mt = {}
--mt.__index = mt
--
--function mt:add(a, b)
--end
--
--local function init()
--    return setmetatable({}, mt)
--end
--
--local t = init()
--t:<?add?>()
--]]
--[[
--function mt:add(a: any, b: any)
--]]

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
    __index: obj,
    __name: string = "obj",
    id: integer = 1,
    remove: function,
}
]]

TEST[[
local <?sssss?> = require 'utf8'
]]
[[
local sssss<utf8>: {
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
function next(table: table, index: any)
  -> key: any
  2. value: any
]]

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

--TEST[[
-----@class Class
--local <?x?> = class()
--]]
--[[
--local x: *Class {}
--]]
--
--TEST[[
-----@class Class
--<?x?> = class()
--]]
--[[
--global x: *Class {}
--]]
--
--TEST[[
--local t = {
--    ---@class Class
--    <?x?> = class()
--}
--]]
--[[
--field x: *Class {}
--]]
--
--TEST[[
-----@type Class
--local <?x?> = class()
--]]
--[[
--local x: *Class {}
--]]
--
--TEST[[
-----@type Class
--<?x?> = class()
--]]
--[[
--global x: *Class {}
--]]
--
--TEST[[
--local t = {
--    ---@type Class
--    <?x?> = class()
--}
--]]
--[[
--field x: *Class {}
--]]
--
--TEST[[
-----@type A|B|C
--local <?x?> = class()
--]]
--[[
--local x: *A|B|C {}
--]]
--
--TEST[[
-----@class Class
--local <?x?> = {
--    b = 1
--}
--]]
--[[
--local x: *Class {
--    b: number = 1,
--}
--]]
--
--TEST [[
-----@class Class
--local mt = {}
--
-----@param t Class
--function f(<?t?>)
--end
--]]
--[[
--local t: *Class {}
--]]
--
--TEST [[
-----@class Class
--local mt = {}
--
-----@param t Class
--function f(t)
--    print(<?t?>)
--end
--]]
--[[
--local t: *Class {}
--]]
--
--TEST [[
-----@class Class
--local mt = {}
--
-----@param t Class
--function f(t)
--end
--
--f(<?s?>)
--]]
--[[
--global s: *Class {}
--]]
--
--TEST [[
-----@class Class
--
-----@param k Class
--for <?k?> in pairs(t) do
--end
--]]
--[[
--local k<key>: *Class {}
--]]
--
--TEST [[
-----@class Class
--
-----@param v Class
--for k, <?v?> in pairs(t) do
--end
--]]
--[[
--local v<value>: *Class {}
--]]
--
--TEST [[
-----@return A|B
-----@return C
--local function <?f?>()
--end
--]]
--[[
--function f()
--  -> A|B, C
--]]
--
--TEST [[
-----@generic T
-----@param x T
-----@return T
--local function f(x)
--end
--
--local <?r?> = f(1)
--]]
--[[
--local r: number
--]]
--
--TEST [[
-----@param x number
-----@param y boolean
--local function <?f?>(x, y)
--end
--]]
--[[
--function f(x: number, y: boolean)
--]]
--
--TEST [[
-----@vararg Class
--local function f(...)
--    local _, <?x?> = ...
--end
--f(1, 2, 3)
--]]
--[[
--local x: *Class = 2
--]]
--
--TEST [[
-----@vararg Class
--local function f(...)
--    local _, <?x?> = ...
--end
--]]
--[[
--local x: *Class {}
--]]
--
--TEST [[
-----@type string[]
--local <?x?>
--]]
--[[
--local x: {
--    [*integer]: string,
--}
--]]
--
--TEST [[
-----@type (string|boolean)[]
--local <?x?>
--]]
--[[
--local x: {
--    [*integer]: string|boolean,
--}
--]]
--
--TEST [[
-----@type string[]
--local t
--local <?x?> = t[1]
--]]
--[[
--local x: string
--]]
--
--TEST [[
-----@type string[]
--local t
--for _, <?x?> in ipairs(t) do
--end
--]]
--[[
--local x: string
--]]
--
--TEST [[
-----@type string[]
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: string
--]]
--
--TEST [[
-----@type string[]
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: integer
--]]
--
--TEST [[
-----@type table<ClassA, ClassB>
--local <?x?>
--]]
--[[
--local x: {
--    [*ClassA]: ClassB,
--}
--]]
--
--TEST [[
-----@type table<ClassA, ClassB>
--local t
--for _, <?x?> in pairs(t) do
--end
--]]
--[[
--local x: *ClassB
--]]
--
--TEST [[
-----@type table<ClassA, ClassB>
--local t
--for <?k?>, v in pairs(t) do
--end
--]]
--[[
--local k: *ClassA
--]]
--
--TEST [[
-----@type fun(x: number, y: number):boolean
--local <?f?>
--]]
--[[
--function f(x: number, y: number)
--  -> boolean
--]]
--
--TEST [[
-----@type fun(x: number, y: number):boolean
--local f
--f(<?a?>)
--]]
--[[
--global a: number
--]]
--
--TEST [[
-----@type fun(x: number, y: number):boolean
--local f
--local <?r?> = f()
--]]
--[[
--local r: boolean
--]]
--
--TEST [[
-----@param f fun():void
--function t(<?f?>) end
--]]
--[[
--function ()
--  -> void
--]]
--
--TEST [[
-----@type fun(a:any, b:any)
--local f
--local t = {f = f}
--t:<?f?>()
--]]
--[[
--function f(b: any)
--  -> any
--]]
--
--TEST [[
-----@param names string[]
--local function f(<?names?>)
--end
--]]
--[[
--local names: {
--    [*integer]: string,
--}
--]]
--
--TEST [[
-----@return any
--function <?f?>()
--    ---@type integer
--    local a
--    return a
--end
--]]
--[[
--function f()
--  -> any
--]]
--
--TEST [[
-----@return any
--function f()
--    ---@type integer
--    local a
--    return a
--end
--
--local <?x?> = f()
--]]
--[[
--local x: any
--]]
--
--TEST [[
--local <?x?> <close> <const> = 1
--]]
--[[
--local x <close> <const>: number = 1
--]]
--
--TEST [[
-----@param x number {optional = 'after'}
-----@param y boolean {optional = 'self'}
-----@param z string
--function <?f?>(x, y, z) end
--]]
--[=[
--function f([x: number [, y: boolean], z: string])
--]=]
--
--TEST [[
-----@return string {name = 'key'}
-----@return string {name = 'value'}
--function <?f?>() end
--]]
--[=[
--function f()
--  -> key: string, value: string
--]=]
--
--TEST [[
-----@return        {name = 'x', optional = 'after'}
-----@return string {name = 'y', optional = 'self'}
-----@return string {name = 'z'}
--function <?f?>() end
--]]
--[=[
--function f()
--  -> [x: any [, y: string], z: string]
--]=]
--
--TEST [[
-----@return        {name = 'x', optional = 'after'}
-----@return string {name = 'y', optional = 'self'}
-----@return string {name = 'z'}
--function f()
--    return function (a, b)
--    end
--end
--
--<?f2?> = f()
--]]
--[=[
--function f2(a: any, b: any)
--]=]
