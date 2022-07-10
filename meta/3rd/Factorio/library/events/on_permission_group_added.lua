---@meta

---Called directly after a permission group is added.
---@class on_permission_group_added
---@field group LuaPermissionGroup @The group added.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player that added the group.
---@field tick uint @Tick the event was generated.
local on_permission_group_added = {}

