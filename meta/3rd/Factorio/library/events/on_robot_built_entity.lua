---@meta

---Called when a construction robot builds an entity. Can be filtered using [LuaRobotBuiltEntityEventFilter](LuaRobotBuiltEntityEventFilter).
---@class on_robot_built_entity
---@field created_entity LuaEntity @The entity built.
---@field name defines.events @Identifier of the event
---@field robot LuaEntity @The robot that did the building.
---@field stack LuaItemStack @The item used to do the building.
---@field tags? Tags @The tags associated with this entity if any.
---@field tick uint @Tick the event was generated.
local on_robot_built_entity = {}

