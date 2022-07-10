---@meta

---Called when an entity is marked for deconstruction with the Deconstruction planner or via script. Can be filtered using [LuaEntityMarkedForDeconstructionEventFilter](LuaEntityMarkedForDeconstructionEventFilter).
---@class on_marked_for_deconstruction
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field player_index? uint
---@field tick uint @Tick the event was generated.
local on_marked_for_deconstruction = {}

