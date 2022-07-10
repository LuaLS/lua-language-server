---@meta

---Called after a robot builds tiles.
---@class on_robot_built_tile
---@field item LuaItemPrototype @The item type used to build the tiles.
---@field name defines.events @Identifier of the event
---@field robot LuaEntity @The robot.
---@field stack LuaItemStack @The stack used to build the tiles (may be empty if all of the items where used to build the tiles).
---@field surface_index uint @The surface the tile(s) are build on.
---@field tick uint @Tick the event was generated.
---@field tile LuaTilePrototype @The tile prototype that was placed.
---@field tiles OldTileAndPosition[] @The position data.
local on_robot_built_tile = {}

