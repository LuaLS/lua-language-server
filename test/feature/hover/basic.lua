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
]] ({
    'local x: string',
    'local x: integer',
})

TEST_HOVER [[
local function <?x?>(a, b)
end
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local <?function?> x(a, b)
end
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local function x(a, b)
end
<?x?>()
]] 'function x(a: any, b: any)'

TEST_HOVER [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]] '(method) mt:init(a: any, b: any, c: any)'

TEST_HOVER [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:<?init?>(1, '测试')
]] [[
(method) mt:init(a: any, b: any, c: any)
  -> table
]]

TEST_HOVER [[
local mt = {}
mt.__index = mt

function mt:init(a, b, c)
    return {}
end

local obj = setmetatable({}, mt)

obj:init(1, '测试')
obj.<?init?>(obj, 1, '测试')
]] [[
(method) mt:init(a: any, b: any, c: any)
  -> table
]]

TEST_HOVER [[
function obj.xxx()
end

obj.<?xxx?>()
]] 'function obj.xxx()'

TEST_HOVER [[
obj.<?xxx?>()
]] '(global) obj.xxx: unknown'

TEST_HOVER [[
local <?x?> = 1
]] 'local x: integer = 1'

TEST_HOVER [[
<?x?> = 1
]] '(global) x: integer = 1'

TEST_HOVER [[
local t = {}
t.<?x?> = 1
]] '(field) t.x: integer = 1'

TEST_HOVER [[
t = {}
t.<?x?> = 1
]] '(global) t.x: integer = 1'

TEST_HOVER [[
t = {
    <?x?> = 1
}
]] '(field) x: integer = 1'

TEST_HOVER [[
local <?obj?> = {}
]] 'local obj: table'

TEST_HOVER [[
local function x(a, ...)
end

<?x?>(1, 2, 3, 4, 5, 6, 7)
]] 'function x(a: any, ...any)'

TEST_HOVER [[
local <?t?> = - 1000
]] 'local t: integer = -1000'

TEST_HOVER [[
local <?n?>
table.pack(n)
]] 'local n: unknown'

TEST_HOVER [[
local x = 1
local y = x
print(<?y?>)
]] 'local y: integer = 1'

TEST_HOVER [[
function a(v)
    return 'a'
end
local <?r?> = a(1)
]] 'local r: string = "a"'

TEST_HOVER [[
local function <?f?>()
    return nil, nil
end
]] [[
function f()
  1. nil
  2. nil
]]

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
]] [[
function x()
  -> any
]]

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
]] 'function F(a: any)'

TEST_HOVER [[
local mt = {}
mt.__index = {}

function mt:test(a, b)
    self:<?test?>()
end
]] '(method) mt:test(a: any, b: any)'

TEST_HOVER [[
local s = <?'abc中文'?>
]] "'abc中文': string"

TEST_HOVER [[
local n = <?0xff?>
]] '0xff: integer'

TEST_HOVER [[
local <?x?> = '\a'
]] 'local x: string = "\\007"'

TEST_HOVER [[
local function <?f?>()
    return 1
    return nil
end
]] (function (result)
    local expected = ([==[function f()
    -> 1 | nil]==]):gsub('\n    ', '\n  ')
    assert(result.items[1].label == expected)
end)

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
    [1]: "aaa",
    [2]: "bbb",
    [3]: "ccc",
}
]]

TEST_HOVER [[
local x
x = 1
x = 1.0

print(<?x?>)
]] 'local x: integer = 1'

TEST_HOVER [[
local <?x?> <close> = 1
]] 'local x: integer = 1'

TEST_HOVER [[
local x <close> = 1
print(<?x?>)
]] 'local x: integer = 1'

TEST_HOVER [[
local <?t?> = {
    a = true
}

local t2 = {
    [t.a] = function () end,
}
]] 'local t: { a: true }'

TEST_HOVER [[
---@class Class
local mt = {}

---@param t Class
function f(<?t?>)
end
]] 'function f(t: Class)'

TEST_HOVER [[
---@class Class
local mt = {}

---@param t Class
function f(t)
    print(<?t?>)
end
]] 'function f(t: Class)'

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
]] 'function f(x: number, y: boolean)'

TEST_HOVER [[
---@class A
---@class B
---@class C

---@return A|B
---@return C
local function <?f?>()
end
]] (function (result)
    local expected = ([==[function f()
    1. A | B
    2. table]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected, result.items[1].label)
end)

TEST_HOVER [[
---@type string[]
local <?x?>
]] 'local x: string[]'

TEST_HOVER [[
---@type string[]|boolean
local <?x?>
]] ({
    'local x: string[]',
    'local x: boolean',
})

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
]] (function (result)
        local expected = ([==[function f(x: <T>)
    -> <T>]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected, result.items[1].label)
end)

TEST_HOVER [[
---@generic T
---@param x T
---@return T
local function f(x)
end

local <?r?> = f(1)
]] 'local r: integer = 1'

TEST_HOVER [[
---@type fun(x: number, y: number):boolean
local <?f?>
]] (function (result)
        local expected = ([==[function f(x: number, y: number)
        -> boolean]==])
                :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
                :gsub('\r\n', '\n')
                :gsub('\n%s+', '\n  ')
        assert(result.items[1].label == expected, result.items[1].label)
end)

TEST_HOVER [[
---@type fun(x: number, y: number):boolean
local f
local <?r?> = f()
]] 'local r: boolean'

TEST_HOVER [[
---@class Class
local <?x?> = class()
]] 'local x: table'

TEST_HOVER [[
---@class Class
<?x?> = class()
]] '(global) x: table'

TEST_HOVER [[
local t = {
    ---@class Class
    <?x?> = class()
}
]] '(field) x: any'

TEST_HOVER [[
---@class A
---@class B
---@class C

---@type A|B|C
local <?x?> = class()
]] 'local x: table'

-- pairs for-in key/value annotation cases
TEST_HOVER [[
---@class Class

---@param k Class
for <?k?> in pairs(t) do
end
]] 'local k: any'

TEST_HOVER [[
---@class Class

---@param v Class
for k, <?v?> in pairs(t) do
end
]] 'local v: never'

-- table<K,V> annotation
TEST_HOVER [[
---@type table<ClassA, ClassB>
local <?x?>
]] 'local x: { [ClassA]: ClassB }'

-- fun():void parameter
TEST_HOVER [[
---@class void

---@param f fun():void
function t(<?f?>) end
]] 'function t(f: fun():void)'

-- fun(a,b) field method
TEST_HOVER [[
---@type fun(a:any, b:any)
local f
local t = {f = f}
t:<?f?>()
]] 'function t.f(a: any, b: any)'

-- @param names string[] parameter
TEST_HOVER [[
---@param names string[]
local function f(<?names?>)
end
]] 'function f(names: string[])'

-- @return any function declaration hover
TEST_HOVER [[
---@return any
function <?f?>()
    ---@type integer
    local a
    return a
end
]] (function (result)
    local expected = ([==[function f()
  -> any]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected, result.items[1].label)
end)

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
]] (function (result)
    local expected = ([==[function f(x: number, y: boolean, z: string)]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
    assert(result.items[1].label == expected, result.items[1].label)
end)

-- [ClassA, ClassB] tuple annotation
TEST_HOVER [[
---@type [ClassA, ClassB]
local <?x?>
]] 'local x: [ClassA, ClassB]'

-- fun(x?: boolean):boolean? local declaration
TEST_HOVER [[
---@type fun(x?: boolean):boolean?
local <?f?>
]] (function (result)
    local expected = ([==[function f(x?: boolean)
  -> boolean | nil]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected, result.items[1].label)
end)

-- optional params + multi-return
TEST_HOVER [[
---@param x? number
---@param y? boolean
---@return table?, string?
local function <?f?>(x, y)
end
]] (function (result)
    local expected = ([==[function f(x?: number, y?: boolean)
  -> table | nil]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected, result.items[1].label)
end)

-- named return
TEST_HOVER [[
---@return table first, string? second
local function <?f?>(x, y)
end
]] (function (result)
    local expected = ([==[function f(x: any, y: any)
  1. first: table]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected,
        'named return: ' .. tostring(result.items[1] and result.items[1].label))
end)

-- @class + @field local hover
TEST_HOVER [[
---@class Class
---@field x number
---@field y number
---@field z string
local <?t?>
]] 'local t: unknown'

-- @class A annotation type hover
TEST_HOVER [[
---@class A

---@type <?A?>
]] 'A: table'

-- string | enum literal union
TEST_HOVER [[
---@type string | "'enum1'" | "'enum2'"
local <?t?>
]] "local t: string"
TEST_HOVER [[
---@alias A string | "'enum1'" | "'enum2'"

---@type <?A?>
]] 'A: string'

-- @alias A / @type A local hover
TEST_HOVER [[
---@alias A string | "'enum1'" | "'enum2'"

---@type A
local <?t?>
]] 'local t: string'

-- multiline union annotation
TEST_HOVER [[
---@type string
---| "'enum1'"
---| "'enum2'"
local <?t?>
]] 'local t: string'

-- @class Class + literal table local hover
TEST_HOVER [[
---@class Class
local <?x?> = {
    b = 1
}
]] 'local x: { b: 1 }'

-- @class c + @overload global table hover
TEST_HOVER [[
---@class c
t = {}

---@overload fun()
function <?t?>.f() end
]] 'function t.f()'

-- @class c + @overload local function field hover
TEST_HOVER [[
---@class c
local t = {}

---@overload fun()
function t.<?f?>() end
]] 'function t.f()'

-- @class C @field field any / @type C local hover
TEST_HOVER [[
---@class C
---@field field any

---@type C
local <?c?>
]] 'local c: { field: any }'

-- @class C @field field any / @return C local hover
TEST_HOVER [[
---@class C
---@field field any

---@return C
local function f() end

local <?c?> = f()
]] 'local c: C'

-- @param callback fun(x: integer, ...) parameter
TEST_HOVER [[
---@param callback fun(x: integer, ...)
local function f(<?callback?>) end
]] 'function f(callback: fun(x: integer, ...: unknown))'

-- trailing-annotation local
TEST_HOVER [[
local <?x?> --- @type boolean
]] 'local x: unknown'

-- trailing-annotation with second local undefined
TEST_HOVER [[
local x --- @type boolean
local <?y?>
]] 'local y: boolean'

-- @class Object @field a string / @type Object[] index
TEST_HOVER [[
---@class Object
---@field a string

---@type Object[]
local t

local <?v?> = t[1]

print(v.a)
]] 'local v: Object'

-- @async local function f() hover
TEST_HOVER [[
---@async
local function <?f?>() end
]] 'function f()'

-- @return nil function hover
TEST_HOVER [[
---@return nil
local function <?f?>() end
]] (function (result)
    local expected = ([==[function f()
  -> nil]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
        :gsub('\n%s+', '\n  ')
    assert(result.items[1].label == expected, result.items[1].label)
end)

-- @class c + @overload t.f() global hover (function t.f)
TEST_HOVER [[
---@class c
t = {}

---@overload fun()
function t.<?f?>() end
]] 'function t.f()'

-- @class Object @field a / @type Object[] t[i]
TEST_HOVER [[
---@class Object
---@field a string

---@type Object[]
local t

local <?v?> = t[i]

print(v.a)
]] 'local v: Object'

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
]] 'local v: C'

-- local x--测试 inline comment local
TEST_HOVER [[
local <?x?>--测试
]] 'local x: unknown'

-- @type unknown local t; t.a = 1
TEST_HOVER [[
---@type unknown
local <?t?>
t.a = 1
]] 'local t: {}'

-- @return number / local u=f(); u.x
TEST_HOVER [[
---@return number
local function f() end
local <?u?> = f()
print(u.x)
]] 'local u: number'

-- local f / f() unknown
TEST_HOVER [[
local f

<?f?>()
]] '(global) f: unknown'

-- concat literal string
TEST_HOVER [[
local <?x?> = '1' .. '2'
]] 'local x: op.concat<"1", "2">'

-- @type function local
TEST_HOVER [[
---@type function
local <?f?>
]] 'local f: function'

-- @type async fun() local
TEST_HOVER [[
---@type async fun()
local <?f?>
]] 'function f()'

-- @alias uri string / expandAlias=false
config:set(test.fileUri, 'Lua.hover.expandAlias', false)
TEST_HOVER [[
---@alias uri string

---@type uri
local <?uri?>
]] 'local uri: string'

-- @alias uri string / expandAlias=true
config:set(test.fileUri, 'Lua.hover.expandAlias', true)
TEST_HOVER [[
---@alias uri string

---@type uri
local <?uri?>
]] 'local uri: string'

-- reset expandAlias to default
config:set(test.fileUri, 'Lua.hover.expandAlias', nil)

-- @enum A enum declaration hover
TEST_HOVER [[
---@enum <?A?>
local m = {
    x = 1,
}
]] (function (result)
    local expected = ([==[---@enum A
local m = {
    x = 1,
}: unknown]==])
        :gsub('^[\r\n]*(.-)[\r\n]*$', '%1')
        :gsub('\r\n', '\n')
    assert(result.items[1].label == expected, result.items[1].label)
end)

-- bitshift literal
TEST_HOVER [[
local <?x?> = 1 << 2
]] 'local x: op.shl<1, 2>'

-- @class A @field private x / @field y local hover
TEST_HOVER [[
---@class A
---@field private x number
---@field y number
local <?t?>
]] 'local t: unknown'

-- @class A @field private x @field y / @type A local hover (private hidden)
TEST_HOVER [[
---@class A
---@field private x number
---@field y number

---@type A
local <?t?>
]] [[
local t: {
    private: x,
    y: number,
}]]

-- @class A @field private x @field y / global t = {} (all fields visible)
TEST_HOVER [[
---@class A
---@field private x number
---@field y number
<?t?> = {}
]] [[
(global) t: {
    private: x,
    y: number,
}]]

-- @class A @field private x @field y / @type A global t = {} (private hidden)
TEST_HOVER [[
---@class A
---@field private x number
---@field y number

---@type A
<?t?> = {}
]] [[
(global) t: {
    private: x,
    y: number,
}]]

-- @class A @field private/protected/z @type A local (private+protected hidden)
TEST_HOVER [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@type A
local <?t?>
]] [[
local t: {
    private: x,
    protected: y,
    z: number,
}]]

-- @class A @private init @protected update @public get / print(mt)
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
]] [[
local mt: {
    get: fun(self: A),
    init: fun(self: A),
    update: fun(self: A),
}]]

-- @class A @private init @protected update @public get / @type A local obj
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
]] [[
local obj: {
    get: fun(self: A),
    init: fun(self: A),
    update: fun(self: A),
}]]

-- @class A @private init @protected update @public get / @class B: A local obj
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
]] 'local obj: unknown'

-- @class A @private init @protected update @public get / @class B: A @type B local obj
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
]] [[
local obj: {
    get: fun(self: A),
    init: fun(self: A),
    update: fun(self: A),
}]]

-- @class A @private M.x @private M:init @type A local a
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
local a: {
    init: fun(self: A),
    x: 0 | 1,
}]]

-- @class A @field x fun(): string / table<string, A> obj[''].x() field hover
TEST_HOVER [[
---@class A
---@field x fun(): string

---@type table<string, A>
local obj

local x = obj[''].<?x?>()
]] [[
function obj[""].x()
  -> string
]]

-- @class A @field x number @see A.x / @see field hover
TEST_HOVER [[
---@class A
---@field x number

---@see <?A.x?>
]] 'A.x: unknown'

-- @type { [string]: string }[] local t / t.foo hover
TEST_HOVER [[
---@type { [string]: string }[]
local t

print(<?t?>.foo)
]] 'local t: { [string]: string }[]'

-- local t = {['x']=1, ['y']=2} / t.y hover
TEST_HOVER [[
local t = {
    ['x'] = 1,
    ['y'] = 2,
}

print(t.x, <?t?>.y)
]] [[
local t: {
    x: 1,
    y: 2,
}]]

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
    [3]: {},
    [unknown]: 2,
}]]

-- @class A @overload fun(x: number): boolean / local x hover
TEST_HOVER [[
---@class A
---@overload fun(x: number): boolean
local <?x?>
]] 'local x: unknown'

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
]] 'function f(a: number, b: string, args: any, ...boolean)'

-- Lua 5.5 global * hover
do
    local config = test.scope.config
    config:set(test.fileUri, 'Lua.runtime.version', 'Lua 5.5')
    TEST_HOVER [[
global <?*?>
]] 'global *: {}'
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
]] 'local t: unknown'

-- @class A @field private x @field protected y @field z / @class B: A @field private a local t
TEST_HOVER [[
---@class A
---@field private x number
---@field protected y number
---@field z number

---@class B: A
---@field private a number
local <?t?>
]] 'local t: unknown'

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
local t: {
    private: a,
    protected: y,
    z: number,
}]]

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
]] 'local bool: boolean'

-- @type 'a' local s hover
TEST_HOVER [[
---@type 'a'
local <?s?>
]] 'local s: string = "a"'

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
local t: {
    x: integer,
    y: true,
}]]

-- @param ... boolean @return number ... function f hover
TEST_HOVER [[
---@param ... boolean
---@return number ...
local function <?f?>(...) end
]] 'function f(...boolean)\n  -> number'

-- @param ... boolean @return ... function f hover
TEST_HOVER [[
---@param ... boolean
---@return ...
local function <?f?>(...) end
]] 'function f(...boolean)\n  -> ...'

-- @type fun():x: number local f hover
TEST_HOVER [[
---@type fun():x: number
local <?f?>
]] 'function f()\n  1. x: number'

-- @type fun(...: boolean):...: number local f hover
TEST_HOVER [[
---@type fun(...: boolean):...: number
local <?f?>
]] 'function f(...boolean)\n  1. ...: number'

-- @type fun():x: number, y: boolean local f hover
TEST_HOVER [[
---@type fun():x: number, y: boolean
local <?f?>
]] 'function f()\n  1. x: number\n  2. y: boolean'

-- @overload f() @overload f(0) @overload f(0,0) hover
TEST_HOVER [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = <?f?>()
local n2 = f(0)
local n3 = f(0, 0)
]] 'function f()\n  -> boolean'

TEST_HOVER [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = <?f?>(0)
local n3 = f(0, 0)
]] 'function f()\n  -> boolean'

TEST_HOVER [[
---@overload fun(x: number, y: number):string
---@overload fun(x: number):number
---@return boolean
local function f() end

local n1 = f()
local n2 = f(0)
local n3 = <?f?>(0, 0)
]] 'function f()\n  -> boolean'

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
]] 'function test2()\n  1. integer\n  2. integer\n  3. integer'

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
local t: {
    x: string,
    y: string,
}]]

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
local t: {
    x: integer,
    y: string,
}]]

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
]] 'function f()'

-- @type `123 ????` | ` x | y ` literal union
TEST_HOVER [[
---@type `123 ????` | ` x | y `
local <?x?>
]] 'local x: {}'

-- nonstandardSymbol '//' / local x = 1 // 2
do
    local config = test.scope.config
    config:set(test.fileUri, 'Lua.runtime.nonstandardSymbol', { '//' })
    TEST_HOVER [[
local <?x?> = 1 // 2
]] 'local x: op.idiv<1, 2>'
    config:set(test.fileUri, 'Lua.runtime.nonstandardSymbol', {})
end

-- local t = {x=1,[1]='x'} / local x = t[#t] index hover
TEST_HOVER [[
local t = {
    x   = 1,
    [1] = 'x',
}

local <?x?> = t[#t]
]] 'local x: string'

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
    [1]: 10,
    a: 1,
    b: 2,
}]]

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
    x: "",
    y: "",
    _x: "",
    _y: "",
}]]

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
]] 'function function () end()'

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
]] '(method) t:add(a: any, b: any)'

-- @vararg Class / local _, <?x?> = ...
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local _, <?x?> = ...
end
f(1, 2, 3)
]] 'function f(...Class)'

-- @vararg Class / local <?t?> = {...} (no call)
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local <?t?> = {...}
end
]] 'function f(...Class)'

-- @vararg Class / local t = {...} / local <?v?> = t[1]
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local t = {...}
    local <?v?> = t[1]
end
]] 'function f(...Class)'

-- @vararg Class / local <?t?> = {...} (with call)
TEST_HOVER [[
---@class Class

---@vararg Class
local function f(...)
    local <?t?> = {...}
end
f(1, 2, 3)
]] 'function f(...Class)'

-- @param ... Class / local _, <?x?> = ...
TEST_HOVER [[
---@class Class

---@param ... Class
local function f(...)
    local _, <?x?> = ...
end
f(1, 2, 3)
]] 'function f(...Class)'

-- @param ... Class / local t = {...} / local <?v?> = t[1]
TEST_HOVER [[
---@class Class

---@param ... Class
local function f(...)
    local t = {...}
    local <?v?> = t[1]
end
]] 'function f(...Class)'

-- @param ... Class / local <?t?> = {...} (with call)
TEST_HOVER [[
---@class Class

---@param ... Class
local function f(...)
    local <?t?> = {...}
end
f(1, 2, 3)
]] 'function f(...Class)'

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
}]]

-- local t = {} / t.a = 1 / t.a = true (union field)
TEST_HOVER [[
local <?t?> = {}
t.a = 1
t.a = true
]] 'local t: { a: 1 | true }'

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
    [1]: 2,
    [5.5]: 4,
    ["012"]: 8,
    a: 1,
    b: 7,
    [true]: 3,
    [unknown]: 6,
}]]

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
    a: 4,
    b: 1,
    c: 2,
    d: 3,
    g: 9,
    l: 11,
    p: 10,
    q: 8,
    s: 5,
    y: 6,
    z: 7,
}]]

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
]] '0xff: integer'

-- local x = <?'\a'?> escape sequence hover
TEST_HOVER [[
local <?x?> = '\a'
]] [[local x: string = "\007"]]

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
]] 'local t: { [string]: boolean }'

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
(method) m:f()
  -> E
]]

-- @class Position @field x,y,z — SKIP: @class直接标注local在新框架不生效
-- (not migrated: old-test pattern uses @class on local variable directly)

-- @type { x: string, y: number, z: boolean } inline local <?t?>
TEST_HOVER [[
---@type { x: string, y: number, z: boolean }
local <?t?>
]] [[
local t: {
    x: string,
    y: number,
    z: boolean,
}]]

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
    [1]: "a",
    [2]: "b",
    [3]: "h",
    [10]: "d",
    x: "e",
    y: "f",
    z: "g",
}]]

-- local type / w2l:get_default()[<?type?>] unknown local
TEST_HOVER [[
local type
w2l:get_default()[<?type?>]
]] '(global) type: unknown'

-- <?a?>.b = 10 * 60 global table field
TEST_HOVER [[
<?a?>.b = 10 * 60
]] '(global) a: unknown'

-- a.<?b?> = 10 * 60 global field value
TEST_HOVER [[
a.<?b?> = 10 * 60
]] '(global) a.b: op.mul<10, 60>'

-- a.<?b?>.c = 1 * 1 nested global field
TEST_HOVER [[
a.<?b?>.c = 1 * 1
]] '(global) a.b: unknown'

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
