---@meta

---Called when a train changes state (started to stopped and vice versa)
---@class on_train_changed_state
---@field name defines.events @Identifier of the event
---@field old_state defines.train_state
---@field tick uint @Tick the event was generated.
---@field train LuaTrain
local on_train_changed_state = {}

