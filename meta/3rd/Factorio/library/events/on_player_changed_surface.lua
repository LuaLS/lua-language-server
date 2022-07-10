---@meta

---Called after a player changes surfaces.
---
---In the instance a player is moved off a surface due to it being deleted this is not called.
---@class on_player_changed_surface
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who changed surfaces.
---@field surface_index uint @The surface index the player was on.
---@field tick uint @Tick the event was generated.
local on_player_changed_surface = {}

