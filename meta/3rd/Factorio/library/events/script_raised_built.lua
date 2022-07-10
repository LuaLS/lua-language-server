---@meta

---A static event mods can use to tell other mods they built something by script. This event is only raised if a mod does so with [LuaBootstrap::raise_event](LuaBootstrap::raise_event) or [LuaBootstrap::raise_script_built](LuaBootstrap::raise_script_built), or when `raise_built` is passed to [LuaSurface::create_entity](LuaSurface::create_entity). Can be filtered using [LuaScriptRaisedBuiltEventFilter](LuaScriptRaisedBuiltEventFilter).
---@class script_raised_built
---@field entity LuaEntity @The entity that has been built.
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local script_raised_built = {}

