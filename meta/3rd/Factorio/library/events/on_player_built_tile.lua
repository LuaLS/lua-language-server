---@meta

---Called after a player builds tiles.
---@class on_player_built_tile
---@field item? LuaItemPrototype @The item type used to build the tiles
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field stack? LuaItemStack @The stack used to build the tiles (may be empty if all of the items where used to build the tiles).
---@field surface_index uint @The surface the tile(s) were built on.
---@field tick uint @Tick the event was generated.
---@field tile LuaTilePrototype @The tile prototype that was placed.
---@field tiles OldTileAndPosition[] @The position data.
local on_player_built_tile = {}

