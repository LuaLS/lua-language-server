---@meta

---A circuit network associated with a given entity, connector, and wire type.
---@class LuaCircuitNetwork
---@field circuit_connector_id defines.circuit_connector_id @The circuit connector ID on the associated entity this network was gotten from.`[R]`
---@field connected_circuit_count uint @The number of circuits connected to this network.`[R]`
---@field entity LuaEntity @The entity this circuit network reference is associated with`[R]`
---@field network_id uint @The circuit networks ID.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field signals Signal[] @The circuit network signals last tick. `nil` if there are no signals.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field wire_type defines.wire_type @The wire type this network is associated with.`[R]`
local LuaCircuitNetwork = {}

---@param _signal SignalID @The signal to read.
---@return int @The current value of the signal.
function LuaCircuitNetwork.get_signal(_signal) end

---All methods and properties that this object supports.
---@return string
function LuaCircuitNetwork.help() end

