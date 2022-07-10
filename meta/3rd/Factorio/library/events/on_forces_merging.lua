---@meta

---Called when two forces are about to be merged using `game.merge_forces()`.
---@class on_forces_merging
---@field destination LuaForce @The force to reassign entities to.
---@field name defines.events @Identifier of the event
---@field source LuaForce @The force to be destroyed
---@field tick uint @Tick the event was generated.
local on_forces_merging = {}

