---@meta

---Called when [LuaGuiElement](LuaGuiElement) element location is changed (related to frames in `player.gui.screen`).
---@class on_gui_location_changed
---@field element LuaGuiElement @The element whose location changed.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the change.
---@field tick uint @Tick the event was generated.
local on_gui_location_changed = {}

