---@meta

---Called when [LuaGuiElement](LuaGuiElement) selected tab is changed (related to tabbed-panes).
---@class on_gui_selected_tab_changed
---@field element LuaGuiElement @The tabbed pane whose selected tab changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_selected_tab_changed = {}

