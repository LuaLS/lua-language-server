---@meta

---Called when a script trigger effect is triggered.
---@class on_script_trigger_effect
---@field effect_id string @The effect_id specified in the trigger effect.
---@field name defines.events @Identifier of the event
---@field source_entity? LuaEntity
---@field source_position? MapPosition
---@field surface_index uint @The surface the effect happened on.
---@field target_entity? LuaEntity
---@field target_position? MapPosition
---@field tick uint @Tick the event was generated.
local on_script_trigger_effect = {}

