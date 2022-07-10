---@meta

---Called after the results of an entity being mined are collected just before the entity is destroyed. After this event any items in the buffer will be transferred into the player as if they came from mining the entity. Can be filtered using [LuaPlayerMinedEntityEventFilter](LuaPlayerMinedEntityEventFilter).
---
---The buffer inventory is special in that it's only valid during this event and has a dynamic size expanding as more items are transferred into it.
---@class on_player_mined_entity
---@field buffer LuaInventory @The temporary inventory that holds the result of mining the entity.
---@field entity LuaEntity @The entity that has been mined.
---@field name defines.events @Identifier of the event
---@field player_index uint @The index of the player doing the mining.
---@field tick uint @Tick the event was generated.
local on_player_mined_entity = {}

