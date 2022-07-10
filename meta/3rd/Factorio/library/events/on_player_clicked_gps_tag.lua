---@meta

---Called when a player clicks a gps tag
---@class on_player_clicked_gps_tag
---@field name defines.events @Identifier of the event
---@field player_index uint @Index of the player
---@field position MapPosition @Map position contained in gps tag
---@field surface string @Surface name contained in gps tag, even when such surface does not exists
---@field tick uint @Tick the event was generated.
local on_player_clicked_gps_tag = {}

