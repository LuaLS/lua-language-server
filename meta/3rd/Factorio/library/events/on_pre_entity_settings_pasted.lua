---@meta

---Called before entity copy-paste is done.
---@class on_pre_entity_settings_pasted
---@field destination LuaEntity @The destination entity settings will be copied to.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field source LuaEntity @The source entity settings will be copied from.
---@field tick uint @Tick the event was generated.
local on_pre_entity_settings_pasted = {}

