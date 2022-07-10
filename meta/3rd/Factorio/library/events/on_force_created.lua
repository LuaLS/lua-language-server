---@meta

---Called when a new force is created using `game.create_force()`
---
---This is not called when the default forces (`'player'`, `'enemy'`, `'neutral'`) are created as they will always exist.
---@class on_force_created
---@field force LuaForce @The newly created force.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local on_force_created = {}

