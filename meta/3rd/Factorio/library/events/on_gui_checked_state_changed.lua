---@meta

---Called when [LuaGuiElement](LuaGuiElement) checked state is changed (related to checkboxes and radio buttons).
---@class on_gui_checked_state_changed
---@field element LuaGuiElement @The element whose checked state changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_checked_state_changed = {}

