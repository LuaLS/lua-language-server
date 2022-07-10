---@meta

---Prototype of a heat buffer.
---@class LuaHeatBufferPrototype
---@field connections HeatConnection[] @`[R]`
---@field default_temperature double @`[R]`
---@field max_temperature double @`[R]`
---@field max_transfer double @`[R]`
---@field min_temperature_gradient double @`[R]`
---@field min_working_temperature double @`[R]`
---@field minimum_glow_temperature double @`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field specific_heat double @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaHeatBufferPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaHeatBufferPrototype.help() end

