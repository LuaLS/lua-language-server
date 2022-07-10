---@meta

---Called when a research is reversed (unresearched).
---@class on_research_reversed
---@field by_script boolean @If the technology was un-researched by script.
---@field name defines.events @Identifier of the event
---@field research LuaTechnology @The technology un-researched
---@field tick uint @Tick the event was generated.
local on_research_reversed = {}

