local config = require 'config'

config.add(nil, 'Lua.diagnostics.disable', 'unused-local')
config.add(nil, 'Lua.diagnostics.disable', 'unused-function')
config.add(nil, 'Lua.diagnostics.disable', 'undefined-global')
config.add(nil, 'Lua.diagnostics.disable', 'redundant-return')
config.set(nil, 'Lua.type.castNumberToInteger', false)

TEST [[
local x = 0

<!x!> = true
]]

TEST [[
---@type integer
local x

<!x!> = true
]]

TEST [[
---@type unknown
local x

x = nil
]]

TEST [[
---@type unknown
local x

x = 1
]]

TEST [[
---@type unknown|nil
local x

x = 1
]]

TEST [[
local x = {}

x = nil
]]

TEST [[
---@type string
local x

<?x?> = nil
]]

TEST [[
---@type string?
local x

x = nil
]]

TEST [[
---@type table
local x

<!x!> = nil
]]

TEST [[
local x

x = nil
]]

TEST [[
---@type integer
local x

---@type number
<!x!> = f()
]]

TEST [[
---@type number
local x

---@type integer
x = f()
]]

TEST [[
---@type number|boolean
local x

---@type string
<!x!> = f()
]]

TEST [[
---@type number|boolean
local x

---@type boolean
x = f()
]]

TEST [[
---@type number|boolean
local x

---@type boolean|string
<!x!> = f()
]]

TEST [[
---@type boolean
local x

if not x then
    return
end

x = f()
]]

TEST [[
---@type boolean
local x

---@type integer
local y

<!x!> = y
]]

TEST [[
local y = true

local x
x = 1
x = y
]]

TEST [[
local t = {}

local x = 0
x = x + #t
]]

TEST [[
local x = 0

x = 1.0
]]

TEST [[
---@class A

local t = {}

---@type A
local a

t = a
]]

TEST [[
local m = {}

---@type integer[]
m.ints = {}
]]

TEST [[
---@diagnostic disable: missing-fields
---@class A
---@field x A

---@type A
local t

t.x = {}
]]

TEST [[
---@class A
---@field x integer

---@type A
local t

<!t.x!> = true
]]

TEST [[
---@class A
---@field x integer

---@type A
local t

---@type boolean
local y

<!t.x!> = y
]]

TEST [[
---@class A
local m

m.x = 1

---@type A
local t

<!t.x!> = true
]]

TEST [[
---@class A
local m

---@type integer
m.x = 1

<!m.x!> = true
]]

TEST [[
---@class A
local mt

---@type integer
mt.x = 1

function mt:init()
    <!self.x!> = true
end
]]

TEST [[
---@class A
---@field x integer

---@type A
local t = {
    <!x!> = true
}
]]

TEST [[
---@type boolean[]
local t = {}

t[5] = nil
]]

TEST [[
---@type table<string, true>
local t = {}

t['x'] = nil
]]

TEST [[
local t = { true }

t[1] = nil
]]

TEST [[
---@class A
local t = {
    x = 1
}

<!t.x!> = true
]]

TEST [[
---@type number
local t

t = 1
]]

TEST [[
---@type number
local t

---@type integer
local y

t = y
]]

TEST [[
---@class A
local m

---@type number
m.x = 1

<!m.x!> = {}
]]

TEST [[
---@param x number
local function f(x) end

f(<!true!>)
]]

TEST [[
---@type integer
local x

x = 1.0
]]

TEST [[
---@type integer
local x

<!x!> = 1.5
]]

TEST [[
---@diagnostic disable:undefined-global
---@type integer
local x

x = 1 + G
]]

TEST [[
---@diagnostic disable:undefined-global
---@type integer
local x

x = 1 + G
]]

TEST [[
---@alias A integer

---@type A
local a

---@type integer
local b

b = a
]]

TEST [[
---@type string|boolean
local t

---@cast t string
]]

TEST [[
---@type string|boolean
local t

---@cast t <!number!>
]]

TEST [[
local n

if G then
    n = {}
else
    n = nil
end

local t = {
    x = n,
}
]]

TEST [[
---@class A

---@param n A
local function f(n)
end

---@class B
local a = {}

---@type A?
a.x = XX

f(a.x)
]]

TEST [[
---@type string?
local x

local s = <!x!>:upper()
]]

TEST [[
---@alias A string|boolean

---@param x string|boolean
local function f(x) end

---@type A
local x

f(x)
]]

TEST [[
---@alias A string|boolean

---@param x A
local function f(x) end

---@type string|boolean
local x

f(x)
]]

TEST [[
---@type boolean[]
local t = {}

---@type boolean?
local x

t[#t+1] = x
]]

TEST [[
---@type number
local n
---@type integer
local i

<?i?> = n
]]

config.set(nil, 'Lua.type.castNumberToInteger', true)
TEST [[
---@type number
local n
---@type integer
local i

i = n
]]
config.set(nil, 'Lua.type.castNumberToInteger', false)

TEST [[
---@type number|boolean
local nb

---@type number
local n

<?n?> = nb
]]

config.set(nil, 'Lua.type.weakUnionCheck', true)
TEST [[
---@type number|boolean
local nb

---@type number
local n

n = nb
]]
config.set(nil, 'Lua.type.weakUnionCheck', false)

TEST [[
---@class Option: string

---@param x Option
local function f(x) end

---@type Option
local x = 'aaa'

f(x)
]]

TEST [[
---@type number
local <!x!> = 'aaa'
]]

TEST [[
---@return number
function F()
    return <!true!>
end
]]

TEST [[
---@return number?
function F()
    return 1
end
]]

TEST [[
---@return number?
function F()
    return nil
end
]]

TEST [[
---@return number, number
local function f()
    return 1, 1
end

---@return number, boolean
function F()
    return <!f()!>
end
]]

TEST [[
---@return boolean, number
local function f()
    return true, 1
end

---@return number, boolean
function F()
    return <!f()!>
end
]]

TEST [[
---@return boolean, number?
local function f()
    return true, 1
end

---@return number, boolean
function F()
    return 1, f()
end
]]

TEST [[
---@return number, number?
local function f()
    return 1, 1
end

---@return number, boolean, number
function F()
    return 1, <!f()!>
end
]]

TEST [[
---@class A
---@field x number?

---@return number
function F()
    ---@type A
    local t
    return t.x
end
]]

TEST [[
---@class A
---@field x number?
local t = {}

---@return number
function F()
    return t.x
end
]]

TEST [[
---@param ... number
local function f(...)
end

f(nil)
]]

TEST [[
---@return number
function F()
    local n = 0
    if true then
        n = 1
    end
    return n
end
]]

TEST [[
---@class X

---@class A
local mt = G

---@type X
mt._x = nil
]]

config.set(nil, 'Lua.type.weakNilCheck', true)
TEST [[
---@type number?
local nb

---@type number
local n

n = nb
]]

TEST [[
---@type number|nil
local nb

---@type number
local n

n = nb
]]
config.set(nil, 'Lua.type.weakNilCheck', false)

TEST [[
---@class A
local a = {}

---@class B
local <!b!> = a
]]

TEST [[
---@class A
local a = {}

---@class B: A
local b = a
]]

TEST [[
---@class A
local a = {}
a.__index = a

---@class B: A
local b = setmetatable({}, a)
]]

TEST [[
---@class A
local a = {}

---@class B: A
local b = setmetatable({}, {__index = a})
]]

TEST [[
---@class A
local a = {}

---@class B
local <!b!> = setmetatable({}, {__index = a})
]]

TEST [[
---@class A
---@field x number?
local a

---@class B
---@field x number
local b

b.x = a.x
]]

TEST [[

---@class A
---@field x number?
local a

---@type number
local t

t = a.x
]]

TEST [[
local mt = {}
mt.x = 1
mt.x = nil
]]

TEST [[
---@type string[]
local t

<!t!> = 'xxx'
]]

TEST [[
---@param b boolean
local function f(b)
end

---@type boolean
local t

if t then
    f(t)
end
]]

config.set(nil, 'Lua.type.weakUnionCheck', true)
TEST [[
---@type number
local x = G
]]

TEST [[
---@generic T
---@param x T
---@return T
local function f(x)
    return x
end
]]
config.set(nil, 'Lua.type.weakUnionCheck', false)

TEST [[
---@type 1|2
local x

x = 1
x = 2
<!x!> = 3
]]

TEST [[
---@type 'x'|'y'
local x

x = 'x'
x = 'y'
<!x!> = 'z'
]]

TEST [[
---@enum A
local t = {
    x = 1,
    y = 2,
}

---@param x A
local function f(x)
end

f(<!t!>)
f(t.x)
f(1)
f(<!3!>)
]]

TEST [[
---@enum A
local t = {
    x = { h = 1 },
    y = { h = 2 },
}

---@param x A
local function f(x)
end

f(t.x)
f(t.y)
f(<!{ h = 1 }!>)
]]

TEST [[
local t = {
    x = 1,
}

local x
t[x] = true
]]

TEST [[
---@param x boolean
---@return number
---@overload fun(): boolean
local function f(x)
    if x then
        return 1
    else
        return false
    end
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun()
local function f(x)
    if x then
        return 1
    else
        return
    end
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun()
local function f(x)
    if x then
        return 1
    end
end
]]

TEST [[
---@param x boolean
---@return number
---@overload fun(): boolean, boolean
local function f(x)
    if x then
        return 1
    else
        return false, false
    end
end
]]

TEST [[
---@alias test boolean

---@type test
local <!test!> = 4
]]

TEST [[
---@class MyClass
local MyClass = {}

function MyClass:new()
    ---@class MyClass
    local myObject = setmetatable({
        initialField = true
    }, self)

    print(myObject.initialField)
end
]]

TEST [[
---@class T
local t = {
    x = nil
}

t.x = 1
]]

TEST [[
---@generic T: string | boolean | table
---@param x T
---@return T
local function f(x)
    return x
end

f(<!1!>)
]]

TEST [[
---@type table<string, string>
local x

---@type table<number, string>
local y

<!x!> = y
]]

TEST [[
---@type table<string, string>
local x

---@type table<string, number>
local y

<!x!> = y
]]

TEST [[
---@type table<string, string>
local x

---@type table<string, string>
local y

x = y
]]

TEST [[
---@param opts {a:number, b:number}
local function foo(opts)

end

---@param opts {a:number, b:number}
local function bar(opts)
    foo(opts)
end
]]

TEST [[
---@param opts {a:number, b:number}
local function foo(opts)

end

---@param opts {c:number, d:number}
local function bar(opts)
    foo(<!opts!>)  -- this should raise linting error
end
]]

TEST [[
---@param opts {[number]: boolean}
local function foo(opts)

end

---@param opts {[1]: boolean}
local function bar(opts)
    foo(opts)
end
]]

TEST [[
---@type {[1]: string, [10]: number, xx: boolean}
local t = {
    <!true!>,
    <![10]!> = 's',
    <!xx!> = 1,
}
]]

TEST [[
---@type { x: number, y: number }
local t1

---@type { x: number }
local t2

<!t1!> = t2
]]

TEST [[
---@type { x: number, [integer]: number }
local t1

---@type { x: number }
local t2

<!t1!> = t2
]]

TEST [[
---@type boolean[]
local t = { <!1!>, <!2!>, <!3!> }
]]

TEST [[
---@type boolean[]
local t = { true, false, nil }
]]

TEST [[
---@type boolean|nil
local x

---@type boolean[]
local t = { true, false, x }
]]

TEST [[
---@type fun():number
local function f()
<!!>end
]]

TEST [[
---@type fun():number
local function f()
    <!return!>
end
]]

TEST [[
---@type fun():number?
local function f()
end
]]

TEST [[
---@type fun():...
local function f()
end
]]

TEST [[
---@type fun():number
local function f()
    return 1, <!true!>
end
]]

TEST [[
---@type fun():number
local function f()
    return <!true!>
end
]]

TEST [[
---@enum Enum
local t = {
    x = 1,
    y = 2,
}

---@type Enum
local y

---@type integer
local x = y
]]

TEST [[
---@generic T
---@param v1 T
---@param v2 T|table
local function func(v1, v2)
end

func('hello', 'world')
]]

TEST [[
---@generic T1, T2, T3, T4, T5
---@param f fun(): T1?, T2?, T3?, T4?, T5?
---@return T1?, T2?, T3?, T4?, T5?
local function foo(f)
    return f()
end

local a, b = foo(function()
    return 1
end)
]]

TEST [[
---@generic T1, T2, T3, T4, T5
---@param f fun(): T1|nil, T2|nil, T3|nil, T4|nil, T5|nil
---@return T1?, T2?, T3?, T4?, T5?
local function foo(f)
    return f()
end

local a, b = foo(function()
    return 1
end)
]]

TEST [[
---@type string|string[]|string[][]
local t = {{'a'}}
]]

TEST [[
local A = "Hello"
local B = "World"

---@alias myLiteralAliases `A` | `B`

---@type myLiteralAliases
local x = A
]]

TEST [[
local enum = { a = 1, b = 2 }

---@type { [integer] : boolean }
local t = {
    <![enum.a]!> = 1,
    <![enum.b]!> = 2,
    <![3]!> = 3,
}
]]

TEST [[
local x

if X then
    x = 'A'
elseif X then
    x = 'B'
else
    x = 'C'
end

local y = x

<!y!> = nil
]]
(function (diags)
    local diag = diags[1]
    assert(diag.message == [[
已显式定义变量的类型为 `string` ，不能再将其类型转换为 `nil`。
- `nil` 无法匹配 `string`
- 类型 `nil` 无法匹配 `string`]])
end)


TEST [[
---@type 'A'|'B'|'C'|'D'|'E'|'F'|'G'|'H'|'I'|'J'|'K'|'L'|'M'|'N'|'O'|'P'|'Q'|'R'|'S'|'T'|'U'|'V'|'W'|'X'|'Y'|'Z'
local x

<!x!> = nil
]]
(function (diags)
    local diag = diags[1]
    assert(diag.message == [[
已显式定义变量的类型为 `'A'|'B'|'C'|'D'|'E'...(+21)` ，不能再将其类型转换为 `nil`。
- `nil` 无法匹配 `'A'|'B'|'C'|'D'|'E'...(+21)`
- `nil` 无法匹配 `'A'|'B'|'C'|'D'|'E'...(+21)` 中的任何子类
- 类型 `nil` 无法匹配 `'Z'`
- 类型 `nil` 无法匹配 `'Y'`
- 类型 `nil` 无法匹配 `'X'`
- 类型 `nil` 无法匹配 `'W'`
- 类型 `nil` 无法匹配 `'V'`
- 类型 `nil` 无法匹配 `'U'`
- 类型 `nil` 无法匹配 `'T'`
- 类型 `nil` 无法匹配 `'S'`
- 类型 `nil` 无法匹配 `'R'`
- 类型 `nil` 无法匹配 `'Q'`
...(+13)
- 类型 `nil` 无法匹配 `'C'`
- 类型 `nil` 无法匹配 `'B'`
- 类型 `nil` 无法匹配 `'A'`]])
end)

TEST [[
---@param v integer
---@return boolean
local function is_string(v)
    return type(v) == 'string'
end

print(is_string(3))
]]

TEST [[
---@class SomeClass
---@field [1] string
-- ...

---@param some_param SomeClass|SomeClass[]
local function some_fn(some_param) return end

some_fn { { "test" } } -- <- diagnostic: "Cannot assign `table` to `string`."
]]

TEST [[
---@param p integer|string
local function get_val(p)
    local is_number = type(p) == 'number'
    return is_number and p or p
end

get_val('hi')
]]

TESTWITH 'param-type-mismatch' [[
---@class Class
local Class = {}

---@param source string
function Class.staticCreator(source)

end

Class.staticCreator(<!true!>)
Class<!:!>staticCreator() -- Expecting a waring
]]

TESTWITH 'assign-type-mismatch' [[
---@type string[]
local arr = {
    <!3!>,
}
]]

TESTWITH 'assign-type-mismatch' [[
---@type (string|boolean)[]
local arr2 = {
    <!3!>, -- no warnings
}
]]

TEST [[
---@class A

---@class B : A

---@class C : B

---@class D : B

---@param x A
local function func(x) end

---@type C|D
local var
func(var)
]]

TEST [[
---@class MyClass
---@overload fun(x : string) : MyClass
local MyClass = {}

local w = MyClass(<!1!>)
]]

config.remove(nil, 'Lua.diagnostics.disable', 'unused-local')
config.remove(nil, 'Lua.diagnostics.disable', 'unused-function')
config.remove(nil, 'Lua.diagnostics.disable', 'undefined-global')
config.remove(nil, 'Lua.diagnostics.disable', 'redundant-return')
config.set(nil, 'Lua.type.castNumberToInteger', true)
