TEST [[
local _ <close> = <!1!>
]]

TEST [[
local _ <close> = <!''!>
]]

TEST [[
local c <close> = <!(function () return 1 end)()!>
]]

TEST [[
---@type unknown
local t

local _ <close> = t
]]
