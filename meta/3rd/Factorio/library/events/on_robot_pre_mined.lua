---@meta

---Called before a robot mines an entity. Can be filtered using [LuaPreRobotMinedEntityEventFilter](LuaPreRobotMinedEntityEventFilter).
---@class on_robot_pre_mined
---@field entity LuaEntity @The entity which is about to be mined.
---@field name defines.events @Identifier of the event
---@field robot LuaEntity @The robot that's about to do the mining.
---@field tick uint @Tick the event was generated.
local on_robot_pre_mined = {}

