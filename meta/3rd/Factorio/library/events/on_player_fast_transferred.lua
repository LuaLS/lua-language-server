---@meta

---Called when a player fast-transfers something to or from an entity.
---@class on_player_fast_transferred
---@field entity LuaEntity @The entity transferred from or to.
---@field from_player boolean @Whether the transfer was from player to entity. If `false`, the transfer was from entity to player.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player transferred from or to.
---@field tick uint @Tick the event was generated.
local on_player_fast_transferred = {}

