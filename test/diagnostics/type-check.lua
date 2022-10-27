local config = require 'config'

config.add(nil, 'Lua.diagnostics.disable', 'unused-local')
config.add(nil, 'Lua.diagnostics.disable', 'unused-function')
config.add(nil, 'Lua.diagnostics.disable', 'undefined-global')
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
local function f() end

---@return number, boolean
function F()
    return <!f()!>
end
]]

TEST [[
---@return boolean, number
local function f() end

---@return number, boolean
function F()
    return <!f()!>
end
]]

TEST [[
---@return boolean, number?
local function f() end

---@return number, boolean
function F()
    return 1, f()
end
]]

TEST [[
---@return number, number?
local function f() end

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

config.remove(nil, 'Lua.diagnostics.disable', 'unused-local')
config.remove(nil, 'Lua.diagnostics.disable', 'unused-function')
config.remove(nil, 'Lua.diagnostics.disable', 'undefined-global')
config.set(nil, 'Lua.type.castNumberToInteger', true)
