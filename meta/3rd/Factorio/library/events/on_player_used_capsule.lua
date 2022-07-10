---@meta

---Called when a player uses a capsule that results in some game action.
---@class on_player_used_capsule
---@field item LuaItemPrototype @The capsule item used.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player.
---@field position MapPosition @The position the capsule was used.
---@field tick uint @Tick the event was generated.
local on_player_used_capsule = {}

