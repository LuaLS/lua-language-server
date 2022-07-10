---@meta

---Called when a player is un-banned.
---@class on_player_unbanned
---@field by_player? uint @The player that did the un-banning if any.
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player un-banned.
---@field player_name string @The player name un-banned.
---@field reason? string @The reason the player was banned if any.
---@field tick uint @Tick the event was generated.
local on_player_unbanned = {}

