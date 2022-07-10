---@meta

---Called after player flushed fluid
---@class on_player_flushed_fluid
---@field amount double @Amount of fluid that was removed
---@field entity LuaEntity @Entity from which flush was performed
---@field fluid string @Name of a fluid that was flushed
---@field name defines.events @Identifier of the event
---@field only_this_entity boolean @True if flush was requested only on this entity
---@field player_index uint @Index of the player
---@field tick uint @Tick the event was generated.
local on_player_flushed_fluid = {}

