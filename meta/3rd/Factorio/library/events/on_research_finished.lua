---@meta

---Called when a research finishes.
---@class on_research_finished
---@field by_script boolean @If the technology was researched by script.
---@field name defines.events @Identifier of the event
---@field research LuaTechnology @The researched technology
---@field tick uint @Tick the event was generated.
local on_research_finished = {}

