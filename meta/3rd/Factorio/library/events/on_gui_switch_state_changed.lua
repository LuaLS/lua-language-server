---@meta

---Called when [LuaGuiElement](LuaGuiElement) switch state is changed (related to switches).
---@class on_gui_switch_state_changed
---@field element LuaGuiElement @The switch whose switch state changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_switch_state_changed = {}

