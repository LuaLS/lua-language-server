---@meta

---Called when player builds something. Can be filtered using [LuaPlayerBuiltEntityEventFilter](LuaPlayerBuiltEntityEventFilter).
---@class on_built_entity
---@field created_entity LuaEntity
---@field item? LuaItemPrototype @The item prototype used to build the entity. Note this won't exist in some situations (built from blueprint, undo, etc).
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field stack LuaItemStack
---@field tags? Tags @The tags associated with this entity if any.
---@field tick uint @Tick the event was generated.
local on_built_entity = {}

