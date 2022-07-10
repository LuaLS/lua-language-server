---@meta

---Control behavior for inserters.
---@class LuaInserterControlBehavior:LuaGenericOnOffControlBehavior
---@field circuit_hand_read_mode defines.control_behavior.inserter.hand_read_mode @The hand read mode for the inserter.`[RW]`
---@field circuit_mode_of_operation defines.control_behavior.inserter.circuit_mode_of_operation @The circuit mode of operations for the inserter.`[RW]`
---@field circuit_read_hand_contents boolean @`true` if the contents of the inserter hand should be sent to the circuit network`[RW]`
---@field circuit_set_stack_size boolean @If the stack size of the inserter is set through the circuit network or not.`[RW]`
---@field circuit_stack_control_signal SignalID @The signal used to set the stack size of the inserter.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaInserterControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaInserterControlBehavior.help() end

