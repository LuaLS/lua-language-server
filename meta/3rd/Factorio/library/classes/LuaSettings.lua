---@meta

---Object containing mod settings of three distinct types: `startup`, `global`, and `player`. An instance of LuaSettings is available through the global object named `settings`.
---@class LuaSettings
---The current global mod settings, indexed by prototype name.
---
---Even though these are marked as read-only, they can be changed by overwriting individual [ModSetting](ModSetting) tables in the custom table. Mods can only change their own settings. Using the in-game console, all global settings can be changed.`[R]`
---@field global table<string, ModSetting>
---@field object_name string @This object's name.`[R]`
---The default player mod settings for this map, indexed by prototype name.
---
---Even though these are marked as read-only, they can be changed by overwriting individual [ModSetting](ModSetting) tables in the custom table. Mods can only change their own settings. Using the in-game console, all player settings can be changed.`[R]`
---@field player table<string, ModSetting>
---@field startup table<string, ModSetting> @The startup mod settings, indexed by prototype name.`[R]`
local LuaSettings = {}

---Gets the current per-player settings for the given player, indexed by prototype name. Returns the same structure as [LuaPlayer::mod_settings](LuaPlayer::mod_settings).
---
---This table will become invalid if its associated player does.
---@param _player PlayerIdentification
---@return table<string, ModSetting>
function LuaSettings.get_player_settings(_player) end

