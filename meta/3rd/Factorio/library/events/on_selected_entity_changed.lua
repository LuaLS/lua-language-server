---@meta

---Called after the selected entity changes for a given player.
---@class on_selected_entity_changed
---@field last_entity? LuaEntity @The last selected entity if it still exists and there was one.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player whose selected entity changed.
---@field tick uint @Tick the event was generated.
local on_selected_entity_changed = {}

