---@meta

---Called when a resource entity reaches 0 or its minimum yield for infinite resources.
---@class on_resource_depleted
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local on_resource_depleted = {}

