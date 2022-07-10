---@meta

---A reference to the burner energy source owned by a specific [LuaEntity](LuaEntity) or [LuaEquipment](LuaEquipment).
---@class LuaBurner
---@field burnt_result_inventory LuaInventory @The burnt result inventory.`[R]`
---The currently burning item, or `nil` if no item is burning.`[RW]`
---
---Writing to this automatically handles correcting [LuaBurner::remaining_burning_fuel](LuaBurner::remaining_burning_fuel).
---@field currently_burning LuaItemPrototype
---The fuel categories this burner uses.`[R]`
---
---The value in the dictionary is meaningless and exists just to allow the dictionary type for easy lookup.
---@field fuel_categories table<string, boolean>
---@field heat double @The current heat (energy) stored in this burner.`[RW]`
---@field heat_capacity double @The maximum heat (maximum energy) that this burner can store.`[R]`
---@field inventory LuaInventory @The fuel inventory.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity|LuaEquipment @The owner of this burner energy source`[R]`
---The amount of energy left in the currently-burning fuel item.`[RW]`
---
---Writing to this will silently do nothing if there's no [LuaBurner::currently_burning](LuaBurner::currently_burning) set.
---@field remaining_burning_fuel double
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaBurner = {}

---All methods and properties that this object supports.
---@return string
function LuaBurner.help() end

