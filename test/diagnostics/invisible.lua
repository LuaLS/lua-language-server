local config = require 'config'

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
TEST [[
---@class A
local A = {
    _id = 0
}

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
local A = {
    _id = 0
}

---@type A
local t

print(t.<!_id!>)

---@class B: A
local t2

print(t2._id)
]]

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

config.set(nil, 'Lua.doc.regengine', 'lua' )
config.set(nil, 'Lua.doc.privateName', { '^_[%w_]*%w$' })
config.set(nil, 'Lua.doc.protectedName', { '^_[%w_]*_$' })
TEST [[
---@class A
---@field _id_ number
---@field _user number

---@type A
local t
print(t.<!_id_!>)
print(t.<!_user!>)

---@class B: A
local t2
print(t2._id_)
print(t2.<!_user!>)
]]
config.set(nil, 'Lua.doc.privateName', nil)
config.set(nil, 'Lua.doc.protectedName', nil)
config.set(nil, 'Lua.doc.regengine', nil )

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
