---@meta

---Called when an entity is marked for upgrade with the Upgrade planner or via script. Can be filtered using [LuaEntityMarkedForUpgradeEventFilter](LuaEntityMarkedForUpgradeEventFilter).
---@class on_marked_for_upgrade
---@field direction? defines.direction @The new direction (if any)
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field player_index? uint
---@field target LuaEntityPrototype
---@field tick uint @Tick the event was generated.
local on_marked_for_upgrade = {}

