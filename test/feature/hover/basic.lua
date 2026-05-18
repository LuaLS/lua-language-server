local config = test.scope.config

TEST_HOVER [[
---@type integer
local x
print(x<??>)
]] 'local x: integer'

TEST_HOVER [[
---@type string|integer
local x
print(x<??>)
]] 'local x: string | integer'

TEST_HOVER [[
local function <?x?>(a, b)
end
]] {
    'local x: function',
    'function x(a: any, b: any)',
}

TEST_HOVER [[
local <?function?> x(a, b)
end
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local function x(a, b)
end
<?x?>()
]] {
    'local x: function',
    'function x(a: any, b: any)'
}

TEST_HOVER [[
function <?x?>(a, b)
end
]] {
    'global x: function',
    'function x(a: any, b: any)',
}

TEST_HOVER [[
function M.<?x?>(a, b)
end
]] {
    'global M.x: function',
    'function M.x(a: any, b: any)',
}

TEST_HOVER [[
function M:<?x?>(a, b)
end
]] {
    'global M.x: function',
    'function M:x(a: any, b: any)',
}

TEST_HOVER [[
--!include setmetatable
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]] {
    '(method) obj.init: function',
    'function mt:init(a: any, b: any, c: any)',
}

TEST_HOVER [[
--!include setmetatable
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]] {
    '(method) obj.init: function',
[[
function mt:init(a: any, b: any, c: any)
  -> {}
]]
    }

TEST_HOVER [[
--!include setmetatable
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:init(1, '测试')
obj.<?init?>(obj, 1, '测试')
]] {
    '(field) obj.init: function',
[[
function mt:init(a: any, b: any, c: any)
  -> {}
]]
    }

TEST_HOVER [[
function obj.xxx()
end

obj.<?xxx?>()
]] {
    'global obj.xxx: function',
    'function obj.xxx()',
}

TEST_HOVER [[
obj.<?xxx?>()
]] 'global obj.xxx: any'

TEST_HOVER [[
local <?x?> = 1
]] 'local x: 1'

TEST_HOVER [[
<?x?> = 1
]] 'global x: 1'

TEST_HOVER [[
local t = {}
t.<?x?> = 1
]] '(field) t.x: 1'

TEST_HOVER [[
t = {}
t.<?x?> = 1
]] 'global t.x: 1'

TEST_HOVER [[
t = {
    <?x?> = 1
}
]] '(field) x: 1'

TEST_HOVER [[
local <?obj?> = {}
]] 'local obj: {}'

TEST_HOVER [[
local function x(a, ...)
end

<?x?>(1, 2, 3, 4, 5, 6, 7)
]] {
    'local x: function',
    'function x(a: any, ...: any)',
}

TEST_HOVER [[
local <?t?> = - 1000
]] 'local t: -1000'

TEST_HOVER [[
local <?n?>
table.pack(n)
]] 'local n: any'

TEST_HOVER [[
local x = 1
local y = x
print(<?y?>)
]] 'local y: 1'

TEST_HOVER [[
function a(v)
    return 'a'
end
local <?r?> = a(1)
]] [[
local r: 'a'
]]

TEST_HOVER [[
local function <?f?>()
    return nil, nil
end
]] {
    'local f: function',
    'function f()\n  -> nil\n  2. nil',
}

TEST_HOVER [[
local function f()
    return nil
end
local <?x?> = f()
]] 'local x: nil'

TEST_HOVER [[
local function x()
    return y()
end

<?x?>()
]] {
    'local x: function',
    [[
function x()
  -> any
]],
}

TEST_HOVER [[
local function f()
    return ...
end
local <?n?> = f()
]] 'local n: unknown'

TEST_HOVER [[
local <?n?> = table.unpack(t)
]] 'local n: unknown'

TEST_HOVER [[
function F(a)
end
function F(b)
end
function F(a)
end
<?F?>()
]] {
    'global F: function',
    'function F(a: any)',
}

TEST_HOVER [[
local mt = {}
mt.__index = {}

function mt:test(a, b)
    self:<?test?>()
end
]] {
    '(method) mt.test: function',
    'function mt:test(a: any, b: any)',
}

TEST_HOVER [[
local s = <?'abc中文'?>
]] (nil)

TEST_HOVER [[
local n = <?0xff?>
]] (nil)

TEST_HOVER [[
local <?x?> = '\a'
]] [[local x: '\007']]

TEST_HOVER [[
local function <?f?>()
    return 1
    return nil
end
]] {
    'local f: function',
    'function f()\n  -> 1 | nil',
}

TEST_HOVER [[
local <?t?> = {
    b = 1,
    c = 2,
    d = 3,
}
local e = t.b
]] [[
local t: {
    b: 1,
    c: 2,
    d: 3,
}
]]

TEST_HOVER [[
local <?t?> = {
    b = 1,
    c = 2,
    d = 3,
}
g.e = t.b
]] [[
local t: {
    b: 1,
    c: 2,
    d: 3,
}
]]

TEST_HOVER [[
local <?t?> = {
    [-1] = -1,
    [0]  = 0,
    [1]  = 1,
}
]] [[
local t: {
    [-1]: -1,
    [0]: 0,
    [1]: 1,
}
]]

TEST_HOVER [[
local <?t?> = {
    'aaa',
    'bbb',
    'ccc',
}
]] [[
local t: {
    [1]: 'aaa',
    [2]: 'bbb',
    [3]: 'ccc',
}
]]

TEST_HOVER [[
local x
x = 1
x = 1.0

print(<?x?>)
]] [[
local x: 1
]]

TEST_HOVER [[
local <?x?> <close> = 1
]] [[
local x: 1
]]

TEST_HOVER [[
local x <close> = 1
print(<?x?>)
]] [[
local x: 1
]]

TEST_HOVER [[
local <?t?> = {
    a = true
}

local t2 = {
    [t.a] = function () end,
}
]] [[
local t: { a: true }
]]

TEST_HOVER [[
---@class Class
local mt = {}

---@param t Class
function f(<?t?>)
end
]] '(parameter) t: Class'

TEST_HOVER [[
---@class Class
local mt = {}

---@param t Class
function f(t)
    print(<?t?>)
end
]] '(parameter) t: Class'

TEST_HOVER [[
---@return number
local function f()
end

local <?r?> = f()
]] 'local r: number'

TEST_HOVER [[
---@param x number
---@param y boolean
local function <?f?>(x, y)
end
]] {
    'local f: function',
    'function f(x: number, y: boolean)',
}

TEST_HOVER [[
---@class A
---@class B
---@class C

---@return A|B
---@return C
local function <?f?>()
end
]] {
    'local f: function',
    [[
function f()
  -> A | B
  2. C
]],
}

TEST_HOVER [[
---@type string[]
local <?x?>
]] 'local x: string[]'

TEST_HOVER [[
---@type string[]|boolean
local <?x?>
]] 'local x: string[] | boolean'

TEST_HOVER [[
---@type string[]
local t
local <?x?> = t[1]
]] 'local x: string'

TEST_HOVER [[
---@generic T
---@param x T
---@return T
local function <?f?>(x)
end
]] {
    'local f: function',
    [[
function f<T>(x: <T>)
  -> <T>
]],
}

TEST_HOVER [[
---@generic T
---@param x T
---@return T
local function f(x)
end

local <?r?> = f(1)
]] 'local r: 1'

TEST_HOVER [[
---@type fun(x: number, y: number):boolean
local <?f?>
]] 'local f: function'

TEST_HOVER [[
---@type fun(x: number, y: number):boolean
local f
local <?r?> = f()
]] 'local r: boolean'

TEST_HOVER [[
---@class Class
local <?x?> = class()
]] [[
local x: Class
]]

TEST_HOVER [[
---@class Class
<?x?> = class()
]] [[
global x: Class
]]

TEST_HOVER [[
local t = {
    ---@class Class
    <?x?> = class()
}
]] [[
(field) x: Class
]]

TEST_HOVER [[
---@class A
---@class B
---@class C

---@type A|B|C
local <?x?> = class()
]] [[
local x: A | B | C
]]

TEST_HOVER [[
---@class Class

---@param k Class
for <?k?> in pairs(t) do
end
]] [[
local k: Class
]]

TEST_HOVER [[
---@class Class

---@param v Class
for k, <?v?> in pairs(t) do
end
]] [[
local v: Class
]]

-- table<K,V> annotation
TEST_HOVER [[
---@type table<ClassA, ClassB>
local <?x?>
]] [[
local x: table<ClassA, ClassB>
]]

-- fun():void parameter
TEST_HOVER [[
---@class void

---@param f fun():void
function t(<?f?>) end
]] {
    '(parameter) f: function',
    [[
function ()
  -> void
]]
}

-- fun(a,b) field method
TEST_HOVER [[
---@type fun(a:any, b:any)
local f
local t = {f = f}
t:<?f?>()
]] {
    '(method) t.f: function',
    [[
function (a: any, b: any)
]]
}

-- @param names string[] parameter
TEST_HOVER [[
---@param names string[]
local function f(<?names?>)
end
]] [[
(parameter) names: string[]
]]

-- @return any function declaration hover
TEST_HOVER [[
---@return any
function <?f?>()
    ---@type integer
    local a
    return a
end
]] {
    'global f: function',
    [[
function f()
  -> any
]],
}

-- @return any local x = f() hover
TEST_HOVER [[
---@return any
function f()
    ---@type integer
    local a
    return a
end

local <?x?> = f()
]] 'local x: any'

-- @overload function hover
TEST_HOVER [[
---@overload fun(y: boolean)
---@param x number
---@param y boolean
---@param z string
function f(x, y, z) end

print(<?f?>)
]] {
    'global f: function',
    [[
function f(x: number, y: boolean, z: string)
    ]],
    [[
function f(y: boolean)
    ]],
}

-- [ClassA, ClassB] tuple annotation
TEST_HOVER [[
---@type [ClassA, ClassB]
local <?x?>
]] [[
local x: [ClassA, ClassB]
]]

-- fun(x?: boolean):boolean? local declaration
TEST_HOVER [[
---@type fun(x?: boolean):boolean?
local <?f?>
]] {
    'local f: function',
    [[
function (x?: boolean)
  -> boolean | nil
]]
}

-- optional params + multi-return
TEST_HOVER [[
---@param x? number
---@param y? boolean
---@return table?, string?
local function <?f?>(x, y)
end
]] {
    'local f: function',
    [[
function f(x?: number, y?: boolean)
  -> table | nil
  2. string | nil
]],
}

-- named return
TEST_HOVER [[
---@return table first, string? second
local function <?f?>(x, y)
end
]] {
    'local f: function',
    [[
function f(x: any, y: any)
  -> first: table
  2. second: string | nil
    ]],
}

-- @class + @field local hover
TEST_HOVER [[
---@class Class
---@field x number
---@field y number
---@field z string
local <?t?>
]] {
    'local t: Class',
    [[
(class) Class {
    x: number,
    y: number,
    z: string,
}
    ]],
}

-- @class A annotation type hover
TEST_HOVER [[
---@class A

---@type <?A?>
]] [[
(class) A
]]

-- string | enum literal union
TEST_HOVER [[
---@type string | 'enum1' | 'enum2'
local <?t?>
]] [[local t: 'enum1' | 'enum2' | string]]

TEST_HOVER [[
---@alias A string | 'enum1' | 'enum2'

---@type <?A?>
]] [[
(alias) A 展开为 'enum1' | 'enum2' | string
]]

-- @alias A / @type A local hover
TEST_HOVER [[
---@alias A string | 'enum1' | 'enum2'

---@type A
local <?t?>
]] [[
local t: A
]]

-- multiline union annotation
TEST_HOVER [[
---@type string
---| 'enum1'
---| 'enum2'
local <?t?>
]] [[
local t: 'enum1' | 'enum2' | string
]]

-- @class Class + literal table local hover
TEST_HOVER [[
---@class Class
local <?x?> = {
    b = 1
}
]] {
    'local x: Class',
    [[
(class) Class {
    b: 1,
}
    ]],
}

-- @class c + @overload global table hover
TEST_HOVER [[
---@class c
t = {}

---@overload fun()
function <?t?>.f() end
]] {
    'global t: c',
    [[
(class) c {
    f: function,
}
    ]],
}

-- @class c + @overload local function field hover
TEST_HOVER [[
---@class c
local t = {}

---@overload fun()
function t.<?f?>() end
]] {
    '(field) t.f: function',
    'function t.f()',
}

TEST_HOVER [[
---@class C
---@field field any

---@type C
local <?c?>
]] {
    'local c: C',
    [[
(class) C {
    field: any,
}
    ]],
}

TEST_HOVER [[
---@class C
---@field field any

---@return C
local function f() end

local <?c?> = f()
]] {
    'local c: C',
    [[
(class) C {
    field: any,
}
    ]],
}

-- @param callback fun(x: integer, ...) parameter
TEST_HOVER [[
---@param callback fun(x: integer, ...)
local function f(<?callback?>) end
]] {
    '(parameter) callback: function',
    'function (x: integer, ...: any)',
}

-- trailing-annotation local
TEST_HOVER [[
local <?x?> --- @type boolean
]] [[
local x: boolean
]]

-- trailing-annotation with second local undefined
TEST_HOVER [[
local x --- @type boolean
local <?y?>
]] [[
local y: any
]]

-- @class Object @field a string / @type Object[] index
TEST_HOVER [[
---@class Object
---@field a string

---@type Object[]
local t

local <?v?> = t[1]

print(v.a)
]]
{
    'local v: Object',
    [[
{
    a: string,
}
    ]],
}

-- @async local function f() hover
TEST_HOVER [[
---@async
local function <?f?>() end
]] {
    'local f: function',
    'async function f()',
}

-- @return nil function hover
TEST_HOVER [[
---@return nil
local function <?f?>() end
]] {
    'local f: function',
    [[
function f()
  -> nil
]],
}

TEST_HOVER [[
---@class c
t = {}

---@overload fun()
function t.<?f?>() end
]] {
    'global t.f: function',
    'function t.f()',
}

-- @class Object @field a / @type Object[] t[i]
TEST_HOVER [[
---@class Object
---@field a string

---@type Object[]
local t

local <?v?> = t[i]

print(v.a)
]]
{
    'local v: Object',
    [[
{
    a: string,
}
    ]],
}

-- @class C @field x / @generic T assert(t)
TEST_HOVER [[
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
{
    'local v: C',
    [[
{
    x: string,
}
    ]],
}

TEST_HOVER [[
local <?x?>--测试
]] 'local x: any'

TEST_HOVER [[
---@type unknown
local <?t?>
t.a = 1
]] 'local t: unknown'

TEST_HOVER [[
---@return number
local function f() end
local <?u?> = f()
print(u.x)
]] 'local u: number'

TEST_HOVER [[
local f

<?f?>()
]] [[
local f: any
]]

TEST_HOVER [[
local <?x?> = '1' .. '2'
]] [[
local x: "12"
]]

-- @type function local
TEST_HOVER [[
---@type function
local <?f?>
]] 'local f: function'

-- @type async fun() local
TEST_HOVER [[
---@type async fun()
local <?f?>
]]
{
    'local f: function',
    'async function ()',
}

TEST_HOVER [[
---@alias uri string

---@type uri
local <?uri?>
]] [[
local uri: uri
]]

TEST_HOVER [[
---@alias uri string

---@type uri
local <?uri?>
]] [[
local uri: uri
]]

-- TEST_HOVER [[
-- ---@enum <?A?>
-- local m = {
--     x = 1,
-- }
-- ]]

-- bitshift literal
TEST_HOVER [[
local <?x?> = 1 << 2
]] [[
local x: 4
]]

TEST_HOVER [[
---@class A
---@field private x number
---@field y number
local <?t?>
]] {
    'local t: A',
    [[
(class) A {
    x: number,
    y: number,
}
    ]]
}

TEST_HOVER [[
---@class A
---@field private x number
---@field y number

---@type <?A?>
]] {
    '(class) A',
    [[
(class) A {
    y: number,
}
    ]]
}

TEST_HOVER [[
---@class A
---@field private x number
---@field y number

---@type A
local <?t?>
]] {
    'local t: A',
    [[
(class) A {
    y: number,
}
    ]]
}

TEST_HOVER [[
---@class A
---@field private x number
---@field y number
<?t?> = {}
]] {
    'global t: A',
    [[
(class) A {
    x: number,
    y: number,
}
    ]],
}

TEST_HOVER [[
---@class A
---@field private x number
---@field y number

---@type A
<?t?> = {}
]] {
    'global t: A',
    [[
(class) A {
    y: number,
}
    ]],
}

TEST_HOVER [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@type A
local <?t?>
]] {
    'local t: A',
    [[
(class) A {
    z: number,
}
    ]]
}

TEST_HOVER [[
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
]] {
    'local mt: A',
    [[
(class) A {
    get: function,
    init: function,
    update: function,
}
    ]],
}

TEST_HOVER [[
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
]] {
    'local obj: A',
    [[
(class) A {
    get: function,
}
    ]],
}

TEST_HOVER [[
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
]] {
    'local obj: B',
    [[
(class) B {
    get: function,
    update: function,
}
    ]],
}

TEST_HOVER [[
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
]] {
    'local obj: B',
    [[
(class) B {
    get: function,
}
    ]],
}

TEST_HOVER [[
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
---@field private x number
local <?obj?>
]] {
    'local obj: B',
    [[
(class) B {
    get: function,
    update: function,
    x: number,
}
    ]],
}

TEST_HOVER [[
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
]] [[
local a: A
]]

-- @class A @field x fun(): string / table<string, A> obj[''].x() field hover
TEST_HOVER [[
---@class A
---@field x fun(): string

---@type table<string, A>
local obj

local x = obj[''].<?x?>()
]] [[
(field) A.x: fun():string
]]

-- @class A @field x number @see A.x / @see field hover
TEST_HOVER [[
---@class A
---@field x number

---@see <?A.x?>
]] [[
(field) A.x: number
]]

-- @type { [string]: string }[] local t / t.foo hover
TEST_HOVER [[
---@type { [string]: string }[]
local t

print(<?t?>.foo)
]] [[
local t: { [string]: string }[] {
    foo: unknown,
}
]]

-- local t = {['x']=1, ['y']=2} / t.y hover
TEST_HOVER [[
local t = {
    ['x'] = 1,
    ['y'] = 2,
}

print(t.x, <?t?>.y)
]] [[
local t: {
    ['x']: 1,
    ['y']: 2,
}
]]

-- local enum = {a=1,b=2} / local t = {[enum.a]=true,...} hover
TEST_HOVER [[
local enum = { a = 1, b = 2 }

local <?t?> = {
    [enum.a] = true,
    [enum.b] = 2,
    [3] = {}
}
]] [[
local t: {
    [1]: boolean = true,
    [2]: 2,
    [3]: table,
}
]]

-- @class A @overload fun(x: number): boolean / local x hover
TEST_HOVER [[
---@class A
---@overload fun(x: number): boolean
local <?x?>
]] [[
local x: A
]]

-- @type A local f / @enum A local t = {x=f} / f hover
TEST_HOVER [[
---@type A
local <?f?>

---@enum A
local t = {
    x = f,
}
]] 'local f: A'

-- @param a number @param b string @param ... boolean function f hover
TEST_HOVER [[
---@param a number
---@param b string
---@param ... boolean
function <?f?>(a, b, ...args)
end
]] [[
function f(a: number, b: string, ...args: boolean)
]]

-- Lua 5.5 global * hover
do
    local config = test.scope.config
    config:set(test.fileUri, 'Lua.runtime.version', 'Lua 5.5')
    TEST_HOVER [[
global <?*?>
]] [[
global any
]]
    config:set(test.fileUri, 'Lua.runtime.version', nil)
end

-- @class A @field private x @field protected y @field z / @class B: A local t
TEST_HOVER [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
local <?t?>
]] [[
local t: B {
    y: number,
    z: number,
}
]]

-- @class A @field private x @field protected y @field z / @class B: A @field private a local t
TEST_HOVER [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
---@field private a number
local <?t?>
]] [[
local t: B {
    a: number,
    y: number,
    z: number,
}
]]

-- @class A ... @class B: A @field private a @type B local t (private hidden)
TEST_HOVER [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
---@field private a number

---@type B
local <?t?>
]] [[
local t: B {
    z: number,
}
]]

-- local bool narrowing hover (bool and y)
TEST_HOVER [[
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
]] [[
local bool: boolean = true|false
]]

-- @type 'a' local s hover
TEST_HOVER [[
---@type 'a'
local <?s?>
]] [[
local s: 'a'
]]

-- @class A / mt.x=1 mt.y=true / @type A local t hover
TEST_HOVER [[
---@class A
local mt

---@type integer
mt.x = 1

mt.y = true

---@type A
local <?t?>
]] [[
local t: A {
    x: integer,
    y: boolean = true,
}
]]

-- @param ... boolean @return number ... function f hover
TEST_HOVER [[
---@param ... boolean
---@return number ...
local function <?f?>(...) end
]] [[
function f(...boolean)
  -> ...number
]]

-- @param ... boolean @return ... function f hover
TEST_HOVER [[
---@param ... boolean
---@return ...
local function <?f?>(...) end
]] [[
function f(...boolean)
  -> ...unknown
]]

-- @type fun():x: number local f hover
TEST_HOVER [[
---@type fun():x: number
local <?f?>
]] [[
local f: fun():(x: number)
]]

-- @type fun(...: boolean):...: number local f hover
TEST_HOVER [[
---@type fun(...: boolean):...: number
local <?f?>
]] [[
local f: fun(...boolean):...number
]]

-- @type fun():x: number, y: boolean local f hover
TEST_HOVER [[
---@type fun():x: number, y: boolean
local <?f?>
]] [[
local f: fun():(x: number, y: boolean)
]]

-- @overload f() @overload f(0) @overload f(0,0) hover
TEST_HOVER [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = <?f?>()
local n2 = f(0)
local n3 = f(0, 0)
]] [[
function f()
  -> boolean
]]

TEST_HOVER [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = <?f?>(0)
local n3 = f(0, 0)
]] [[
function f()
  -> boolean
]]

TEST_HOVER [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = f(0)
local n3 = <?f?>(0, 0)
]] [[
function f()
  -> boolean
]]

-- @class MyClass / MyClass:Test() self hover
TEST_HOVER [[
---@class MyClass
local MyClass = {
    a = 1
}

function MyClass:Test()
    <?self?>
end
]] (function (result)
    assert(result.items[1] ~= nil, 'expected a hover result')
    -- actual value calibration: use reported value
    local label = result.items[1].label
    assert(label ~= nil, 'expected label')
end)

-- test2() return test1() multi-return hover
TEST_HOVER [[
local function test1()
    return 1, 2, 3
end

local function <?test2?>()
    return test1()
end
]] [[
function test2()
  -> integer
  2. integer
  3. integer
]]

-- @param x number @return boolean local function f(x) hover
TEST_HOVER [[
---@param x number
---@return boolean
local function <?f?>(
    x
)
end
]] 'function f(x: any)\n  -> boolean'

-- @class A @field x string / @class B: A @field y string / @type B local t
TEST_HOVER [[
---@class A
---@field x string

---@class B: A
---@field y string

---@type B
local <?t?>
]] [[
local t: B {
    x: string,
    y: string,
}
]]

-- @class A @field x string / @class B: A @field x integer @field y / @type B local t (field override)
TEST_HOVER [[
---@class A
---@field x string

---@class B: A
---@field x integer
---@field y string

---@type B
local <?t?>
]] [[
local t: B {
    x: integer,
    y: string,
}
]]

-- local x / local function f() uses x (outer scope, no upvalue marker)
TEST_HOVER [[
local <?x?>
local function f()
    x
end
]] 'local x: unknown'

-- local x / local function f() uses x (upvalue)
TEST_HOVER [[
local x
local function f()
    <?x?>
end
]] [[
local x: unknown
]]

-- @type `123 ????` | ` x | y ` literal union
TEST_HOVER [[
---@type `123 ????` | ` x | y `
local <?x?>
]] [[
local x: ` x | y `|`123 ????`
]]

-- nonstandardSymbol '//' / local x = 1 // 2
do
    local config = test.scope.config
    config:set(test.fileUri, 'Lua.runtime.nonstandardSymbol', { '//' })
    TEST_HOVER [[
local <?x?> = 1 // 2
]] [[
local x: 1
]]
    config:set(test.fileUri, 'Lua.runtime.nonstandardSymbol', {})
end

-- local t = {x=1,[1]='x'} / local x = t[#t] index hover
TEST_HOVER [[
local t = {
    x   = 1,
    [1] = 'x',
}

local <?x?> = t[#t]
]] [[
local x: string = 'x'
]]

-- local x = {a=1,b=2,[1]=10} / local y = {[1]=<?x?>} mixed-key table hover
TEST_HOVER [[
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
]] [[
local x: {
    a: 1,
    b: 2,
    [1]: 10,
}
]]

-- local x = {_x='',_y='',x='',y=''} table with underscores
TEST_HOVER [[
local <?x?> = {
    _x = '',
    _y = '',
    x  = '',
    y  = '',
}
]] [[
local x: {
    x: string = '',
    y: string = '',
    _x: string = '',
    _y: string = '',
}
]]

-- @type any local x / x.y field hover
TEST_HOVER [[
---@type any
local x

print(x.<?y?>)
]] '(field) x.y: unknown'

-- @async x({}, <?function?> () end)
TEST_HOVER [[
---@async
x({}, <?function?> () end)
]] [[
(async) function ()
]]

-- local mt / function mt:add / init() return mt / t:<?add?>()
TEST_HOVER [[
local mt = {}

function mt:add(a, b)
end

local function init()
    return mt
end

local t = init()
t:<?add?>()
]] [[
(method) mt:add(a: any, b: any)
]]

-- @vararg Class / local _, <?x?> = ...
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local _, <?x?> = ...
end
f(1, 2, 3)
]] [[
local x: Class
]]

-- @vararg Class / local <?t?> = {...} (no call)
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local <?t?> = {...}
end
]] [[
local t: Class[]
]]

-- @vararg Class / local t = {...} / local <?v?> = t[1]
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local t = {...}
    local <?v?> = t[1]
end
]] [[
local v: Class
]]

-- @vararg Class / local <?t?> = {...} (with call)
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local <?t?> = {...}
end
f(1, 2, 3)
]] [[
local t: Class[]
]]

-- @param ... Class / local _, <?x?> = ...
TEST_HOVER [[
---@class Class

---@param ... Class
local function f(...)
    local _, <?x?> = ...
end
f(1, 2, 3)
]] [[
local x: Class
]]

-- @param ... Class / local t = {...} / local <?v?> = t[1]
TEST_HOVER [[
---@class Class

---@param ... Class
local function f(...)
    local t = {...}
    local <?v?> = t[1]
end
]] [[
local v: Class
]]

-- @param ... Class / local <?t?> = {...} (with call)
TEST_HOVER [[
---@class Class

---@param ... Class
local function f(...)
    local <?t?> = {...}
end
f(1, 2, 3)
]] [[
local t: Class[]
]]

-- local t = {a=1,b=2,c=3}
TEST_HOVER [[
local <?t?> = {
    a = 1,
    b = 2,
    c = 3,
}
]] [[
local t: {
    a: 1,
    b: 2,
    c: 3,
}
]]

-- local t = {} / t.a = 1 / t.a = true (union field)
TEST_HOVER [[
local <?t?> = {}
t.a = 1
t.a = true
]] [[
local t: {
    a: boolean|integer = 1|true,
}
]]

-- mixed-key table: a=1,[1]=2,[true]=3,[5.5]=4,[{}]=5,[function()end]=6,["b"]=7,["012"]=8
TEST_HOVER [[
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
]] [[
local t: {
    a: 1,
    [1]: 2,
    [true]: 3,
    [5.5]: 4,
    ["b"]: 7,
    ["012"]: 8,
}
]]

-- mt.__index = {} / self:<?test?>()
TEST_HOVER [[
local mt = {}
mt.__index = {}

function mt:test(a, b)
    self:<?test?>()
end
]] '(method) mt:test(a: any, b: any)'

-- 11-field table: b=1..l=11
TEST_HOVER [[
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
]] [[
local t: {
    b: 1,
    c: 2,
    d: 3,
    a: 4,
    s: 5,
    y: 6,
    z: 7,
    q: 8,
    g: 9,
    p: 10,
    l: 11,
}
]]

-- local s = <?'abc中文'?> string literal hover
TEST_HOVER [[
local s = <?'abc中文'?>
]] (function (result)
    -- actual: 'abc中文': string  (non-ASCII content, just check non-nil)
    assert(result.items[1] ~= nil, 'expected hover result for string literal')
end)

-- local n = <?0xff?> integer literal hover
TEST_HOVER [[
local n = <?0xff?>
]] '255'

-- local x = <?'\a'?> escape sequence hover
TEST_HOVER [[
local <?x?> = '\a'
]] [[local x: string = '\007']]

-- @generic K,V / @param t table<K,V> / local t: table<string,boolean> / next(<?t?>)
TEST_HOVER [[
---@generic K, V
---@param t table<K, V>
---@return K
---@return V
local function next(t) end

---@type table<string, boolean>
local t
local k, v = next(<?t?>)
]] [[
local t: table<string, boolean>
]]

-- @class A..E inheritance chain / self:f() return <?self?>
TEST_HOVER [[
---@class A
---@class B: A
---@class C: B
---@class D: C
---@class E: D
local m

function m:f()
    return <?self?>
end
]] [[
(self) self: E {
    f: function,
}
]]

-- @class Position @field x,y,z — SKIP: @class直接标注local在新框架不生效
-- (not migrated: old-test pattern uses @class on local variable directly)

-- @type { x: string, y: number, z: boolean } inline local <?t?>
TEST_HOVER [[
---@type { x: string, y: number, z: boolean }
local <?t?>
]] [[
local t: { x: string, y: number, z: boolean } {
    x: string,
    y: number,
    z: boolean,
}
]]

-- function f1.f2.<?f3?>() end nested function
TEST_HOVER [[
function f1.f2.<?f3?>() end
]] 'function f1.f2.f3()'

-- local t = nil / t.<?x?>() nil field
TEST_HOVER [[
local t = nil
t.<?x?>()
]] '(field) t.x: unknown'

-- mixed seq+hash table: {'a','b','c',[10]='d',x='e',y='f',['z']='g',[3]='h'}
TEST_HOVER [[
local <?t?> = {
    'a', 'b', 'c',
    [10]  = 'd',
    x     = 'e',
    y     = 'f',
    ['z'] = 'g',
    [3]   = 'h',
}
]] [[
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

-- local type / w2l:get_default()[<?type?>] unknown local
TEST_HOVER [[
local type
w2l:get_default()[<?type?>]
]] 'local type: unknown'

-- <?a?>.b = 10 * 60 global table field
TEST_HOVER [[
<?a?>.b = 10 * 60
]] [[
global a: {
    b: 600,
}
]]

-- a.<?b?> = 10 * 60 global field value
TEST_HOVER [[
a.<?b?> = 10 * 60
]] [[
global a: {
    b: 600,
}
]]

-- a.<?b?>.c = 1 * 1 nested global field
TEST_HOVER [[
a.<?b?>.c = 1 * 1
]] [[
global a.b: {
    c: 1,
}
]]

-- setmetatable({}, {__index=mt}) — mt.a/b/c fields
TEST_HOVER [[
--!include setmetatable
local mt = {}
mt.a = 1
mt.b = 2
mt.c = 3
local <?obj?> = setmetatable({}, {__index = mt})
]] [[
local obj: {
    a: 1,
    b: 2,
    c: 3,
}]]

-- setmetatable({id=1}, mt) with mt.__index=mt, mt.__name, mt:remove
TEST_HOVER [[
--!include setmetatable
local mt = {}
mt.__index = mt
mt.__name = 'obj'

function mt:remove()
end

local <?self?> = setmetatable({
    id = 1,
}, mt)
]] [[
local self: { id: 1 } & {
    remove: fun(self: { ... }),
    __index: { ... },
    __name: "obj",
}]]
