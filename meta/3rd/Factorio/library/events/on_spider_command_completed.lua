---@meta

---Called when a spider finishes moving to its autopilot position.
---@class on_spider_command_completed
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
---@field vehicle LuaEntity @Spider vehicle which was requested to move.
local on_spider_command_completed = {}

