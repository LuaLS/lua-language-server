---@meta

---Called when a [LuaSurface::request_path](LuaSurface::request_path) call completes.
---@class on_script_path_request_finished
---@field id uint @Handle to associate the callback with a particular call to [LuaSurface::request_path](LuaSurface::request_path).
---@field name defines.events @Identifier of the event
---@field path? PathfinderWaypoint[] @The actual path that the pathfinder has determined. `nil` if pathfinding failed.
---@field tick uint @Tick the event was generated.
---@field try_again_later boolean @Indicates that the pathfinder failed because it is too busy, and that you can retry later.
local on_script_path_request_finished = {}

