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
