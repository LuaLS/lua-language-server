---@meta

---Control behavior for walls.
---@class LuaWallControlBehavior:LuaControlBehavior
---@field circuit_condition CircuitConditionDefinition @The circuit condition.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field open_gate boolean @`[RW]`
---@field output_signal SignalID @`[RW]`
---@field read_sensor boolean @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaWallControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaWallControlBehavior.help() end

