---@meta

---It is fired once every tick. Since this event is fired every tick, its handler shouldn't include performance heavy code.
---@class on_tick
---@field name defines.events @Identifier of the event
---@field tick uint @Tick the event was generated.
local on_tick = {}

