---@meta

---Called when the deconstruction of an entity is canceled. Can be filtered using [LuaEntityDeconstructionCancelledEventFilter](LuaEntityDeconstructionCancelledEventFilter).
---@class on_cancelled_deconstruction
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field player_index? uint
---@field tick uint @Tick the event was generated.
local on_cancelled_deconstruction = {}

