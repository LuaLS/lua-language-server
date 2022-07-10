---@meta

---A single logistic network of a given force on a given surface.
---@class LuaLogisticNetwork
---@field active_provider_points LuaLogisticPoint[] @All active provider points in this network.`[R]`
---@field all_construction_robots uint @The total number of construction robots in the network (idle and active + in roboports).`[R]`
---@field all_logistic_robots uint @The total number of logistic robots in the network (idle and active + in roboports).`[R]`
---@field available_construction_robots uint @Number of construction robots available for a job.`[R]`
---@field available_logistic_robots uint @Number of logistic robots available for a job.`[R]`
---@field cells LuaLogisticCell[] @All cells in this network.`[R]`
---@field construction_robots LuaEntity[] @All construction robots in this logistic network.`[R]`
---@field empty_provider_points LuaLogisticPoint[] @All things that have empty provider points in this network.`[R]`
---@field empty_providers LuaEntity[] @All entities that have empty logistic provider points in this network.`[R]`
---@field force LuaForce @The force this logistic network belongs to.`[R]`
---@field logistic_members LuaEntity[] @All other entities that have logistic points in this network (inserters mostly).`[R]`
---@field logistic_robots LuaEntity[] @All logistic robots in this logistic network.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field passive_provider_points LuaLogisticPoint[] @All passive provider points in this network.`[R]`
---@field provider_points LuaLogisticPoint[] @All things that have provider points in this network.`[R]`
---@field providers LuaEntity[] @All entities that have logistic provider points in this network.`[R]`
---@field requester_points LuaLogisticPoint[] @All things that have requester points in this network.`[R]`
---@field requesters LuaEntity[] @All entities that have logistic requester points in this network.`[R]`
---@field robot_limit uint @Maximum number of robots the network can work with. Currently only used for the personal roboport.`[R]`
---@field robots LuaEntity[] @All robots in this logistic network.`[R]`
---@field storage_points LuaLogisticPoint[] @All things that have storage points in this network.`[R]`
---@field storages LuaEntity[] @All entities that have logistic storage points in this network.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLogisticNetwork = {}

---Find logistic cell closest to a given position.
---@param _position MapPosition
---@return LuaLogisticCell @`nil` if no cell was found.
function LuaLogisticNetwork.find_cell_closest_to(_position) end

---Get item counts for the entire network, similar to how [LuaInventory::get_contents](LuaInventory::get_contents) does.
---@return table<string, uint> @A mapping of item prototype names to the number available in the network.
function LuaLogisticNetwork.get_contents() end

---Count given or all items in the network or given members.
---@param _item? string @Item name to count. If not given, gives counts of all items in the network.
---@param _member? string @Logistic members to check, must be either `"storage"` or `"providers"`. If not given, gives count in the entire network.
---@return int
function LuaLogisticNetwork.get_item_count(_item, _member) end

---All methods and properties that this object supports.
---@return string
function LuaLogisticNetwork.help() end

---Insert items into the logistic network. This will actually insert the items into some logistic chests.
---@param _item ItemStackIdentification @What to insert.
---@param _members? string @Which logistic members to insert the items to. Must be `"storage"`, `"storage-empty"` (storage chests that are completely empty), `"storage-empty-slot"` (storage chests that have an empty slot), or `"requester"`. If not specified, inserts items into the logistic network in the usual order.
---@return uint @Number of items actually inserted.
function LuaLogisticNetwork.insert(_item, _members) end

---Remove items from the logistic network. This will actually remove the items from some logistic chests.
---@param _item ItemStackIdentification @What to remove.
---@param _members? string @Which logistic members to remove from. Must be `"storage"`, `"passive-provider"`, `"buffer"`, or `"active-provider"`. If not specified, removes from the network in the usual order.
---@return uint @Number of items removed.
function LuaLogisticNetwork.remove_item(_item, _members) end

---Find a logistic point to drop the specific item stack.
---@param _table LuaLogisticNetwork.select_drop_point
---@return LuaLogisticPoint @`nil` if no point was found.
function LuaLogisticNetwork.select_drop_point(_table) end

---Find the 'best' logistic point with this item ID and from the given position or from given chest type.
---@param _table LuaLogisticNetwork.select_pickup_point
---@return LuaLogisticPoint @`nil` if no point was found.
function LuaLogisticNetwork.select_pickup_point(_table) end


---@class LuaLogisticNetwork.select_drop_point
---@field stack ItemStackIdentification @Name of the item to select.
---@field members? string @When given, it will find from only the specific type of member. Must be `"storage"`, `"storage-empty"`, `"storage-empty-slot"` or `"requester"`. If not specified, selects with normal priorities.

---@class LuaLogisticNetwork.select_pickup_point
---@field name string @Name of the item to select.
---@field position? MapPosition @When given, it will find the storage 'best' storage point from this position.
---@field include_buffers? boolean @Whether to consider buffer chests or not. Defaults to false. Only considered if selecting with position.
---@field members? string @When given, it will find from only the specific type of member. Must be `"storage"`, `"passive-provider"`, `"buffer"` or `"active-provider"`. If not specified, selects with normal priorities. Not considered if position is specified.

