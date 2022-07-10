---@meta

---Called when a player repairs an entity. Can be filtered using [LuaPlayerRepairedEntityEventFilter](LuaPlayerRepairedEntityEventFilter).
---@class on_player_repaired_entity
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field tick uint @Tick the event was generated.
local on_player_repaired_entity = {}

