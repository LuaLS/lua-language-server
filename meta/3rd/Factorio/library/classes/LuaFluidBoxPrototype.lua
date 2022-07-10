---@meta

---A prototype of a fluidbox owned by some [LuaEntityPrototype](LuaEntityPrototype).
---@class LuaFluidBoxPrototype
---@field base_area double @`[R]`
---@field base_level double @`[R]`
---@field entity LuaEntityPrototype @The entity that this belongs to.`[R]`
---@field filter LuaFluidPrototype @The filter or `nil` if no filter is set.`[R]`
---@field height double @`[R]`
---@field index uint @The index of this fluidbox prototype in the owning entity.`[R]`
---@field maximum_temperature double @The maximum temperature or `nil` if none is set.`[R]`
---@field minimum_temperature double @The minimum temperature or `nil` if none is set.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field pipe_connections FluidBoxConnection[] @The pipe connection points.`[R]`
---@field production_type string @The production type. "input", "output", "input-output", or "none".`[R]`
---@field render_layer string @The render layer.`[R]`
---@field secondary_draw_orders int[] @The secondary draw orders for the 4 possible connection directions.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field volume double @`[R]`
local LuaFluidBoxPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaFluidBoxPrototype.help() end

