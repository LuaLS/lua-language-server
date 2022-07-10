---@meta

---A train. Trains are a sequence of connected rolling stocks -- locomotives and wagons.
---@class LuaTrain
---@field back_rail LuaEntity @The rail at the back end of the train, possibly `nil`.`[R]`
---@field back_stock LuaEntity @The back stock of this train, or `nil`. The back of the train is at the opposite end of the [front](LuaTrain::front_stock).`[R]`
---@field cargo_wagons LuaEntity[] @The cargo carriages the train contains.`[R]`
---@field carriages LuaEntity[] @The rolling stocks this train is composed of, with the numbering starting at the [front](LuaTrain::front_stock) of the train.`[R]`
---@field fluid_wagons LuaEntity[] @The fluid carriages the train contains.`[R]`
---@field front_rail LuaEntity @The rail at the front end of the train, possibly `nil`.`[R]`
---@field front_stock LuaEntity @The front stock of this train, or `nil`. The front of the train is in the direction that a majority of locomotives are pointing in. If it's a tie, the North and West directions take precedence.`[R]`
---@field has_path boolean @If this train has a path.`[R]`
---@field id uint @The unique train ID.`[R]`
---@field kill_count uint @The total number of kills by this train.`[R]`
---The players killed by this train.
---
---The keys are the player indices, the values are how often this train killed that player.`[R]`
---@field killed_players table<uint, uint>
---@field locomotives table<string, LuaEntity[]> @Arrays of locomotives. The result is two arrays, indexed by `"front_movers"` and `"back_movers"` containing the locomotives. E.g. `{front_movers={loco1, loco2}, back_movers={loco3}}`.`[R]`
---@field manual_mode boolean @When `true`, the train is explicitly controlled by the player or script. When `false`, the train moves autonomously according to its schedule.`[RW]`
---@field max_backward_speed double @Current max speed when moving backwards, depends on locomotive prototype and fuel.`[R]`
---@field max_forward_speed double @Current max speed when moving forward, depends on locomotive prototype and fuel.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---The player passengers on the train`[R]`
---
---This does *not* index using player index. See [LuaPlayer::index](LuaPlayer::index) on each player instance for the player index.
---@field passengers LuaPlayer[]
---@field path LuaRailPath @The path this train is using or `nil` if none.`[R]`
---@field path_end_rail LuaEntity @The destination rail this train is currently pathing to or `nil`.`[R]`
---@field path_end_stop LuaEntity @The destination train stop this train is currently pathing to or `nil`.`[R]`
---@field rail_direction_from_back_rail defines.rail_direction @`[R]`
---@field rail_direction_from_front_rail defines.rail_direction @`[R]`
---@field riding_state RidingState @The riding state of this train.`[R]`
---The trains current schedule or `nil` if empty. Set to `nil` to clear.`[RW]`
---
---The schedule can't be changed by modifying the returned table. Instead, changes must be made by assigning a new table to this attribute.
---@field schedule TrainSchedule
---@field signal LuaEntity @The signal this train is arriving or waiting at or `nil` if none.`[R]`
---Current speed.`[RW]`
---
---Changing the speed of the train is potentially an unsafe operation because train uses the speed for its internal calculations of break distances, etc.
---@field speed double
---@field state defines.train_state @This train's current state.`[R]`
---@field station LuaEntity @The train stop this train is stopped at or `nil`.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field weight double @The weight of this train.`[R]`
local LuaTrain = {}

---Clears all fluids in this train.
function LuaTrain.clear_fluids_inside() end

---Clear all items in this train.
function LuaTrain.clear_items_inside() end

---Get a mapping of the train's inventory.
---@return table<string, uint> @The counts, indexed by item names.
function LuaTrain.get_contents() end

---Gets a mapping of the train's fluid inventory.
---@return table<string, double> @The counts, indexed by fluid names.
function LuaTrain.get_fluid_contents() end

---Get the amount of a particular fluid stored in the train.
---@param _fluid? string @Fluid name to count. If not given, counts all fluids.
---@return double
function LuaTrain.get_fluid_count(_fluid) end

---Get the amount of a particular item stored in the train.
---@param _item? string @Item name to count. If not given, counts all items.
---@return uint
function LuaTrain.get_item_count(_item) end

---Gets all rails under the train.
---@return LuaEntity[]
function LuaTrain.get_rails() end

---Go to the station specified by the index in the train's schedule.
---@param _index uint
function LuaTrain.go_to_station(_index) end

---All methods and properties that this object supports.
---@return string
function LuaTrain.help() end

---Insert a stack into the train.
---@param _stack ItemStackIdentification
function LuaTrain.insert(_stack) end

---Inserts the given fluid into the first available location in this train.
---@param _fluid Fluid
---@return double @The amount inserted.
function LuaTrain.insert_fluid(_fluid) end

---Checks if the path is invalid and tries to re-path if it isn't.
---@param _force? boolean @Forces the train to re-path regardless of the current path being valid or not.
---@return boolean @If the train has a path after the repath attempt.
function LuaTrain.recalculate_path(_force) end

---Remove some fluid from the train.
---@param _fluid Fluid
---@return double @The amount of fluid actually removed.
function LuaTrain.remove_fluid(_fluid) end

---Remove some items from the train.
---@param _stack ItemStackIdentification @The amount and type of items to remove
---@return uint @Number of items actually removed.
function LuaTrain.remove_item(_stack) end

