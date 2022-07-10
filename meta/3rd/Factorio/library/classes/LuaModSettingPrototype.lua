---@meta

---Prototype of a mod setting.
---@class LuaModSettingPrototype
---@field allow_blank boolean @If this string setting allows blank values or `nil` if not a string setting.`[R]`
---@field allowed_values string[]|int[]|double[] @The allowed values for this setting or `nil` if this setting doesn't use the a fixed set of values.`[R]`
---@field auto_trim boolean @If this string setting auto-trims values or `nil` if not a string setting.`[R]`
---@field default_value boolean|double|int|string @The default value of this setting.`[R]`
---@field hidden boolean @If this setting is hidden from the GUI.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field maximum_value double|int @The maximum value for this setting or `nil` if this setting type doesn't support a maximum.`[R]`
---@field minimum_value double|int @The minimum value for this setting or `nil` if this setting type doesn't support a minimum.`[R]`
---@field mod string @The mod that owns this setting.`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field setting_type string @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaModSettingPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaModSettingPrototype.help() end

