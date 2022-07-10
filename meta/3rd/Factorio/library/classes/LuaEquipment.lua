---@meta

---An item in a [LuaEquipmentGrid](LuaEquipmentGrid), for example a fusion reactor placed in one's power armor.
---
---An equipment reference becomes invalid once the equipment is removed or the equipment grid it resides in is destroyed.
---@class LuaEquipment
---@field burner LuaBurner @The burner energy source for this equipment or `nil` if there isn't one.`[R]`
---@field energy double @Current available energy.`[RW]`
---@field generator_power double @Energy generated per tick.`[R]`
---@field max_energy double @Maximum amount of energy that can be stored in this equipment.`[R]`
---@field max_shield double @Maximum shield value.`[R]`
---@field max_solar_power double @Maximum solar power generated.`[R]`
---@field movement_bonus double @Movement speed bonus.`[R]`
---@field name string @Name of this equipment.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field position EquipmentPosition @Position of this equipment in the equipment grid.`[R]`
---@field prototype LuaEquipmentPrototype @`[R]`
---@field shape LuaEquipment.shape @Shape of this equipment.`[R]`
---Current shield value of the equipment.`[RW]`
---
---Can't be set higher than [LuaEquipment::max_shield](LuaEquipment::max_shield).
---@field shield double
---@field type string @Type of this equipment.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaEquipment = {}

---All methods and properties that this object supports.
---@return string
function LuaEquipment.help() end


---@class LuaEquipment.shape
---@field height uint
---@field width uint

