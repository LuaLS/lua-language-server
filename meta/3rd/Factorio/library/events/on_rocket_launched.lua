---@meta

---Called when the rocket is launched.
---@class on_rocket_launched
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player that is riding the rocket, if any.
---@field rocket LuaEntity
---@field rocket_silo? LuaEntity
---@field tick uint @Tick the event was generated.
local on_rocket_launched = {}

