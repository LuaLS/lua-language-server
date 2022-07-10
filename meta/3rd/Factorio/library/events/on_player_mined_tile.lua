---@meta

---Called after a player mines tiles.
---@class on_player_mined_tile
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field surface_index uint @The surface the tile(s) were mined from.
---@field tick uint @Tick the event was generated.
---@field tiles OldTileAndPosition[] @The position data.
local on_player_mined_tile = {}

