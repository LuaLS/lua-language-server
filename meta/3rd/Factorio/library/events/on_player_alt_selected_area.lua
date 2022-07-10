---@meta

---Called after a player alt-selects an area with a selection-tool item.
---@class on_player_alt_selected_area
---@field area BoundingBox @The area selected.
---@field entities LuaEntity[] @The entities selected.
---@field item string @The item used to select the area.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player doing the selection.
---@field surface LuaSurface @The surface selected.
---@field tick uint @Tick the event was generated.
---@field tiles LuaTile[] @The tiles selected.
local on_player_alt_selected_area = {}

