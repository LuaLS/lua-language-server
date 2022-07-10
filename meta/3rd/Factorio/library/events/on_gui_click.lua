---@meta

---Called when [LuaGuiElement](LuaGuiElement) is clicked.
---@class on_gui_click
---@field alt boolean @If alt was pressed.
---@field button defines.mouse_button_type @The mouse button used if any.
---@field control boolean @If control was pressed.
---@field element LuaGuiElement @The clicked element.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the clicking.
---@field shift boolean @If shift was pressed.
---@field tick uint @Tick the event was generated.
local on_gui_click = {}

