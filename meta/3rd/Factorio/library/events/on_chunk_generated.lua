---@meta

---Called when a chunk is generated.
---@class on_chunk_generated
---@field area BoundingBox @Area of the chunk.
---@field name defines.events @Identifier of the event
---@field position ChunkPosition @Position of the chunk.
---@field surface LuaSurface @The surface the chunk is on.
---@field tick uint @Tick the event was generated.
local on_chunk_generated = {}

