---@meta

---Prototype of a burner energy source.
---@class LuaBurnerPrototype
---@field burnt_inventory_size uint @`[R]`
---@field effectivity double @`[R]`
---@field emissions double @`[R]`
---`[R]`
---
---The value in the dictionary is meaningless and exists just to allow the dictionary type for easy lookup.
---@field fuel_categories table<string, boolean>
---@field fuel_inventory_size uint @`[R]`
---@field light_flicker LuaBurnerPrototype.light_flicker @The light flicker definition for this burner prototype if any.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field render_no_network_icon boolean @`[R]`
---@field render_no_power_icon boolean @`[R]`
---@field smoke SmokeSource[] @The smoke sources for this burner prototype if any.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaBurnerPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaBurnerPrototype.help() end


---@class LuaBurnerPrototype.light_flicker
---@field border_fix_speed float
---@field color Color
---@field derivation_change_deviation float
---@field derivation_change_frequency float
---@field light_intensity_to_size_coefficient float
---@field maximum_intensity float
---@field minimum_intensity float
---@field minimum_light_size float

