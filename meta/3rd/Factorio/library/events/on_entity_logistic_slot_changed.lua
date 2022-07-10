---@meta

---Called when one of an entity's personal logistic slots changes.
---
---"Personal logistic slot" refers to a character or vehicle's personal request / auto-trash slots, not the request slots on logistic chests.
---@class on_entity_logistic_slot_changed
---@field entity LuaEntity @The entity for whom a logistic slot was changed.
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player who changed the slot, or `nil` if changed by script.
---@field slot_index uint @The slot index that was changed.
---@field tick uint @Tick the event was generated.
local on_entity_logistic_slot_changed = {}

