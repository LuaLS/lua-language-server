---@meta

---Called when the player uses the 'Open item GUI' control on an item defined with the 'mod-openable' flag
---@class on_mod_item_opened
---@field item LuaItemPrototype @The item clicked on.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player.
---@field tick uint @Tick the event was generated.
local on_mod_item_opened = {}

