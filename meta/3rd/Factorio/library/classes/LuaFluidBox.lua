---@meta

---An array of fluid boxes of an entity. Entities may contain more than one fluid box, and some can change the number of fluid boxes -- for instance, an assembling machine will change its number of fluid boxes depending on its active recipe.
---
---See [Fluid](Fluid)
---
---Do note that reading from a [LuaFluidBox](LuaFluidBox) creates a new table and writing will copy the given fields from the table into the engine's own fluid box structure. Therefore, the correct way to update a fluidbox of an entity is to read it first, modify the table, then write the modified table back. Directly accessing the returned table's attributes won't have the desired effect.
---
---Double the temperature of the fluid in `entity`'s first fluid box. 
---```lua
---fluid = entity.fluidbox[1]
---fluid.temperature = fluid.temperature * 2
---entity.fluidbox[1] = fluid
---```
---@class LuaFluidBox
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity @The entity that owns this fluidbox.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field [number] Fluid @Access, set or clear a fluid box. The index must always be in bounds (see [LuaFluidBox::operator #](LuaFluidBox::operator #)). New fluidboxes may not be added or removed using this operator. If the given fluid box doesn't contain any fluid, `nil` is returned. Similarly, `nil` can be written to a fluid box to remove all fluid from it.`[R]`
local LuaFluidBox = {}

---Flushes all fluid from this fluidbox and its fluid system.
---@param _index uint
---@param _fluid? FluidIdentification @If provided, only this fluid is flushed.
---@return table<string, float> @The removed fluid.
function LuaFluidBox.flush(_index, _fluid) end

---The capacity of the given fluidbox index.
---@param _index uint
---@return double
function LuaFluidBox.get_capacity(_index) end

---The fluidboxes to which the fluidbox at the given index is connected.
---@param _index uint
---@return LuaFluidBox[]
function LuaFluidBox.get_connections(_index) end

---Get a fluid box filter
---@param _index uint @The index of the filter to get.
---@return FluidBoxFilter @The filter at the requested index, or `nil` if there isn't one.
function LuaFluidBox.get_filter(_index) end

---Flow through the fluidbox in the last tick. It is the larger of in-flow and out-flow.
---
---Fluid wagons do not track it and will return 0.
---@param _index uint
---@return double
function LuaFluidBox.get_flow(_index) end

---Gets unique fluid system identifier of selected fluid box. May return nil for fluid wagon, fluid turret's internal buffer or a fluidbox which does not belong to a fluid system
---@param _index uint
---@return uint
function LuaFluidBox.get_fluid_system_id(_index) end

---Returns the fluid the fluidbox is locked onto
---@param _index uint
---@return string @`nil` if the fluidbox is not locked to any fluid.
function LuaFluidBox.get_locked_fluid(_index) end

---The prototype of this fluidbox index.
---@param _index uint
---@return LuaFluidBoxPrototype
function LuaFluidBox.get_prototype(_index) end

---All methods and properties that this object supports.
---@return string
function LuaFluidBox.help() end

---Set a fluid box filter.
---
---Some entities cannot have their fluidbox filter set, notably fluid wagons and crafting machines.
---@param _index uint @The index of the filter to set.
---@param _filter? FluidBoxFilterSpec @The filter to set. Setting `nil` clears the filter.
---@return boolean @Whether the filter was set successfully.
function LuaFluidBox.set_filter(_index, _filter) end

