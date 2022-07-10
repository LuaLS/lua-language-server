---@meta

---Called when a combat robot expires through a lack of energy, or timeout.
---@class on_combat_robot_expired
---@field name defines.events @Identifier of the event
---@field owner? LuaEntity @The entity that owns the robot if any.
---@field robot LuaEntity
---@field tick uint @Tick the event was generated.
local on_combat_robot_expired = {}

