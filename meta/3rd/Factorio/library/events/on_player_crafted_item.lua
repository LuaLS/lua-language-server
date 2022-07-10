---@meta

---Called when the player finishes crafting an item. This event fires just before the results are inserted into the player's inventory, not when the crafting is queued (see [on_pre_player_crafted_item](on_pre_player_crafted_item)).
---@class on_player_crafted_item
---@field item_stack LuaItemStack @The item that has been crafted.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player doing the crafting.
---@field recipe LuaRecipe @The recipe used to craft this item.
---@field tick uint @Tick the event was generated.
local on_player_crafted_item = {}

