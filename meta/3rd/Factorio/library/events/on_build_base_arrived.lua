---@meta

---Called when a [defines.command.build_base](defines.command.build_base) command reaches its destination, and before building starts.
---@class on_build_base_arrived
---@field group? LuaUnitGroup @The unit group the command was assigned to.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
---@field unit? LuaEntity @The unit the command was assigned to.
local on_build_base_arrived = {}

