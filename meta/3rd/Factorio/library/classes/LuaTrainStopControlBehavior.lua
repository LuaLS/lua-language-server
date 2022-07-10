---@meta

---Control behavior for train stops.
---@class LuaTrainStopControlBehavior:LuaGenericOnOffControlBehavior
---@field enable_disable boolean @`true` if the train stop is enabled/disabled through the circuit network.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field read_from_train boolean @`true` if the train stop should send the train contents to the circuit network.`[RW]`
---@field read_stopped_train boolean @`true` if the train stop should send the stopped train id to the circuit network.`[RW]`
---@field read_trains_count boolean @`true` if the train stop should send amount of incoming trains to the circuit network.`[RW]`
---@field send_to_train boolean @`true` if the train stop should send the circuit network contents to the train to use.`[RW]`
---@field set_trains_limit boolean @`true` if the trains_limit_signal is used to set a limit of trains incoming for train stop.`[RW]`
---@field stopped_train_signal SignalID @The signal that will be sent when using the send-train-id option.`[RW]`
---@field trains_count_signal SignalID @The signal that will be sent when using the read-trains-count option.`[RW]`
---@field trains_limit_signal SignalID @The signal to be used by set-trains-limit to limit amount of incoming trains`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaTrainStopControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaTrainStopControlBehavior.help() end

