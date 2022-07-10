---@meta

---Called when a chunk is charted or re-charted.
---@class on_chunk_charted
---@field area BoundingBox @Area of the chunk.
---@field force LuaForce
---@field name defines.events @Identifier of the event
---@field position ChunkPosition
---@field surface_index uint
---@field tick uint @Tick the event was generated.
local on_chunk_charted = {}

