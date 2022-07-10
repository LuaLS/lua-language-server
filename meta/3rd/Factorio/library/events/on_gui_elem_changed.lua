---@meta

---Called when [LuaGuiElement](LuaGuiElement) element value is changed (related to choose element buttons).
---@class on_gui_elem_changed
---@field element LuaGuiElement @The element whose element value changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_elem_changed = {}

