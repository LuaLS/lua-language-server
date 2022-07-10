---@meta

---Called when a set of positions on the map is cloned.
---@class on_brush_cloned
---@field clear_destination_decoratives boolean
---@field clear_destination_entities boolean
---@field clone_decoratives boolean
---@field clone_entities boolean
---@field clone_tiles boolean
---@field destination_force? LuaForce
---@field destination_offset TilePosition
---@field destination_surface LuaSurface
---@field name defines.events @Identifier of the event
---@field source_offset TilePosition
---@field source_positions TilePosition[]
---@field source_surface LuaSurface
---@field tick uint @Tick the event was generated.
local on_brush_cloned = {}

