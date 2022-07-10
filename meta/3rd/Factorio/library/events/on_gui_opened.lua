---@meta

---Called when the player opens a GUI.
---@class on_gui_opened
---@field element? LuaGuiElement @The custom GUI element that was opened
---@field entity? LuaEntity @The entity that was opened
---@field equipment? LuaEquipment @The equipment that was opened
---@field gui_type defines.gui_type @The GUI type that was opened.
---@field item? LuaItemStack @The item that was opened
---@field name defines.events @Identifier of the event
---@field other_player? LuaPlayer @The other player that was opened
---@field player_index uint @The player.
---@field tick uint @Tick the event was generated.
local on_gui_opened = {}

