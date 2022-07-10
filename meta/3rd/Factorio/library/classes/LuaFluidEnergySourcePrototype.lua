---@meta

---Prototype of a fluid energy source.
---@class LuaFluidEnergySourcePrototype
---@field burns_fluid boolean @`[R]`
---@field destroy_non_fuel_fluid boolean @`[R]`
---@field effectivity double @`[R]`
---@field emissions double @`[R]`
---@field fluid_box LuaFluidBoxPrototype @The fluid box for this energy source.`[R]`
---@field fluid_usage_per_tick double @`[R]`
---@field maximum_temperature double @`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field render_no_network_icon boolean @`[R]`
---@field render_no_power_icon boolean @`[R]`
---@field scale_fluid_usage boolean @`[R]`
---@field smoke SmokeSource[] @The smoke sources for this prototype if any.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaFluidEnergySourcePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaFluidEnergySourcePrototype.help() end

