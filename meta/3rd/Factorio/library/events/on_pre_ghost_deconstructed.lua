---@meta

---Called before a ghost entity is destroyed as a result of being marked for deconstruction. Can be filtered using [LuaPreGhostDeconstructedEventFilter](LuaPreGhostDeconstructedEventFilter).
---@class on_pre_ghost_deconstructed
---@field ghost LuaEntity
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player that did the deconstruction if any.
---@field tick uint @Tick the event was generated.
local on_pre_ghost_deconstructed = {}

