---@meta

---A static event mods can use to tell other mods they changed tiles on a surface by script. This event is only raised if a mod does so with [LuaBootstrap::raise_event](LuaBootstrap::raise_event) or [LuaBootstrap::raise_script_set_tiles](LuaBootstrap::raise_script_set_tiles), or when `raise_event` is passed to [LuaSurface::set_tiles](LuaSurface::set_tiles).
---@class script_raised_set_tiles
---@field name defines.events @Identifier of the event
---@field surface_index uint @The surface whose tiles were changed.
---@field tick uint @Tick the event was generated.
---@field tiles Tile[] @The tiles that were changed.
local script_raised_set_tiles = {}

