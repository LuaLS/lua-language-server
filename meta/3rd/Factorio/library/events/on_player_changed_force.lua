---@meta

---Called after a player changes forces.
---@class on_player_changed_force
---@field force LuaForce @The old force.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who changed forces.
---@field tick uint @Tick the event was generated.
local on_player_changed_force = {}

