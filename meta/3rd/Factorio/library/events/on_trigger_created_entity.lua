---@meta

---Called when an entity with a trigger prototype (such as capsules) create an entity AND that trigger prototype defined `trigger_created_entity="true"`.
---@class on_trigger_created_entity
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field source? LuaEntity
---@field tick uint @Tick the event was generated.
local on_trigger_created_entity = {}

