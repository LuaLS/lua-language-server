---@meta

---An abstract base class for behaviors that support switching the entity on or off based on some condition.
---@class LuaGenericOnOffControlBehavior:LuaControlBehavior
---The circuit condition.`[RW]`
---
---`condition` may be `nil` in order to clear the circuit condition.
---
---Tell an entity to be active (e.g. a lamp to be lit) when it receives a circuit signal of more than 4 chain signals. 
---```lua
---a_behavior.circuit_condition = {condition={comparator=">",
---                                           first_signal={type="item", name="rail-chain-signal"},
---                                           constant=4}}
---```
---@field circuit_condition CircuitConditionDefinition
---@field connect_to_logistic_network boolean @`true` if this should connect to the logistic network.`[RW]`
---@field disabled boolean @If the entity is currently disabled because of the control behavior.`[R]`
---The logistic condition.`[RW]`
---
---`condition` may be `nil` in order to clear the logistic condition.
---
---Tell an entity to be active (e.g. a lamp to be lit) when the logistics network it's connected to has more than four chain signals. 
---```lua
---a_behavior.logistic_condition = {condition={comparator=">",
---                                            first_signal={type="item", name="rail-chain-signal"},
---                                            constant=4}}
---```
---@field logistic_condition CircuitConditionDefinition
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaGenericOnOffControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaGenericOnOffControlBehavior.help() end

