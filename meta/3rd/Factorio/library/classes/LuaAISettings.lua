---@meta

---Collection of settings for overriding default ai behavior.
---@class LuaAISettings
---@field allow_destroy_when_commands_fail boolean @If enabled, units that repeatedly fail to succeed at commands will be destroyed.`[RW]`
---@field allow_try_return_to_spawner boolean @If enabled, units that have nothing else to do will attempt to return to a spawner.`[RW]`
---@field do_separation boolean @If enabled, units will try to separate themselves from nearby friendly units.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field path_resolution_modifier int8 @The pathing resolution modifier, must be between -8 and 8.`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaAISettings = {}

---All methods and properties that this object supports.
---@return string
function LuaAISettings.help() end

