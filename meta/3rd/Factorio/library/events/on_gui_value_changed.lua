---@meta

---Called when [LuaGuiElement](LuaGuiElement) slider value is changed (related to the slider element).
---@class on_gui_value_changed
---@field element LuaGuiElement @The element whose value changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_value_changed = {}

