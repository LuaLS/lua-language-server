---@meta

---Called when a player cancels crafting.
---@class on_player_cancelled_crafting
---@field cancel_count uint @The number of crafts that have been cancelled.
---@field items LuaInventory @The crafting items returned to the player's inventory.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player that did the crafting.
---@field recipe LuaRecipe @The recipe that has been cancelled.
---@field tick uint @Tick the event was generated.
local on_player_cancelled_crafting = {}

