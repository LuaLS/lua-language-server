---@meta

---Called after two forces have been merged using `game.merge_forces()`.
---
---The source force is invalidated before this event is called and the name can be re-used in this event if desired.
---@class on_forces_merged
---@field destination LuaForce @The force entities where reassigned to.
---@field name defines.events @Identifier of the event
---@field source_index uint @The index of the destroyed force.
---@field source_name string @The force destroyed.
---@field tick uint @Tick the event was generated.
local on_forces_merged = {}

