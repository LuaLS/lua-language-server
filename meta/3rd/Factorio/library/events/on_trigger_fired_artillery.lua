---@meta

---Called when an entity with a trigger prototype (such as capsules) fire an artillery projectile AND that trigger prototype defined `trigger_fired_artillery="true"`.
---@class on_trigger_fired_artillery
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field source? LuaEntity
---@field tick uint @Tick the event was generated.
local on_trigger_fired_artillery = {}

