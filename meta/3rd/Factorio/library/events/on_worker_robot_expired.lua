---@meta

---Called when a worker (construction or logistic) robot expires through a lack of energy.
---@class on_worker_robot_expired
---@field name defines.events @Identifier of the event
---@field robot LuaEntity
---@field tick uint @Tick the event was generated.
local on_worker_robot_expired = {}

