---@meta

---Called just before a chart tag is deleted.
---@class on_chart_tag_removed
---@field force LuaForce
---@field name defines.events @Identifier of the event
---@field player_index? uint
---@field tag LuaCustomChartTag
---@field tick uint @Tick the event was generated.
local on_chart_tag_removed = {}

