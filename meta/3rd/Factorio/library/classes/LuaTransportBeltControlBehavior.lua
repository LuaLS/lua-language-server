---@meta

---Control behavior for transport belts.
---@class LuaTransportBeltControlBehavior:LuaGenericOnOffControlBehavior
---@field enable_disable boolean @If the belt will be enabled/disabled based off the circuit network.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field read_contents boolean @If the belt will read the contents and send them to the circuit network.`[RW]`
---@field read_contents_mode defines.control_behavior.transport_belt.content_read_mode @The read mode for the belt.`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaTransportBeltControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaTransportBeltControlBehavior.help() end

