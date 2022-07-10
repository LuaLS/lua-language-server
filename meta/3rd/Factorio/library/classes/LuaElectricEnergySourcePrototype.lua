---@meta

---Prototype of an electric energy source.
---@class LuaElectricEnergySourcePrototype
---@field buffer_capacity double @`[R]`
---@field drain double @`[R]`
---@field emissions double @`[R]`
---@field input_flow_limit double @`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field output_flow_limit double @`[R]`
---@field render_no_network_icon boolean @`[R]`
---@field render_no_power_icon boolean @`[R]`
---@field usage_priority string @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaElectricEnergySourcePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaElectricEnergySourcePrototype.help() end

