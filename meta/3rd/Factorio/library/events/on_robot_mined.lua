---@meta

---Called when a robot mines an entity.
---@class on_robot_mined
---@field item_stack SimpleItemStack @The entity the robot just picked up.
---@field name defines.events @Identifier of the event
---@field robot LuaEntity @The robot that did the mining.
---@field tick uint @Tick the event was generated.
local on_robot_mined = {}

