---@meta

---Called when a rocket silo is ordered to be launched.
---@class on_rocket_launch_ordered
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player that is riding the rocket, if any.
---@field rocket LuaEntity
---@field rocket_silo LuaEntity
---@field tick uint @Tick the event was generated.
local on_rocket_launch_ordered = {}

