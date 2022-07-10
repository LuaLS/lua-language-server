---@meta

---Control behavior for constant combinators.
---@class LuaConstantCombinatorControlBehavior:LuaControlBehavior
---@field enabled boolean @Turns this constant combinator on and off.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---This constant combinator's parameters, or `nil` if the [item_slot_count](LuaEntityPrototype::item_slot_count) of the combinator's prototype is `0`.`[RW]`
---
---Writing `nil` clears the combinator's parameters.
---@field parameters ConstantCombinatorParameters[]
---@field signals_count uint @The number of signals this constant combinator supports`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaConstantCombinatorControlBehavior = {}

---Gets the signal at the given index. Returned [Signal](Signal) will not contain signal if none is set for the index.
---@param _index uint
---@return Signal
function LuaConstantCombinatorControlBehavior.get_signal(_index) end

---All methods and properties that this object supports.
---@return string
function LuaConstantCombinatorControlBehavior.help() end

---Sets the signal at the given index
---@param _index uint
---@param _signal Signal
function LuaConstantCombinatorControlBehavior.set_signal(_index, _signal) end

