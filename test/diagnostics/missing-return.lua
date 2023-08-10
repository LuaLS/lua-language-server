TEST [[
---@type fun():number
local function f()
<!!>end
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
