---@meta

---Called when a biter migration builds a base.
---
---This will be called multiple times for each migration, once for every biter that is sacrificed to build part of the new base.
---@class on_biter_base_built
---@field entity LuaEntity @The entity that was built.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local on_biter_base_built = {}

