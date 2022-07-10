---@meta

---Called when a new train is created either through disconnecting/connecting an existing one or building a new one.
---@class on_train_created
---@field name defines.events @Identifier of the event
---@field old_train_id_1? uint @The first old train id when splitting/merging trains.
---@field old_train_id_2? uint @The second old train id when splitting/merging trains.
---@field tick uint @Tick the event was generated.
---@field train LuaTrain
local on_train_created = {}

