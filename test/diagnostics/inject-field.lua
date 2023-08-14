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
