---@meta

---Called when the player's driving state has changed, this means a player has either entered or left a vehicle.
---@class on_player_driving_changed_state
---@field entity? LuaEntity @The vehicle if any.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field tick uint @Tick the event was generated.
local on_player_driving_changed_state = {}

