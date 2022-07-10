---@meta

---Called directly before a robot explodes cliffs.
---@class on_pre_robot_exploded_cliff
---@field cliff LuaEntity
---@field item LuaItemPrototype @The cliff explosive used.
---@field name defines.events @Identifier of the event
---@field robot LuaEntity
---@field tick uint @Tick the event was generated.
local on_pre_robot_exploded_cliff = {}

