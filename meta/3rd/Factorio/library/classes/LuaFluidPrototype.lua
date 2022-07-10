---@meta

---Prototype of a fluid.
---@class LuaFluidPrototype
---@field base_color Color @`[R]`
---@field default_temperature double @Default temperature of this fluid.`[R]`
---@field emissions_multiplier double @A multiplier on the amount of emissions produced when this fluid is burnt in a generator. A value above `1.0` increases emissions and vice versa. The multiplier can't be negative.`[R]`
---@field flow_color Color @`[R]`
---@field fuel_value double @The amount of energy in Joules one unit of this fluid will produce when burnt in a generator. A value of `0` means this fluid can't be used for energy generation. The value can't be negative.`[R]`
---@field gas_temperature double @The temperature above which this fluid will be shown as gaseous inside tanks and pipes.`[R]`
---@field group LuaGroup @Group of this prototype.`[R]`
---@field heat_capacity double @The amount of energy in Joules required to heat one unit of this fluid by 1°C.`[R]`
---@field hidden boolean @Whether this fluid is hidden from the fluid and signal selectors.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field max_temperature double @Maximum temperature this fluid can reach.`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field subgroup LuaGroup @Subgroup of this prototype.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaFluidPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaFluidPrototype.help() end

