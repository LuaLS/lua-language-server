---@meta

---Called when a character corpse expires due to timeout or all of the items being removed from it.
---
---this is not called if the corpse is mined. See [defines.events.on_pre_player_mined_item](defines.events.on_pre_player_mined_item) to detect that.
---@class on_character_corpse_expired
---@field corpse LuaEntity @The corpse.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local on_character_corpse_expired = {}

