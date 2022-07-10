---@meta

---Called when research is cancelled.
---@class on_research_cancelled
---@field force LuaForce @The force whose research was cancelled.
---@field name defines.events @Identifier of the event
---@field research table<string, uint> @A mapping of technology name to how many times it was cancelled.
---@field tick uint @Tick the event was generated.
local on_research_cancelled = {}

