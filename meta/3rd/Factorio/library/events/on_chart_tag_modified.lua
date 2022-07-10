---@meta

---Called when a chart tag is modified by a player.
---@class on_chart_tag_modified
---@field force LuaForce
---@field name defines.events @Identifier of the event
---@field old_icon? SignalID
---@field old_player? uint
---@field old_text string
---@field player_index? uint
---@field tag LuaCustomChartTag
---@field tick uint @Tick the event was generated.
local on_chart_tag_modified = {}

