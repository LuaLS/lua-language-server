---@meta

---Called after the player puts equipment in an equipment grid
---@class on_player_placed_equipment
---@field equipment LuaEquipment @The equipment put in the equipment grid.
---@field grid LuaEquipmentGrid @The equipment grid the equipment was put in.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field tick uint @Tick the event was generated.
local on_player_placed_equipment = {}

