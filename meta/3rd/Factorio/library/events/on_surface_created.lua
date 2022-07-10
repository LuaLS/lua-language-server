---@meta

---Called when a surface is created.
---
---This is not called when the default surface is created as it will always exist.
---@class on_surface_created
---@field name defines.events @Identifier of the event
---@field surface_index uint
---@field tick uint @Tick the event was generated.
local on_surface_created = {}

