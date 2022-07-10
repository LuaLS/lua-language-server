---@meta

---Called after the player removes equipment from an equipment grid
---@class on_player_removed_equipment
---@field count uint @The count of equipment removed.
---@field equipment string @The equipment removed.
---@field grid LuaEquipmentGrid @The equipment grid removed from.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field tick uint @Tick the event was generated.
local on_player_removed_equipment = {}

