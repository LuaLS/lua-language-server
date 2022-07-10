---@meta

---Called after a player purchases some offer from a `market` entity.
---@class on_market_item_purchased
---@field count uint @The amount of offers purchased.
---@field market LuaEntity @The market entity.
---@field name defines.events @Identifier of the event
---@field offer_index uint @The index of the offer purchased.
---@field player_index uint @The player who did the purchasing.
---@field tick uint @Tick the event was generated.
local on_market_item_purchased = {}

