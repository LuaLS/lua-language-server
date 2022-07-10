---@meta

---Called when a player is banned.
---@class on_player_banned
---@field by_player? uint @The player that did the banning if any.
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player banned.
---@field player_name string @The banned player name.
---@field reason? string @The reason given if any.
---@field tick uint @Tick the event was generated.
local on_player_banned = {}

