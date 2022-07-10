---@meta

---Called when an entity of type `radar` finishes scanning a sector. Can be filtered for the radar using [LuaSectorScannedEventFilter](LuaSectorScannedEventFilter).
---@class on_sector_scanned
---@field area BoundingBox @Area of the scanned chunk.
---@field chunk_position ChunkPosition @The chunk scanned.
---@field name defines.events @Identifier of the event
---@field radar LuaEntity @The radar that did the scanning.
---@field tick uint @Tick the event was generated.
local on_sector_scanned = {}

