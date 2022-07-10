---@meta

---Called when the upgrade of an entity is canceled. Can be filtered using [LuaUpgradeCancelledEventFilter](LuaUpgradeCancelledEventFilter).
---@class on_cancelled_upgrade
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field player_index? uint
---@field tick uint @Tick the event was generated.
local on_cancelled_upgrade = {}

