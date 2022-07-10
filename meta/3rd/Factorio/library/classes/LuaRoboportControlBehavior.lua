---@meta

---Control behavior for roboports.
---@class LuaRoboportControlBehavior:LuaControlBehavior
---@field available_construction_output_signal SignalID @`[RW]`
---@field available_logistic_output_signal SignalID @`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field read_logistics boolean @`true` if the roboport should report the logistics network content to the circuit network.`[RW]`
---@field read_robot_stats boolean @`true` if the roboport should report the robot statistics to the circuit network.`[RW]`
---@field total_construction_output_signal SignalID @`[RW]`
---@field total_logistic_output_signal SignalID @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRoboportControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaRoboportControlBehavior.help() end

