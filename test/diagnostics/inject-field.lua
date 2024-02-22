TEST [[
---@class Class
local m = {}

m.xx = 1 -- OK

---@type Class
local m

m.xx = 1 -- OK
m.<!yy!> = 1 -- Warning
]]

TEST [[
---@class Class
local m = {}

m.xx = 1 -- OK

---@class Class
local m

m.xx = 1 -- OK
m.yy = 1 -- OK
]]

TEST [[
---@type { xx: number }
local m

m.xx = 1 -- OK
m.<!yy!> = 1 -- Warning
]]

TEST [[
---@type { xx: number, [any]: any }
local m

m.xx = 1 -- OK
m.yy = 1 -- OK
]]

TEST [[
---@class Class
---@field x number

---@type Class
local t

t.x = 1 -- OK
t.<!y!> = 2 -- Warning
]]

TEST [[
---@class Class
---@field x number
---@field [any] any

---@type Class
local t

t.x = 1 -- OK
t.y = 2 -- OK
]]


TEST [[
---@class (exact) Class
---@field x number
local m = {
    x = 1, -- OK
    <!y!> = 2, -- Warning
}

m.x = 1 -- OK
m.<!y!> = 2 -- Warning

function m:init() -- OK
    self.x = 1 -- OK
    self.<!y!> = 2 -- Warning
    function self:<!xx!>() -- Warning
    end
end
]]
