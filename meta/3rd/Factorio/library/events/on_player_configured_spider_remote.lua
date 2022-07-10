---@meta

---Called when a player configures spidertron remote to be connected with a given spidertron
---@class on_player_configured_spider_remote
---@field name defines.events @Identifier of the event
---@field player_index uint @The player that configured the remote.
---@field tick uint @Tick the event was generated.
---@field vehicle LuaEntity @Spider vehicle to which remote was connected to.
local on_player_configured_spider_remote = {}

