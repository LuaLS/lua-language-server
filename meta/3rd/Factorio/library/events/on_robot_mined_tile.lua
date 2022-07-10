---@meta

---Called after a robot mines tiles.
---@class on_robot_mined_tile
---@field name defines.events @Identifier of the event
---@field robot LuaEntity @The robot.
---@field surface_index uint @The surface the tile(s) were mined on.
---@field tick uint @Tick the event was generated.
---@field tiles OldTileAndPosition[] @The position data.
local on_robot_mined_tile = {}

