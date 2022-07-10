---@meta

---Called when the display resolution changes for a given player.
---@class on_player_display_resolution_changed
---@field name defines.events @Identifier of the event
---@field old_resolution DisplayResolution @The old display resolution
---@field player_index uint @The player
---@field tick uint @Tick the event was generated.
local on_player_display_resolution_changed = {}

