---@meta

---Called when a player invokes the "smart pipette" over an entity.
---@class on_player_pipette
---@field item LuaItemPrototype @The item put in the cursor
---@field name defines.events @Identifier of the event
---@field player_index uint @The player
---@field tick uint @Tick the event was generated.
---@field used_cheat_mode boolean @If cheat mode was used to give a free stack of the item.
local on_player_pipette = {}

