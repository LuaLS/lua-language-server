---@meta

---Called when an entity is damaged. Can be filtered using [LuaEntityDamagedEventFilter](LuaEntityDamagedEventFilter).
---
---This is not called when an entities health is set directly by another mod.
---@class on_entity_damaged
---@field cause? LuaEntity @The entity that did the attacking if available.
---@field damage_type LuaDamagePrototype
---@field entity LuaEntity
---@field final_damage_amount float @The damage amount after resistances.
---@field final_health float @The health of the entity after the damage was applied.
---@field force? LuaForce @The force that did the attacking if any.
---@field name defines.events @Identifier of the event
---@field original_damage_amount float @The damage amount before resistances.
---@field tick uint @Tick the event was generated.
local on_entity_damaged = {}

