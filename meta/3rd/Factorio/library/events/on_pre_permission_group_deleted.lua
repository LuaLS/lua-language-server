---@meta

---Called directly before a permission group is deleted.
---@class on_pre_permission_group_deleted
---@field group LuaPermissionGroup @The group to be deleted.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player doing the deletion.
---@field tick uint @Tick the event was generated.
local on_pre_permission_group_deleted = {}

