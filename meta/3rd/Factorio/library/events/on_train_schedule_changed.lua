---@meta

---Called when a trains schedule is changed either by the player or through script.
---@class on_train_schedule_changed
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player who made the change if any.
---@field tick uint @Tick the event was generated.
---@field train LuaTrain
local on_train_schedule_changed = {}

