---@meta

---Called just before a surface is cleared (all entities removed and all chunks deleted).
---@class on_pre_surface_cleared
---@field name defines.events @Identifier of the event
---@field surface_index uint
---@field tick uint @Tick the event was generated.
local on_pre_surface_cleared = {}

