---@meta

---Called when an area of the map is cloned.
---@class on_area_cloned
---@field clear_destination_decoratives boolean
---@field clear_destination_entities boolean
---@field clone_decoratives boolean
---@field clone_entities boolean
---@field clone_tiles boolean
---@field destination_area BoundingBox
---@field destination_force? LuaForce
---@field destination_surface LuaSurface
---@field name defines.events @Identifier of the event
---@field source_area BoundingBox
---@field source_surface LuaSurface
---@field tick uint @Tick the event was generated.
local on_area_cloned = {}

