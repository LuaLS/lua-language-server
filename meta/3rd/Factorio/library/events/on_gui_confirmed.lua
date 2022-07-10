---@meta

---Called when a [LuaGuiElement](LuaGuiElement) is confirmed, for example by pressing Enter in a textfield.
---@class on_gui_confirmed
---@field alt boolean @If alt was pressed.
---@field control boolean @If control was pressed.
---@field element LuaGuiElement @The confirmed element.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the confirming.
---@field shift boolean @If shift was pressed.
---@field tick uint @Tick the event was generated.
local on_gui_confirmed = {}

