---@meta

---Called when a player selects an area with a blueprint.
---@class on_player_setup_blueprint
---@field alt boolean @If normal selection or alt selection was used.
---@field area BoundingBox @The area selected.
---@field item string @The item used to select the area.
---@field mapping LuaLazyLoadedValue<table<uint, LuaEntity>> @The blueprint entity index to source entity mapping. Note: if any mod changes the blueprint this will be incorrect.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player doing the selection.
---@field surface LuaSurface @The surface selected.
---@field tick uint @Tick the event was generated.
local on_player_setup_blueprint = {}

