---@meta

---Called when the player rotates an entity. This event is only fired when the entity actually changes its orientation -- pressing the rotate key on an entity that can't be rotated won't fire this event.
---@class on_player_rotated_entity
---@field entity LuaEntity @The rotated entity.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field previous_direction defines.direction @The previous direction
---@field tick uint @Tick the event was generated.
local on_player_rotated_entity = {}

