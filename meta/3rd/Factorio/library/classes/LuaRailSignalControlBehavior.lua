---@meta

---Control behavior for rail signals.
---@class LuaRailSignalControlBehavior:LuaControlBehavior
---@field circuit_condition CircuitConditionDefinition @The circuit condition when controlling the signal through the circuit network.`[RW]`
---@field close_signal boolean @If this will close the rail signal based off the circuit condition.`[RW]`
---@field green_signal SignalID @`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field orange_signal SignalID @`[RW]`
---@field read_signal boolean @If this will read the rail signal state.`[RW]`
---@field red_signal SignalID @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRailSignalControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaRailSignalControlBehavior.help() end

