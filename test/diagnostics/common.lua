

TEST [[
---@cast <!x!> integer
]]

TEST [[
---@diagnostic disable: unused-local
local x, y
---@cast y number
]]

TEST [[
---@class A

---@class B
---@field [integer] A
---@field [A] true
]]

TEST [[
---@class A

---@class B
---@field [<!A!>] A
---@field [<!A!>] true
]]

TEST [[
---@diagnostic disable: unused-local

---@type 'x'
local t

local n = t:upper()
]]

TEST [[
---@diagnostic disable: unused-local

---@alias A 'x'

---@type A
local t

local n = t:upper()
]]

TEST [[
local t = {}

function t:init() end

<!t.init()!>
]]

TEST [[
---@meta

return function f(x, y, z) end
]]

util.arrayInsert(disables, 'redundant-return')
TEST [[
---@return number
function F()
    <!return!>
end
]]

TEST [[
---@return number, number
function F()
    <!return!> 1
end
]]

TEST [[
---@return number, number?
function F()
    return 1
end
]]

TEST [[
---@return ...
function F()
    return
end
]]

TEST [[
---@return number, number?
function F()
    return 1, 1, <!1!>
end
]]

TEST [[
---@return number, number?
function F()
    return 1, 1, <!1!>, <!2!>, <!3!>
end
]]

TEST [[
---@meta

---@return number, number
local function r2() end

---@return number, number?
function F()
    return 1, <!r2()!>
end
]]

TEST [[
---@return number
function F()
    X = 1<!!>
end
]]

TEST [[
local A
---@return number
function F()
    if A then
        return 1
    end<!!>
end
]]

TEST [[
local A, B
---@return number
function F()
    if A then
        return 1
    elseif B then
        return 2
    end<!!>
end
]]

TEST [[
local A, B
---@return number
function F()
    if A then
        return 1
    elseif B then
        return 2
    else
        return 3
    end
end
]]

TEST [[
local A, B
---@return number
function F()
    if A then
    elseif B then
        return 2
    else
        return 3
    end<!!>
end
]]

TEST [[
---@return any
function F()
    X = 1
end
]]

TEST [[
---@return any, number
function F()
    X = 1<!!>
end
]]

TEST [[
---@return number, any
function F()
    X = 1<!!>
end
]]

TEST [[
---@return any, any
function F()
    X = 1
end
]]

TEST [[
local A
---@return number
function F()
    for _ = 1, 10 do
        if A then
            return 1
        end
    end
    error('should not be here')
end
]]

TEST [[
local A
---@return number
function F()
    while true do
        if A then
            return 1
        end
    end
end
]]

TEST [[
local A
---@return number
function F()
    while A do
        if A then
            return 1
        end
    end<!!>
end
]]

TEST [[
local A
---@return number
function F()
    while A do
        if A then
            return 1
        else
            return 2
        end
    end
end
]]

TEST [[
---@return number?
function F()

end
]]

util.arrayRemove(disables, 'redundant-return')

TEST [[
---@class A
---@operator <!xxx!>: A
]]

config.add(nil, 'Lua.diagnostics.unusedLocalExclude', 'll_*')

TEST [[
local <!xx!>
local ll_1
local ll_2
local <!ll!>
]]

config.remove(nil, 'Lua.diagnostics.unusedLocalExclude', 'll_*')

TEST [[
---@diagnostic disable: undefined-global

if X then
    return false
elseif X then
    return false
else
    return false
end
<!return true!>
]]

TEST [[
---@diagnostic disable: undefined-global

function X()
    if X then
        return false
    elseif X then
        return false
    else
        return false
    end
    <!return true!>
end
]]

TEST [[
while true do
end

<!print(1)!>
]]

TEST [[
while true do
end

<!print(1)!>
]]

TEST [[
while X do
    X = 1
end

print(1)
]]

TEST [[
---@diagnostic disable: undefined-global

while true do
    if not X then
        break
    end
end

print(1)

do return end
]]

TEST [[
---@type unknown
local t

local _ <close> = t
]]

TEST [[
---@meta
---@diagnostic disable: duplicate-set-field
---@class A
local m = {}

function m.ff() end

function m.ff(x) end

m.ff(1)
]]

TEST [[
local done = false

local function set_done()
    done = true
end

while not done do
    set_done()
end

print(1)
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field public z number
local t
print(t.x)
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field public z number

---@type A
local t

print(t.<!x!>)
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field public z number

---@class B: A
local t

print(t.y)
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field public z number

---@class B: A

---@type B
local t

print(t.<!y!>)
]]

TEST [[
---@class A
---@field private x number
---@field protected y number
---@field public z number

---@class B: A

---@type B
local t

print(t.z)
]]

TEST [[
---@class A
---@field _id number

---@type A
local t

print(t._id)
]]

config.set(nil, 'Lua.doc.privateName', { '_*' })
TEST [[
---@class A
---@field _id number

---@type A
local t

print(t.<!_id!>)

---@class B: A
local t2

print(t2.<!_id!>)
]]
config.set(nil, 'Lua.doc.privateName', nil)

config.set(nil, 'Lua.doc.protectedName', { '_*' })
TEST [[
---@class A
---@field _id number

---@type A
local t

print(t.<!_id!>)

---@class B: A
local t2

print(t2._id)
]]
config.set(nil, 'Lua.doc.protectedName', nil)

TEST [[
---@class A
---@field private x number
local mt = {}

function mt:init()
    print(self.x)
end
]]

TEST [[
---@diagnostic disable: unused-local
---@diagnostic disable: missing-fields
---@class A
---@field private x number
local mt = {}

function mt:init()
    ---@type A
    local obj = {}

    obj.x = 1
end
]]

TEST [[
---@diagnostic disable: unused-local
---@diagnostic disable: missing-fields
---@class A
---@field private x number
local mt = {}

mt.init = function ()
    ---@type A
    local obj = {}

    obj.x = 1
end
]]

TEST [[
---@class A
X = {}

function <!X.f!>() end

function <!X.f!>() end
]]

TEST [[
---@meta

---@class A
X = {}

function X.f() end

function X.f() end
]]

TEST [[
---@class A
X = {}

if true then
    function X.f() end
else
    function X.f() end
end
]]

TESTWITH 'global-in-nil-env' [[
local function foo(_ENV)
    Joe = "human"
end
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = <!{}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = <!{
    x = 1,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = <!{
    x = 1,
    y = 2,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = {
    x = 1,
    y = 2,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@type A
local t = {
    x = 1,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f <!{}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f <!{
    x = 1,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f <!{
    x = 1,
    y = 2,
}!>
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f {
    x = 1,
    y = 2,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
---@field y? number
---@field z number

---@param a A
local function f(a) end

f {
    x = 1,
    z = 3,
}
]]

TEST [[
---@diagnostic disable: unused-local
---@class A
---@field x number
local t = {}
]]

TEST [[
---@diagnostic disable: unused-local

---@class A
---@field x number

---@class A
local t = {}
]]

TEST [[
---@diagnostic disable: unused-local

---@class Foo
---@field a number
---@field b number
---@field c number

---@type Foo|Foo[]
local a = {
    {
        a = 1,
        b = 2,
        c = 3,
    }
}
]]

TEST [[
---@diagnostic disable: unused-local

---@class Foo
---@field a number
---@field b number
---@field c number

---@class Bar
---@field ba number
---@field bb number
---@field bc number

---@type Foo|Bar
local b = {
    a = 1,
    b = 2,
    c = 3,
}
]]
