TEST [[
---@class Class
---@field <!x!> Class
---@field <!x!> Class
]]

TEST [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field on fun(eventName: '"died"', cb: fun(i: integer))
--- @field on fun(eventName: '"won"', cb: fun(s: string))
local emit = {}
]]

TEST [[
--- @class Emit
--- @field on fun(eventName: string, cb: function)
--- @field <!on!> fun(eventName: '"died"', cb: fun(i: integer))
--- @field on fun(eventName: '"won"', cb: fun(s: string))
--- @field <!on!> fun(eventName: '"died"', cb: fun(i: integer))
local emit = {}
]]
