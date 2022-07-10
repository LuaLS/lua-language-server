---@meta

---Called after entity copy-paste is done.
---@class on_entity_settings_pasted
---@field destination LuaEntity @The destination entity settings were copied to.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field source LuaEntity @The source entity settings were copied from.
---@field tick uint @Tick the event was generated.
local on_entity_settings_pasted = {}

