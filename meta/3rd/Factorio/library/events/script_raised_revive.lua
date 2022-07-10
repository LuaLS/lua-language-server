---@meta

---A static event mods can use to tell other mods they revived something by script. This event is only raised if a mod does so with [LuaBootstrap::raise_event](LuaBootstrap::raise_event) or [LuaBootstrap::raise_script_revive](LuaBootstrap::raise_script_revive), or when `raise_revive` is passed to [LuaEntity::revive](LuaEntity::revive). Can be filtered using [LuaScriptRaisedReviveEventFilter](LuaScriptRaisedReviveEventFilter).
---@class script_raised_revive
---@field entity LuaEntity @The entity that was revived.
---@field name defines.events @Identifier of the event
---@field tags? Tags @The tags associated with this entity, if any.
---@field tick uint @Tick the event was generated.
local script_raised_revive = {}

