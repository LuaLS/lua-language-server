---@meta

---Called directly after a permission group is deleted.
---@class on_permission_group_deleted
---@field group_name string @The group that was deleted.
---@field id uint @The group id that was deleted.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player doing the deletion.
---@field tick uint @Tick the event was generated.
local on_permission_group_deleted = {}

