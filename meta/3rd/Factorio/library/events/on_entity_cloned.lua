---@meta

---Called when an entity is cloned. Can be filtered for the source entity using [LuaEntityClonedEventFilter](LuaEntityClonedEventFilter).
---@class on_entity_cloned
---@field destination LuaEntity
---@field name defines.events @Identifier of the event
---@field source LuaEntity
---@field tick uint @Tick the event was generated.
local on_entity_cloned = {}

