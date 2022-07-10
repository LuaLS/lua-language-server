---@meta

---Called when [LuaGuiElement](LuaGuiElement) selection state is changed (related to drop-downs and listboxes).
---@class on_gui_selection_state_changed
---@field element LuaGuiElement @The element whose selection state changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_selection_state_changed = {}

