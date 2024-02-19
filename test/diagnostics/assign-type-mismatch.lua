local config = require 'config'

TEST [[
local m = {}

---@type integer[]
m.ints = {}
]]

TEST [[
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
---@type [boolean]
local t = { <![1]!> = nil }

t = nil
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
config.set(nil, 'Lua.type.weakUnionCheck', true)

TEST [[
---@type number
local <!x!> = 'aaa'
]]
TEST [[
---@class X

---@class A
local mt = G

---@type X
mt._x = nil
]]
config.set(nil, 'Lua.type.weakUnionCheck', false)

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
---@type {[1]: string, [10]: number, xx: boolean}
local t = {
    <!true!>,
    <![10]!> = 's',
    <!xx!> = 1,
}
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
---@class SomeClass
---@field [1] string
-- ...

---@param some_param SomeClass|SomeClass[]
local function some_fn(some_param) return end

some_fn { { "test" } } -- <- diagnostic: "Cannot assign `table` to `string`."
]]

TEST [[
---@type string[]
local arr = {
    <!3!>,
}
]]

TEST [[
---@type (string|boolean)[]
local arr2 = {
    <!3!>, -- no warnings
}
]]

TEST [[
local t = {}
t.a = 1
t.a = 2
return t
]]
