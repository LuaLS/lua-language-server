---@meta

---Called before one or more chunks are deleted using [LuaSurface::delete_chunk](LuaSurface::delete_chunk).
---@class on_pre_chunk_deleted
---@field name defines.events @Identifier of the event
---@field positions ChunkPosition[] @The chunks to be deleted.
---@field surface_index uint
---@field tick uint @Tick the event was generated.
local on_pre_chunk_deleted = {}

