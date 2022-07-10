---@meta

---Called directly after a permission group is edited in some way.
---@class on_permission_group_edited
---@field action defines.input_action @The action when the `type` is "add-permission" or "remove-permission".
---@field group LuaPermissionGroup @The group being edited.
---@field name defines.events @Identifier of the event
---@field new_name string @The new group name when the `type` is "rename".
---@field old_name string @The old group name when the `type` is "rename".
---@field other_player_index uint @The other player when the `type` is "add-player" or "remove-player".
---@field player_index uint @The player that did the editing.
---@field tick uint @Tick the event was generated.
---@field type string @The edit type: "add-permission", "remove-permission", "enable-all", "disable-all", "add-player", "remove-player", "rename".
local on_permission_group_edited = {}

