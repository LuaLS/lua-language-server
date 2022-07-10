---@meta

---Called after a player respawns.
---@class on_player_respawned
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field player_port? LuaEntity @The player port used to respawn if one was used.
---@field tick uint @Tick the event was generated.
local on_player_respawned = {}

