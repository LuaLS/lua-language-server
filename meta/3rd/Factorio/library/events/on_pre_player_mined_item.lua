---@meta

---Called when the player finishes mining an entity, before the entity is removed from map. Can be filtered using [LuaPrePlayerMinedEntityEventFilter](LuaPrePlayerMinedEntityEventFilter).
---@class on_pre_player_mined_item
---@field entity LuaEntity @The entity being mined
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field tick uint @Tick the event was generated.
local on_pre_player_mined_item = {}

