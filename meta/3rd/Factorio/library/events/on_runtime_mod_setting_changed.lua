---@meta

---Called when a runtime mod setting is changed by a player.
---@class on_runtime_mod_setting_changed
---@field name defines.events @Identifier of the event
---@field player_index? uint @If the `setting_type` is `"global"` and it was changed through the mod settings GUI, this is the index of the player that changed the global setting. If the `setting_type` is `"runtime-per-user"` and it changed a current setting of the player, this is the index of the player whose setting was changed. In all other cases, this is `nil`.
---@field setting string @The prototype name of the setting that was changed.
---@field setting_type string @Either "runtime-per-user" or "runtime-global".
---@field tick uint @Tick the event was generated.
local on_runtime_mod_setting_changed = {}

