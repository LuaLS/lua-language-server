---@meta

---Called after equipment is removed from an equipment grid.
---@class on_equipment_removed
---@field count uint @The count of equipment removed.
---@field equipment string @The equipment removed.
---@field grid LuaEquipmentGrid @The equipment grid removed from.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local on_equipment_removed = {}

