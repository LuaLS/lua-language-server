---@meta

---Called when [LuaGuiElement](LuaGuiElement) text is changed by the player.
---@class on_gui_text_changed
---@field element LuaGuiElement @The edited element.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the edit.
---@field text string @The new text in the element.
---@field tick uint @Tick the event was generated.
local on_gui_text_changed = {}

