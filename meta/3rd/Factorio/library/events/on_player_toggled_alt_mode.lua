---@meta

---Called when a player toggles alt mode, also known as "show entity info".
---@class on_player_toggled_alt_mode
---@field alt_mode boolean @The new alt mode value. This value is a shortcut for accessing [GameViewSettings::show_entity_info](GameViewSettings::show_entity_info) on the player.
---@field name defines.events @Identifier of the event
---@field player_index uint
---@field tick uint @Tick the event was generated.
local on_player_toggled_alt_mode = {}

