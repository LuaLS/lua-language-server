---@meta

---Called when a player uses spidertron remote to send a spidertron to a given position
---@class on_player_used_spider_remote
---@field name defines.events @Identifier of the event
---@field player_index uint @The player that used the remote.
---@field position MapPosition @Goal position to which spidertron was sent to.
---@field success boolean @If the use was successful. It may fail when spidertron has different driver or when player is on different surface.
---@field tick uint @Tick the event was generated.
---@field vehicle LuaEntity @Spider vehicle which was requested to move.
local on_player_used_spider_remote = {}

