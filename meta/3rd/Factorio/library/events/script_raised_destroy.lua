---@meta

---A static event mods can use to tell other mods they destroyed something by script. This event is only raised if a mod does so with [LuaBootstrap::raise_event](LuaBootstrap::raise_event) or [LuaBootstrap::raise_script_destroy](LuaBootstrap::raise_script_destroy), or when `raise_destroy` is passed to [LuaEntity::destroy](LuaEntity::destroy). Can be filtered using [LuaScriptRaisedDestroyEventFilter](LuaScriptRaisedDestroyEventFilter).
---@class script_raised_destroy
---@field entity LuaEntity @The entity that was destroyed.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local script_raised_destroy = {}

