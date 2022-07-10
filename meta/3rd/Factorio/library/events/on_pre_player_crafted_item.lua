---@meta

---Called when a player queues something to be crafted.
---@class on_pre_player_crafted_item
---@field items LuaInventory @The items removed from the players inventory to do the crafting.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player doing the crafting.
---@field queued_count uint @The number of times the recipe is being queued.
---@field recipe LuaRecipe @The recipe being queued.
---@field tick uint @Tick the event was generated.
local on_pre_player_crafted_item = {}

