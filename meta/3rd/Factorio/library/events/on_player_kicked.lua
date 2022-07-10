---@meta

---Called when a player is kicked.
---@class on_player_kicked
---@field by_player? uint @The player that did the kicking if any.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player kicked.
---@field reason? string @The reason given if any.
---@field tick uint @Tick the event was generated.
local on_player_kicked = {}

