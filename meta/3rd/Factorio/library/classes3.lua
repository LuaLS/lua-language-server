---@meta

---A reference to an item and count owned by some external entity.
---
---In most instances this is a simple reference as in: it points at a specific slot in an inventory and not the item in the slot.
---\
---In the instance this references an item on a [LuaTransportLine](LuaTransportLine) the reference is only guaranteed to stay valid (and refer to the same item) as long as nothing changes the transport line.
---@class LuaItemStack
---@field active_index uint @The active blueprint index for this blueprint book. May be `nil`.`[RW]`
---@field allow_manual_label_change boolean @If the label for this item can be manually changed. When false the label can only be changed through the API.`[RW]`
---@field ammo uint @Number of bullets left in the magazine.`[RW]`
---@field blueprint_absolute_snapping boolean @If absolute snapping is enabled on this blueprint item.`[RW]`
---@field blueprint_icons BlueprintSignalIcon[] @Icons of a blueprint item, blueprint book, deconstruction item or upgrade planner. An item that doesn't have icons returns nil on read and throws error on write.`[RW]`
---@field blueprint_position_relative_to_grid TilePosition @The offset from the absolute grid or nil if absolute snapping is not enabled.`[RW]`
---@field blueprint_snap_to_grid TilePosition @The snapping grid size in this blueprint item or nil if snapping is not enabled.`[RW]`
---@field connected_entity LuaEntity @If this item is a spidertron remote that has a spidertron bound to it, it returns the connected spider-vehicle entity, `nil` otherwise.`[RW]`
---@field cost_to_build table<string, uint> @Raw materials required to build this blueprint. Result is a dictionary mapping each item prototype name to the required count.`[R]`
---@field count uint @Number of items in this stack.`[RW]`
---@field custom_description LocalisedString @The custom description this item-with-tags. This is shown over the normal item description if this is set to a non-empty value.`[RW]`
---@field default_icons BlueprintItemIcon[] @The default icons for a blueprint item.`[R]`
---Durability of the contained item. Automatically capped at the item's maximum durability.`[RW]`
---
---When used on a non-tool item, the value of this attribute is `nil`.
---@field durability double
---@field entity_filter_count uint @The number of entity filters this deconstruction item supports.`[R]`
---@field entity_filter_mode defines.deconstruction_item.entity_filter_mode @The blacklist/whitelist entity filter mode for this deconstruction item.`[RW]`
---@field entity_filters string[] @The entity filters for this deconstruction item. The attribute is a sparse array with the keys representing the index of the filter. All strings in this array must be entity prototype names that don't have the `"not-deconstructable"` flag set and are either a `cliff` or marked as `minable`.`[RW]`
---@field extends_inventory boolean @If this item extends the inventory it resides in (provides its contents for counts, crafting, insertion). Only callable on items with inventories.`[RW]`
---@field grid LuaEquipmentGrid @The equipment grid of this item or `nil` if this item doesn't have a grid.`[R]`
---@field health float @How much health the item has, as a number in range [0, 1].`[RW]`
---@field is_armor boolean @If this is an armor item.`[R]`
---@field is_blueprint boolean @If this is a blueprint item.`[R]`
---@field is_blueprint_book boolean @If this is a blueprint book item.`[R]`
---@field is_deconstruction_item boolean @If this is a deconstruction tool item.`[R]`
---@field is_item_with_entity_data boolean @If this is an item with entity data item.`[R]`
---@field is_item_with_inventory boolean @If this is an item with inventory item.`[R]`
---@field is_item_with_label boolean @If this is an item with label item.`[R]`
---@field is_item_with_tags boolean @If this is an item with tags item.`[R]`
---@field is_mining_tool boolean @If this is a mining tool item.`[R]`
---@field is_module boolean @If this is a module item.`[R]`
---@field is_repair_tool boolean @If this is a repair tool item.`[R]`
---@field is_selection_tool boolean @If this is a selection tool item.`[R]`
---@field is_tool boolean @If this is a tool item.`[R]`
---@field is_upgrade_item boolean @If this is a upgrade item.`[R]`
---The unique identifier for this item if it has one, `nil` otherwise. Note that this ID stays the same no matter where the item is moved to.
---
---Only these types of items have unique IDs:
---- `"armor"`
---- `"spidertron-remote"`
---- `"selection-tool"`
---- `"copy-paste-tool"`
---- `"upgrade-item"`
---- `"deconstruction-item"`
---- `"blueprint"`
---- `"blueprint-book"`
---- `"item-with-entity-data"`
---- `"item-with-inventory"`
---- `"item-with-tags"``[R]`
---@field item_number uint
---@field label string @The current label for this item. Nil when none.`[RW]`
---@field label_color Color @The current label color for this item. Nil when none.`[RW]`
---@field name string @Prototype name of the item held in this stack.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field prioritize_insertion_mode string @The insertion mode priority this ItemWithInventory uses when items are inserted into an inventory it resides in. Only callable on items with inventories.`[RW]`
---@field prototype LuaItemPrototype @Prototype of the item held in this stack.`[R]`
---@field tags Tags @`[RW]`
---@field tile_filter_count uint @The number of tile filters this deconstruction item supports.`[R]`
---@field tile_filter_mode defines.deconstruction_item.tile_filter_mode @The blacklist/whitelist tile filter mode for this deconstruction item.`[RW]`
---@field tile_filters string[] @The tile filters for this deconstruction item. The attribute is a sparse array with the keys representing the index of the filter. All strings in this array must be tile prototype names.`[RW]`
---@field tile_selection_mode defines.deconstruction_item.tile_selection_mode @The tile selection mode for this deconstruction item.`[RW]`
---@field trees_and_rocks_only boolean @If this deconstruction item is set to allow trees and rocks only.`[RW]`
---@field type string @Type of the item prototype.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field valid_for_read boolean @Is this valid for reading? Differs from the usual `valid` in that `valid` will be `true` even if the item stack is blank but the entity that holds it is still valid.`[R]`
local LuaItemStack = {}

---Add ammo to this ammo item.
---@param _amount float @Amount of ammo to add.
function LuaItemStack.add_ammo(_amount) end

---Add durability to this tool item.
---@param _amount double @Amount of durability to add.
function LuaItemStack.add_durability(_amount) end

---
---Built entities can be come invalid between the building of the blueprint and the function returning if by_player or raise_built is used and one of those events invalidates the entity.
---@param _table LuaItemStack.build_blueprint
---@return LuaEntity[] @Array of created ghosts
function LuaItemStack.build_blueprint(_table) end

---Would a call to [LuaItemStack::set_stack](LuaItemStack::set_stack) succeed?
---@param _stack? ItemStackIdentification @Stack that would be set, possibly `nil`.
---@return boolean
function LuaItemStack.can_set_stack(_stack) end

---Cancel deconstruct the given area with this deconstruction item.
---@param _table LuaItemStack.cancel_deconstruct_area
function LuaItemStack.cancel_deconstruct_area(_table) end

---Clear this item stack.
function LuaItemStack.clear() end

---Clears this blueprint item.
function LuaItemStack.clear_blueprint() end

---Clears all settings/filters on this deconstruction item resetting it to default values.
function LuaItemStack.clear_deconstruction_item() end

---Clears all settings/filters on this upgrade item resetting it to default values.
function LuaItemStack.clear_upgrade_item() end

---Sets up this blueprint using the found blueprintable entities/tiles on the surface.
---@param _table LuaItemStack.create_blueprint
---@return table<uint, LuaEntity> @The blueprint entity index to source entity mapping.
function LuaItemStack.create_blueprint(_table) end

---Creates the equipment grid for this item if it doesn't exist and this is an item-with-entity-data that supports equipment grids.
---@return LuaEquipmentGrid
function LuaItemStack.create_grid() end

---Deconstruct the given area with this deconstruction item.
---@param _table LuaItemStack.deconstruct_area
function LuaItemStack.deconstruct_area(_table) end

---Remove ammo from this ammo item.
---@param _amount float @Amount of ammo to remove.
function LuaItemStack.drain_ammo(_amount) end

---Remove durability from this tool item.
---@param _amount double @Amount of durability to remove.
function LuaItemStack.drain_durability(_amount) end

---Export a supported item (blueprint, blueprint-book, deconstruction-planner, upgrade-planner, item-with-tags) to a string.
---@return string @The exported string
function LuaItemStack.export_stack() end

---The entities in this blueprint.
---@return BlueprintEntity[]
function LuaItemStack.get_blueprint_entities() end

---Gets the number of entities in this blueprint item.
---@return uint
function LuaItemStack.get_blueprint_entity_count() end

---Gets the given tag on the given blueprint entity index in this blueprint item.
---@param _index uint @The entity index.
---@param _tag string @The tag to get.
---@return AnyBasic
function LuaItemStack.get_blueprint_entity_tag(_index, _tag) end

---Gets the tags for the given blueprint entity index in this blueprint item.
---@param _index uint
---@return Tags
function LuaItemStack.get_blueprint_entity_tags(_index) end

---A list of the tiles in this blueprint.
---@return Tile[]
function LuaItemStack.get_blueprint_tiles() end

---Gets the entity filter at the given index for this deconstruction item.
---@param _index uint
---@return string
function LuaItemStack.get_entity_filter(_index) end

---Access the inner inventory of an item.
---@param _inventory defines.inventory @Index of the inventory to access, which can only be [defines.inventory.item_main](defines.inventory.item_main).
---@return LuaInventory @`nil` if there is no inventory with the given index.
function LuaItemStack.get_inventory(_inventory) end

---Gets the filter at the given index for this upgrade item.
---@param _index uint @The index of the mapper to read.
---@param _type string @`"from"` or `"to"`.
---@return UpgradeFilter
function LuaItemStack.get_mapper(_index, _type) end

---Gets the tag with the given name or returns `nil` if it doesn't exist.
---@param _tag_name string
---@return AnyBasic
function LuaItemStack.get_tag(_tag_name) end

---Gets the tile filter at the given index for this deconstruction item.
---@param _index uint
---@return string
function LuaItemStack.get_tile_filter(_index) end

---All methods and properties that this object supports.
---@return string
function LuaItemStack.help() end

---Import a supported item (blueprint, blueprint-book, deconstruction-planner, upgrade-planner, item-with-tags) from a string.
---@param _data string @The string to import
---@return int @0 if the import succeeded with no errors. -1 if the import succeeded with errors. 1 if the import failed.
function LuaItemStack.import_stack(_data) end

---Is this blueprint item setup? I.e. is it a non-empty blueprint?
---@return boolean
function LuaItemStack.is_blueprint_setup() end

---Removes a tag with the given name.
---@param _tag string
---@return boolean @If the tag existed and was removed.
function LuaItemStack.remove_tag(_tag) end

---Set new entities to be a part of this blueprint.
---@param _entities BlueprintEntity[] @The new blueprint entities.
function LuaItemStack.set_blueprint_entities(_entities) end

---Sets the given tag on the given blueprint entity index in this blueprint item.
---@param _index uint @The entity index.
---@param _tag string @The tag to set.
---@param _value AnyBasic @The tag value to set or `nil` to clear the tag.
function LuaItemStack.set_blueprint_entity_tag(_index, _tag, _value) end

---Sets the tags on the given blueprint entity index in this blueprint item.
---@param _index uint @The entity index
---@param _tags Tags
function LuaItemStack.set_blueprint_entity_tags(_index, _tags) end

---Set specific tiles in this blueprint.
---@param _tiles Tile[] @Tiles to be a part of the blueprint.
function LuaItemStack.set_blueprint_tiles(_tiles) end

---Sets the entity filter at the given index for this deconstruction item.
---@param _index uint
---@param _filter string|LuaEntityPrototype|LuaEntity @Setting to nil erases the filter.
---@return boolean @Whether the new filter was successfully set (ie. was valid).
function LuaItemStack.set_entity_filter(_index, _filter) end

---Sets the module filter at the given index for this upgrade item.
---@param _index uint @The index of the mapper to set.
---@param _type string @`from` or `to`.
---@param _filter UpgradeFilter @The filter to set or `nil`
function LuaItemStack.set_mapper(_index, _type, _filter) end

---Set this item stack to another item stack.
---@param _stack? ItemStackIdentification @Item stack to set it to. Omitting this parameter or passing `nil` will clear this item stack, as if [LuaItemStack::clear](LuaItemStack::clear) was called.
---@return boolean @Whether the stack was set successfully. Returns `false` if this stack was not [valid for write](LuaItemStack::can_set_stack).
function LuaItemStack.set_stack(_stack) end

---Sets the tag with the given name and value.
---@param _tag_name string
---@param _tag AnyBasic
function LuaItemStack.set_tag(_tag_name, _tag) end

---Sets the tile filter at the given index for this deconstruction item.
---@param _index uint
---@param _filter string|LuaTilePrototype|LuaTile @Setting to nil erases the filter.
---@return boolean @Whether the new filter was successfully set (ie. was valid).
function LuaItemStack.set_tile_filter(_index, _filter) end

---Swaps this item stack with the given item stack if allowed.
---@param _stack LuaItemStack
---@return boolean @Whether the 2 stacks were swapped successfully.
function LuaItemStack.swap_stack(_stack) end

---Transfers the given item stack into this item stack.
---@param _stack ItemStackIdentification
---@return boolean @`true` if the full stack was transferred.
function LuaItemStack.transfer_stack(_stack) end


---@class LuaItemStack.build_blueprint
---@field surface SurfaceIdentification @Surface to build on
---@field force ForceIdentification @Force to use for the building
---@field position MapPosition @The position to build at
---@field force_build? boolean @When true, anything that can be built is else nothing is built if any one thing can't be built
---@field direction? defines.direction @The direction to use when building
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field by_player? PlayerIdentification @The player to use if any. If provided [defines.events.on_built_entity](defines.events.on_built_entity) will also be fired on successful entity creation.
---@field raise_built? boolean @If true; [defines.events.script_raised_built](defines.events.script_raised_built) will be fired on successful entity creation. Note: this is ignored if by_player is provided.

---@class LuaItemStack.cancel_deconstruct_area
---@field surface SurfaceIdentification @Surface to cancel deconstruct on
---@field force ForceIdentification @Force to use for canceling deconstruction
---@field area BoundingBox @The area to deconstruct
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field by_player? PlayerIdentification @The player to use if any.

---@class LuaItemStack.create_blueprint
---@field surface SurfaceIdentification @Surface to create from
---@field force ForceIdentification @Force to use for the creation
---@field area BoundingBox @The bounding box
---@field always_include_tiles? boolean @When true, blueprintable tiles are always included in the blueprint. When false they're only included if no entities exist in the setup area.
---@field include_entities? boolean @When true, entities are included in the blueprint. Defaults to true.
---@field include_modules? boolean @When true, modules are included in the blueprint. Defaults to true.
---@field include_station_names? boolean @When true, station names are included in the blueprint. Defaults to false.
---@field include_trains? boolean @When true, trains are included in the blueprint. Defaults to false.
---@field include_fuel? boolean @When true, train fuel is included in the blueprint, Defaults to true.

---@class LuaItemStack.deconstruct_area
---@field surface SurfaceIdentification @Surface to deconstruct on
---@field force ForceIdentification @Force to use for the deconstruction
---@field area BoundingBox @The area to deconstruct
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.
---@field by_player? PlayerIdentification @The player to use if any.

---Control behavior for lamps.
---@class LuaLampControlBehavior:LuaGenericOnOffControlBehavior
---@field color Color @The color the lamp is showing or `nil` if not using any color.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field use_colors boolean @`true` if the lamp should set the color from the circuit network signals.`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLampControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaLampControlBehavior.help() end

---A lazily loaded value. For performance reasons, we sometimes return a custom lazily-loaded value type instead of the native Lua value. This custom type lazily constructs the necessary value when [LuaLazyLoadedValue::get](LuaLazyLoadedValue::get) is called, therefore preventing its unnecessary construction in some cases.
---
---An instance of LuaLazyLoadedValue is only valid during the event it was created from and cannot be saved.
---@class LuaLazyLoadedValue<K>: {object_name:string; valid:boolean; get:fun():K; help:fun():string}
---Logistic cell of a particular [LuaEntity](LuaEntity). A "Logistic Cell" is the given name for settings and properties used by what would normally be seen as a "Roboport". A logistic cell however doesn't have to be attached to the roboport entity (the character has one for the personal roboport).
---@class LuaLogisticCell
---@field charge_approach_distance float @Radius at which the robots hover when waiting to be charged.`[R]`
---@field charging_robot_count uint @Number of robots currently charging.`[R]`
---@field charging_robots LuaEntity[] @Robots currently being charged.`[R]`
---@field construction_radius float @Construction radius of this cell.`[R]`
---@field logistic_network LuaLogisticNetwork @The network that owns this cell or `nil`.`[R]`
---@field logistic_radius float @Logistic radius of this cell.`[R]`
---@field logistics_connection_distance float @Logistic connection distance of this cell.`[R]`
---@field mobile boolean @`true` if this is a mobile cell. In vanilla, only the logistic cell created by a character's personal roboport is mobile.`[R]`
---@field neighbours LuaLogisticCell[] @Neighbouring cells.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity @This cell's owner.`[R]`
---@field stationed_construction_robot_count uint @Number of stationed construction robots in this cell.`[R]`
---@field stationed_logistic_robot_count uint @Number of stationed logistic robots in this cell.`[R]`
---@field to_charge_robot_count uint @Number of robots waiting to charge.`[R]`
---@field to_charge_robots LuaEntity[] @Robots waiting to charge.`[R]`
---@field transmitting boolean @`true` if this cell is active.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLogisticCell = {}

---All methods and properties that this object supports.
---@return string
function LuaLogisticCell.help() end

---Is a given position within the construction range of this cell?
---@param _position MapPosition
---@return boolean
function LuaLogisticCell.is_in_construction_range(_position) end

---Is a given position within the logistic range of this cell?
---@param _position MapPosition
---@return boolean
function LuaLogisticCell.is_in_logistic_range(_position) end

---Are two cells neighbours?
---@param _other LuaLogisticCell
---@return boolean
function LuaLogisticCell.is_neighbour_with(_other) end

---Control behavior for logistic chests.
---@class LuaLogisticContainerControlBehavior:LuaControlBehavior
---@field circuit_mode_of_operation defines.control_behavior.logistic_container.circuit_mode_of_operation @The circuit mode of operations for the logistic container.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLogisticContainerControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaLogisticContainerControlBehavior.help() end

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

---Logistic point of a particular [LuaEntity](LuaEntity). A "Logistic point" is the name given for settings and properties used by requester, provider, and storage points in a given logistic network. These "points" don't have to be a logistic container but often are. One other entity that can own several points is the "character" character type entity.
---@class LuaLogisticPoint
---@field exact boolean @If this logistic point is using the exact mode. In exact mode robots never over-deliver requests.`[R]`
---The logistic filters for this logistic point or `nil` if this doesn't use logistic filters.`[R]`
---
---The returned array will always have an entry for each filter and will be indexed in sequence when not nil.
---@field filters LogisticFilter[]
---The force of this logistic point.`[R]`
---
---This will always be the same as the [LuaLogisticPoint::owner](LuaLogisticPoint::owner) force.
---@field force LuaForce
---@field logistic_member_index uint @The Logistic member index of this logistic point.`[R]`
---@field logistic_network LuaLogisticNetwork @`[R]`
---@field mode defines.logistic_mode @The logistic mode.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity @The [LuaEntity](LuaEntity) owner of this [LuaLogisticPoint](LuaLogisticPoint).`[R]`
---@field targeted_items_deliver table<string, uint> @Items targeted to be dropped off into this logistic point by robots. The attribute is a dictionary mapping the item prototype names to their item counts.`[R]`
---@field targeted_items_pickup table<string, uint> @Items targeted to be picked up from this logistic point by robots. The attribute is a dictionary mapping the item prototype names to their item counts.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLogisticPoint = {}

---All methods and properties that this object supports.
---@return string
function LuaLogisticPoint.help() end

---Control behavior for mining drills.
---@class LuaMiningDrillControlBehavior:LuaGenericOnOffControlBehavior
---@field circuit_enable_disable boolean @`true` if this drill is enabled or disabled using the logistics or circuit condition.`[RW]`
---@field circuit_read_resources boolean @`true` if this drill should send the resources in the field to the circuit network. Which resources depends on [LuaMiningDrillControlBehavior::resource_read_mode](LuaMiningDrillControlBehavior::resource_read_mode)`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field resource_read_mode defines.control_behavior.mining_drill.resource_read_mode @If the mining drill should send just the resources in its area or the entire field it's on to the circuit network.`[RW]`
---@field resource_read_targets LuaEntity[] @The resource entities that the mining drill will send information about to the circuit network or an empty array.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaMiningDrillControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaMiningDrillControlBehavior.help() end

---Prototype of a mod setting.
---@class LuaModSettingPrototype
---@field allow_blank boolean @If this string setting allows blank values or `nil` if not a string setting.`[R]`
---@field allowed_values string[]|int[]|double[] @The allowed values for this setting or `nil` if this setting doesn't use the a fixed set of values.`[R]`
---@field auto_trim boolean @If this string setting auto-trims values or `nil` if not a string setting.`[R]`
---@field default_value boolean|double|int|string @The default value of this setting.`[R]`
---@field hidden boolean @If this setting is hidden from the GUI.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field maximum_value double|int @The maximum value for this setting or `nil` if this setting type doesn't support a maximum.`[R]`
---@field minimum_value double|int @The minimum value for this setting or `nil` if this setting type doesn't support a minimum.`[R]`
---@field mod string @The mod that owns this setting.`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field setting_type string @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaModSettingPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaModSettingPrototype.help() end

---Prototype of a module category.
---@class LuaModuleCategoryPrototype
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaModuleCategoryPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaModuleCategoryPrototype.help() end

---Prototype of a named noise expression.
---@class LuaNamedNoiseExpression
---@field expression NoiseExpression @The expression itself.`[R]`
---@field intended_property string @Name of the property that this expression is intended to provide a value for, if any.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaNamedNoiseExpression = {}

---All methods and properties that this object supports.
---@return string
function LuaNamedNoiseExpression.help() end

---Prototype of a noise layer.
---@class LuaNoiseLayerPrototype
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaNoiseLayerPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaNoiseLayerPrototype.help() end

---Prototype of an optimized particle.
---@class LuaParticlePrototype
---@field ended_in_water_trigger_effect TriggerEffectItem @`[R]`
---@field life_time uint @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field mining_particle_frame_speed float @`[R]`
---@field movement_modifier float @`[R]`
---@field movement_modifier_when_on_ground float @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field regular_trigger_effect TriggerEffectItem @`[R]`
---@field regular_trigger_effect_frequency uint @`[R]`
---@field render_layer RenderLayer @`[R]`
---@field render_layer_when_on_ground RenderLayer @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaParticlePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaParticlePrototype.help() end

---A permission group that defines what players in this group are allowed to do.
---@class LuaPermissionGroup
---@field group_id uint @The group ID`[R]`
---The name of this group.`[RW]`
---
---Setting the name to `nil` or an empty string sets the name to the default value.
---@field name string
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field players LuaPlayer[] @The players in this group.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaPermissionGroup = {}

---Adds the given player to this group.
---@param _player PlayerIdentification
---@return boolean @Whether the player was added.
function LuaPermissionGroup.add_player(_player) end

---Whether this group allows the given action.
---@param _action defines.input_action @The action in question.
---@return boolean
function LuaPermissionGroup.allows_action(_action) end

---Destroys this group.
---@return boolean @Whether the group was successfully destroyed.
function LuaPermissionGroup.destroy() end

---All methods and properties that this object supports.
---@return string
function LuaPermissionGroup.help() end

---Removes the given player from this group.
---@param _player PlayerIdentification
---@return boolean @Whether the player was removed.
function LuaPermissionGroup.remove_player(_player) end

---Sets whether this group allows the performance the given action.
---@param _action defines.input_action @The action in question.
---@param _allow_action boolean @Whether to allow the specified action.
---@return boolean @Whether the value was successfully applied.
function LuaPermissionGroup.set_allows_action(_action, _allow_action) end

---All permission groups.
---@class LuaPermissionGroups
---@field groups LuaPermissionGroup[] @All of the permission groups.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaPermissionGroups = {}

---Creates a new permission group.
---@param _name? string
---@return LuaPermissionGroup @`nil` if the calling player doesn't have permission to make groups.
function LuaPermissionGroups.create_group(_name) end

---Gets the permission group with the given name or group ID.
---@param _group string|uint
---@return LuaPermissionGroup @`nil` if there is no matching group.
function LuaPermissionGroups.get_group(_group) end

---All methods and properties that this object supports.
---@return string
function LuaPermissionGroups.help() end

---A player in the game. Pay attention that a player may or may not have a character, which is the [LuaEntity](LuaEntity) of the little guy running around the world doing things.
---@class LuaPlayer:LuaControl
---`true` if the player is an admin.`[RW]`
---
---Trying to change player admin status from the console when you aren't an admin does nothing.
---@field admin boolean
---@field afk_time uint @How many ticks since the last action of this player`[R]`
---@field auto_sort_main_inventory boolean @If the main inventory will be auto sorted.`[R]`
---@field blueprint_to_setup LuaItemStack @The item stack containing a blueprint to be setup.`[R]`
---The character attached to this player, or `nil` if no character.`[RW]`
---
---Will also return `nil` when the player is disconnected (see [LuaPlayer::connected](LuaPlayer::connected)).
---@field character LuaEntity
---@field chat_color Color @The color used when this player talks in game.`[RW]`
---@field color Color @The color associated with the player. This will be used to tint the player's character as well as their buildings and vehicles.`[RW]`
---@field connected boolean @`true` if the player is currently connected to the game.`[R]`
---@field controller_type defines.controllers @`[R]`
---When in a cutscene; the character this player would be using once the cutscene is over.`[R]`
---
---Will also return `nil` when the player is disconnected (see [LuaPlayer::connected](LuaPlayer::connected)).
---@field cutscene_character LuaEntity
---The display resolution for this player.`[R]`
---
---During [on_player_created](on_player_created), this attribute will always return a resolution of `{width=1920, height=1080}`. To get the actual resolution, listen to the [on_player_display_resolution_changed](on_player_display_resolution_changed) event raised shortly afterwards.
---@field display_resolution DisplayResolution
---The display scale for this player.`[R]`
---
---During [on_player_created](on_player_created), this attribute will always return a scale of `1`. To get the actual scale, listen to the [on_player_display_scale_changed](on_player_display_scale_changed) event raised shortly afterwards.
---@field display_scale double
---The source entity used during entity settings copy-paste if any.
---
---`nil` if there isn't currently a source entity.`[R]`
---@field entity_copy_source LuaEntity
---@field game_view_settings GameViewSettings @The player's game view settings.`[RW]`
---@field gui LuaGui @`[R]`
---@field hand_location ItemStackLocation @The original location of the item in the cursor, marked with a hand. When writing, the specified inventory slot must be empty and the cursor stack must not be empty.`[RW]`
---@field index uint @This player's unique index in [LuaGameScript::players](LuaGameScript::players). It is given to them when they are [created](on_player_created) and remains assigned to them until they are [removed](on_player_removed).`[R]`
---@field infinity_inventory_filters InfinityInventoryFilter[] @The filters for this map editor infinity inventory settings.`[RW]`
---@field last_online uint @At what tick this player was last online.`[R]`
---@field map_view_settings MapViewSettings @The player's map view settings. To write to this, use a table containing the fields that should be changed.`[W]`
---@field minimap_enabled boolean @`true` if the minimap is visible.`[RW]`
---Gets the current per-player settings for the this player, indexed by prototype name. Returns the same structure as [LuaSettings::get_player_settings](LuaSettings::get_player_settings).`[R]`
---
---This table will become invalid if its associated player does.
---@field mod_settings table<string, ModSetting>
---@field name string @The player's username.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field online_time uint @How many ticks did this player spend playing this save (all sessions combined)`[R]`
---@field opened_self boolean @`true` if the player opened itself. I.e. if they opened the character or god-controller GUI.`[R]`
---@field permission_group LuaPermissionGroup @The permission group this player is part of or `nil` if not part of any group.`[RW]`
---@field remove_unfiltered_items boolean @If items not included in this map editor infinity inventory filters should be removed.`[RW]`
---@field render_mode defines.render_mode @The render mode of the player, like map or zoom to world. The render mode can be set using [LuaPlayer::open_map](LuaPlayer::open_map), [LuaPlayer::zoom_to_world](LuaPlayer::zoom_to_world) and [LuaPlayer::close_map](LuaPlayer::close_map).`[R]`
---@field show_on_map boolean @If `true`, circle and name of given player is rendered on the map/chart.`[RW]`
---@field spectator boolean @If `true`, zoom-to-world noise effect will be disabled and environmental sounds will be based on zoom-to-world view instead of position of player's character.`[RW]`
---The stashed controller type or `nil` if no controller is stashed.`[R]`
---
---This is mainly useful when a player is in the map editor.
---@field stashed_controller_type defines.controllers
---@field tag string @The tag that is shown after the player in chat and on the map.`[RW]`
---The number of ticks until this player will respawn or `nil` if not waiting to respawn.`[RW]`
---
---Set to `nil` to immediately respawn the player.
---\
---Set to any positive value to trigger the respawn state for this player.
---@field ticks_to_respawn uint
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field zoom double @The player's zoom-level.`[W]`
local LuaPlayer = {}

---Gets a copy of the currently selected blueprint in the clipboard queue into the player's cursor, as if the player activated Paste.
function LuaPlayer.activate_paste() end

---Adds an alert to this player for the given entity of the given alert type.
---@param _entity LuaEntity
---@param _type defines.alert_type
function LuaPlayer.add_alert(_entity, _type) end

---Adds a custom alert to this player.
---@param _entity LuaEntity @If the alert is clicked, the map will open at the position of this entity.
---@param _icon SignalID
---@param _message LocalisedString
---@param _show_on_map boolean
function LuaPlayer.add_custom_alert(_entity, _icon, _message, _show_on_map) end

---Adds the given recipe to the list of recipe notifications for this player.
---@param _recipe string @Name of the recipe prototype to add.
function LuaPlayer.add_recipe_notification(_recipe) end

---Adds the given blueprint to this player's clipboard queue.
---@param _blueprint LuaItemStack @The blueprint to add.
function LuaPlayer.add_to_clipboard(_blueprint) end

---Associates a character with this player.
---
---The character must not be connected to any controller.
---\
---If this player is currently disconnected (see [LuaPlayer::connected](LuaPlayer::connected)) the character will be immediately "logged off".
---\
---See [LuaPlayer::get_associated_characters](LuaPlayer::get_associated_characters) for more information.
---@param _character LuaEntity @The character entity.
function LuaPlayer.associate_character(_character) end

---Builds what ever is in the cursor on the surface the player is on.
---
---Anything built will fire normal player-built events.
---\
---The cursor stack will automatically be reduced as if the player built normally.
---@param _table LuaPlayer.build_from_cursor
function LuaPlayer.build_from_cursor(_table) end

---Checks if this player can build what ever is in the cursor on the surface the player is on.
---@param _table LuaPlayer.can_build_from_cursor
---@return boolean
function LuaPlayer.can_build_from_cursor(_table) end

---Checks if this player can build the give entity at the given location on the surface the player is on.
---@param _table LuaPlayer.can_place_entity
---@return boolean
function LuaPlayer.can_place_entity(_table) end

---Clear the chat console.
function LuaPlayer.clear_console() end

---Invokes the "clear cursor" action on the player as if the user pressed it.
---@return boolean @Whether the cursor is now empty.
function LuaPlayer.clear_cursor() end

---Clears all recipe notifications for this player.
function LuaPlayer.clear_recipe_notifications() end

---Clears the players selection tool selection position.
function LuaPlayer.clear_selection() end

---Queues request to switch to the normal game view from the map or zoom to world view. Render mode change requests are processed before rendering of the next frame.
function LuaPlayer.close_map() end

---Asks the player if they would like to connect to the given server.
---
---This only does anything when used on a multiplayer peer. Single player and server hosts will ignore the prompt.
---@param _table LuaPlayer.connect_to_server
function LuaPlayer.connect_to_server(_table) end

---Creates and attaches a character entity to this player.
---
---The player must not have a character already connected and must be online (see [LuaPlayer::connected](LuaPlayer::connected)).
---@param _character? string @The character to create else the default is used.
---@return boolean @Whether the character was created.
function LuaPlayer.create_character(_character) end

---Spawn flying text that is only visible to this player. Either `position` or `create_at_cursor` are required. When `create_at_cursor` is `true`, all parameters other than `text` are ignored.
---
---If no custom `speed` is set and the text is longer than 25 characters, its `time_to_live` and `speed` are dynamically adjusted to give players more time to read it.
---\
---Local flying text is not saved, which means it will disappear after a save/load-cycle.
---@param _table LuaPlayer.create_local_flying_text
function LuaPlayer.create_local_flying_text(_table) end

---Disables alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was disabled (false if it was already disabled).
function LuaPlayer.disable_alert(_alert_type) end

---Disable recipe groups.
function LuaPlayer.disable_recipe_groups() end

---Disable recipe subgroups.
function LuaPlayer.disable_recipe_subgroups() end

---Disassociates a character from this player. This is functionally the same as setting [LuaEntity::associated_player](LuaEntity::associated_player) to `nil`.
---
---See [LuaPlayer::get_associated_characters](LuaPlayer::get_associated_characters) for more information.
---@param _character LuaEntity @The character entity
function LuaPlayer.disassociate_character(_character) end

---Start/end wire dragging at the specified location, wire type is based on the cursor contents
---@param _table LuaPlayer.drag_wire
---@return boolean @`true` if the action did something
function LuaPlayer.drag_wire(_table) end

---Enables alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was enabled (false if it was already enabled).
function LuaPlayer.enable_alert(_alert_type) end

---Enable recipe groups.
function LuaPlayer.enable_recipe_groups() end

---Enable recipe subgroups.
function LuaPlayer.enable_recipe_subgroups() end

---Exit the current cutscene. Errors if not in a cutscene.
function LuaPlayer.exit_cutscene() end

---Gets which quick bar page is being used for the given screen page or `nil` if not known.
---@param _index uint @The screen page. Index 1 is the top row in the gui. Index can go beyond the visible number of bars on the screen to account for the interface config setting change.
---@return uint8
function LuaPlayer.get_active_quick_bar_page(_index) end

---Get all alerts matching the given filters, or all alerts if no filters are given.
---@param _table LuaPlayer.get_alerts
---@return table<uint, table<defines.alert_type, Alert[]>> @A mapping of surface index to an array of arrays of [alerts](Alert) indexed by the [alert type](defines.alert_type).
function LuaPlayer.get_alerts(_table) end

---The characters associated with this player.
---
---The array will always be empty when the player is disconnected (see [LuaPlayer::connected](LuaPlayer::connected)) regardless of there being associated characters.
---\
---Characters associated with this player will be logged off when this player disconnects but are not controlled by any player.
---@return LuaEntity[]
function LuaPlayer.get_associated_characters() end

---Get the current goal description, as a localised string.
---@return LocalisedString
function LuaPlayer.get_goal_description() end

---Gets the filter for this map editor infinity filters at the given index or `nil` if the filter index doesn't exist or is empty.
---@param _index uint @The index to get.
---@return InfinityInventoryFilter
function LuaPlayer.get_infinity_inventory_filter(_index) end

---Gets the quick bar filter for the given slot or `nil`.
---@param _index uint @The slot index. 1 for the first slot of page one, 2 for slot two of page one, 11 for the first slot of page 2, etc.
---@return LuaItemPrototype
function LuaPlayer.get_quick_bar_slot(_index) end

---All methods and properties that this object supports.
---@return string
function LuaPlayer.help() end

---If the given alert type is currently enabled.
---@param _alert_type defines.alert_type
---@return boolean
function LuaPlayer.is_alert_enabled(_alert_type) end

---If the given alert type is currently muted.
---@param _alert_type defines.alert_type
---@return boolean
function LuaPlayer.is_alert_muted(_alert_type) end

---Is a custom Lua shortcut currently available?
---@param _prototype_name string @Prototype name of the custom shortcut.
---@return boolean
function LuaPlayer.is_shortcut_available(_prototype_name) end

---Is a custom Lua shortcut currently toggled?
---@param _prototype_name string @Prototype name of the custom shortcut.
---@return boolean
function LuaPlayer.is_shortcut_toggled(_prototype_name) end

---Jump to the specified cutscene waypoint. Only works when the player is viewing a cutscene.
---@param _waypoint_index uint
function LuaPlayer.jump_to_cutscene_waypoint(_waypoint_index) end

---Logs a dictionary of chunks -> active entities for the surface this player is on.
function LuaPlayer.log_active_entity_chunk_counts() end

---Logs a dictionary of active entities -> count for the surface this player is on.
function LuaPlayer.log_active_entity_counts() end

---Mutes alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was muted (false if it was already muted).
function LuaPlayer.mute_alert(_alert_type) end

---Queues a request to open the map at the specified position. If the map is already opened, the request will simply set the position (and scale). Render mode change requests are processed before rendering of the next frame.
---@param _position MapPosition
---@param _scale? double
function LuaPlayer.open_map(_position, _scale) end

---Invokes the "smart pipette" action on the player as if the user pressed it.
---@param _entity string|LuaEntity|LuaEntityPrototype
---@return boolean @Whether the smart pipette found something to place.
function LuaPlayer.pipette_entity(_entity) end

---Play a sound for this player.
---@param _table LuaPlayer.play_sound
function LuaPlayer.play_sound(_table) end

---Print text to the chat console.
---
---Messages that are identical to a message sent in the last 60 ticks are not printed again.
---@param _message LocalisedString
---@param _color? Color
function LuaPlayer.print(_message, _color) end

---Print entity statistics to the player's console.
---@param _entities? string[] @Entity prototypes to get statistics for. If not specified or empty, display statistics for all entities.
function LuaPlayer.print_entity_statistics(_entities) end

---Print LuaObject counts per mod.
function LuaPlayer.print_lua_object_statistics() end

---Print construction robot job counts to the players console.
function LuaPlayer.print_robot_jobs() end

---Removes all alerts matching the given filters or if an empty filters table is given all alerts are removed.
---@param _table LuaPlayer.remove_alert
function LuaPlayer.remove_alert(_table) end

---Requests a translation for the given localised string. If the request is successful the [on_string_translated](on_string_translated) event will be fired at a later time with the results.
---
---Does nothing if this player is not connected. (see [LuaPlayer::connected](LuaPlayer::connected)).
---@param _localised_string LocalisedString
---@return boolean @Whether the request was sent or not.
function LuaPlayer.request_translation(_localised_string) end

---Sets which quick bar page is being used for the given screen page.
---@param _screen_index uint @The screen page. Index 1 is the top row in the gui. Index can go beyond the visible number of bars on the screen to account for the interface config setting change.
---@param _page_index uint @The new quick bar page.
function LuaPlayer.set_active_quick_bar_page(_screen_index, _page_index) end

---Set the controller type of the player.
---
---Setting a player to [defines.controllers.editor](defines.controllers.editor) auto promotes the player to admin and enables cheat mode.
---\
---Setting a player to [defines.controllers.editor](defines.controllers.editor) also requires the calling player be an admin.
---@param _table LuaPlayer.set_controller
function LuaPlayer.set_controller(_table) end

---Setup the screen to be shown when the game is finished.
---@param _message LocalisedString @Message to be shown.
---@param _file? string @Path to image to be shown.
function LuaPlayer.set_ending_screen_data(_message, _file) end

---Set the text in the goal window (top left).
---@param _text? LocalisedString @The text to display. Lines can be delimited with `\n`. Passing an empty string or omitting this parameter entirely will make the goal window disappear.
---@param _only_update? boolean @When `true`, won't play the "goal updated" sound.
function LuaPlayer.set_goal_description(_text, _only_update) end

---Sets the filter for this map editor infinity filters at the given index.
---@param _index uint @The index to set.
---@param _filter InfinityInventoryFilter @The new filter or `nil` to clear the filter.
function LuaPlayer.set_infinity_inventory_filter(_index, _filter) end

---Sets the quick bar filter for the given slot.
---@param _index uint @The slot index. 1 for the first slot of page one, 2 for slot two of page one, 11 for the first slot of page 2, etc.
---@param _filter string|LuaItemPrototype|LuaItemStack @The filter or `nil`.
function LuaPlayer.set_quick_bar_slot(_index, _filter) end

---Make a custom Lua shortcut available or unavailable.
---@param _prototype_name string @Prototype name of the custom shortcut.
---@param _available boolean
function LuaPlayer.set_shortcut_available(_prototype_name, _available) end

---Toggle or untoggle a custom Lua shortcut
---@param _prototype_name string @Prototype name of the custom shortcut.
---@param _toggled boolean
function LuaPlayer.set_shortcut_toggled(_prototype_name, _toggled) end

---Starts selection with selection tool from the specified position. Does nothing if the players cursor is not a selection tool.
---@param _position MapPosition @The position to start selection from.
---@param _selection_mode string @The type of selection to start. Can be `select`, `alternative-select`, `reverse-select`.
function LuaPlayer.start_selection(_position, _selection_mode) end

---Toggles this player into or out of the map editor. Does nothing if this player isn't an admin or if the player doesn't have permission to use the map editor.
function LuaPlayer.toggle_map_editor() end

---Unlock the achievements of the given player. This has any effect only when this is the local player, the achievement isn't unlocked so far and the achievement is of the type "achievement".
---@param _name string @name of the achievement to unlock
function LuaPlayer.unlock_achievement(_name) end

---Unmutes alerts for the given alert category.
---@param _alert_type defines.alert_type
---@return boolean @Whether the alert type was unmuted (false if it was wasn't muted).
function LuaPlayer.unmute_alert(_alert_type) end

---Uses the current item in the cursor if it's a capsule or does nothing if not.
---@param _position MapPosition @Where the item would be used.
function LuaPlayer.use_from_cursor(_position) end

---Queues a request to zoom to world at the specified position. If the player is already zooming to world, the request will simply set the position (and scale). Render mode change requests are processed before rendering of the next frame.
---@param _position MapPosition
---@param _scale? double
function LuaPlayer.zoom_to_world(_position, _scale) end


---@class LuaPlayer.build_from_cursor
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed
---@field alt? boolean @If alt build should be used instead of normal build. Defaults to normal.
---@field terrain_building_size? uint @The size for building terrain if building terrain. Defaults to 2.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.

---@class LuaPlayer.can_build_from_cursor
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed
---@field alt? boolean @If alt build should be used instead of normal build. Defaults to normal.
---@field terrain_building_size? uint @The size for building terrain if building terrain. Defaults to 2.
---@field skip_fog_of_war? boolean @If chunks covered by fog-of-war are skipped.

---@class LuaPlayer.can_place_entity
---@field name string @Name of the entity to check
---@field position MapPosition @Where the entity would be placed
---@field direction? defines.direction @Direction the entity would be placed

---@class LuaPlayer.connect_to_server
---@field address string @The server (address:port) if port is not given the default Factorio port is used.
---@field name? LocalisedString @The name of the server.
---@field description? LocalisedString
---@field password? string @The password if different from the one used to join this game. Note, if the current password is not empty but the one required to join the new server is an empty string should be given for this field.

---@class LuaPlayer.create_local_flying_text
---@field text LocalisedString @The flying text to show.
---@field position? MapPosition @The location on the map at which to show the flying text.
---@field create_at_cursor? boolean @If `true`, the flying text is created at the player's cursor. Defaults to `false`.
---@field color? Color @The color of the flying text. Defaults to white text.
---@field time_to_live? uint @The amount of ticks that the flying text will be shown for. Defaults to `80`.
---@field speed? double @The speed at which the text rises upwards in tiles/second. Can't be a negative value.

---@class LuaPlayer.drag_wire
---@field position MapPosition @Position at which cursor was clicked. Used only to decide which side of arithmetic combinator, decider combinator or power switch is to be connected. Entity itself to be connected is based on the player's selected entity.

---@class LuaPlayer.get_alerts
---@field entity? LuaEntity
---@field prototype? LuaEntityPrototype
---@field position? MapPosition
---@field type? defines.alert_type
---@field surface? SurfaceIdentification

---@class LuaPlayer.play_sound
---@field path SoundPath @The sound to play.
---@field position? MapPosition @Where the sound should be played. If not given, it's played at the current position of the player.
---@field volume_modifier? double @The volume of the sound to play. Must be between 0 and 1 inclusive.
---@field override_sound_type? SoundType @The volume mixer to play the sound through. Defaults to the default mixer for the given sound type.

---@class LuaPlayer.remove_alert
---@field entity? LuaEntity
---@field prototype? LuaEntityPrototype
---@field position? MapPosition
---@field type? defines.alert_type
---@field surface? SurfaceIdentification
---@field icon? SignalID
---@field message? LocalisedString

---@class LuaPlayer.set_controller
---@field type defines.controllers @Which controller to use.
---@field character? LuaEntity @Entity to control. Mandatory when `type` is [defines.controllers.character](defines.controllers.character), ignored otherwise.
---@field waypoints? CutsceneWaypoint @List of waypoints for the cutscene controller. This parameter is mandatory when `type` is [defines.controllers.cutscene](defines.controllers.cutscene).
---@field start_position? MapPosition @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), the cutscene will start at this position. If not given the start position will be the player position.
---@field start_zoom? double @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), the cutscene will start at this zoom level. If not given the start zoom will be the players zoom.
---@field final_transition_time? uint @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), it is the time in ticks it will take for the camera to pan from the final waypoint back to the starting position. If not given the camera will not pan back to the start position/zoom.
---@field chart_mode_cutoff? double @If specified and `type` is [defines.controllers.cutscene](defines.controllers.cutscene), the game will switch to chart-mode (map zoomed out) rendering when the zoom level is less than this value.

---An object used to measure script performance.
---
---Since performance is non-deterministic, these objects don't allow reading the raw time values from Lua. They can be used anywhere a [LocalisedString](LocalisedString) is used, except for [LuaGuiElement::add](LuaGuiElement::add)'s LocalisedString arguments, [LuaSurface::create_entity](LuaSurface::create_entity)'s `text` argument, and [LuaEntity::add_market_item](LuaEntity::add_market_item).
---@class LuaProfiler
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaProfiler = {}

---Add the duration of another timer to this timer. Useful to reduce start/stop overhead when accumulating time onto many timers at once.
---
---If other is running, the time to now will be added.
---@param _other LuaProfiler @The timer to add to this timer.
function LuaProfiler.add(_other) end

---Divides the current duration by a set value. Useful for calculating the average of many iterations.
---
---Does nothing if this isn't stopped.
---@param _number double @The number to divide by. Must be > 0.
function LuaProfiler.divide(_number) end

---All methods and properties that this object supports.
---@return string
function LuaProfiler.help() end

---Resets the clock, also restarting it.
function LuaProfiler.reset() end

---Start the clock again, without resetting it.
function LuaProfiler.restart() end

---Stops the clock.
function LuaProfiler.stop() end

---Control behavior for programmable speakers.
---@class LuaProgrammableSpeakerControlBehavior:LuaControlBehavior
---@field circuit_condition CircuitConditionDefinition @`[RW]`
---@field circuit_parameters ProgrammableSpeakerCircuitParameters @`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaProgrammableSpeakerControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaProgrammableSpeakerControlBehavior.help() end

---An interface to send messages to the calling RCON interface.
---@class LuaRCON
---@field object_name string @This object's name.`[R]`
local LuaRCON = {}

---Print text to the calling RCON interface if any.
---@param _message LocalisedString
function LuaRCON.print(_message) end

---Control behavior for rail chain signals.
---@class LuaRailChainSignalControlBehavior:LuaControlBehavior
---@field blue_signal SignalID @`[RW]`
---@field green_signal SignalID @`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field orange_signal SignalID @`[RW]`
---@field red_signal SignalID @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRailChainSignalControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaRailChainSignalControlBehavior.help() end

---A rail path.
---@class LuaRailPath
---@field current uint @The current rail index.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field rails table<uint, LuaEntity> @Array of the rails that this path travels over.`[R]`
---@field size uint @The total number of rails in this path.`[R]`
---@field total_distance double @The total path distance.`[R]`
---@field travelled_distance double @The total distance travelled.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRailPath = {}

---All methods and properties that this object supports.
---@return string
function LuaRailPath.help() end

---Control behavior for rail signals.
---@class LuaRailSignalControlBehavior:LuaControlBehavior
---@field circuit_condition CircuitConditionDefinition @The circuit condition when controlling the signal through the circuit network.`[RW]`
---@field close_signal boolean @If this will close the rail signal based off the circuit condition.`[RW]`
---@field green_signal SignalID @`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field orange_signal SignalID @`[RW]`
---@field read_signal boolean @If this will read the rail signal state.`[RW]`
---@field red_signal SignalID @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRailSignalControlBehavior = {}

---All methods and properties that this object supports.
---@return string
function LuaRailSignalControlBehavior.help() end

---A deterministic random generator independent from the core games random generator that can be seeded and re-seeded at will. This random generator can be saved and loaded and will maintain its state. Note this is entirely different from calling [math.random](Libraries.html#math.random)() and you should be sure you actually want to use this over calling `math.random()`. If you aren't sure if you need to use this over calling `math.random()` then you probably don't need to use this.
---
---Create a generator and use it to print a random number. 
---```lua
---global.generator = game.create_random_generator()
---game.player.print(global.generator())
---```
---@class LuaRandomGenerator
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRandomGenerator = {}

---All methods and properties that this object supports.
---@return string
function LuaRandomGenerator.help() end

---Re-seeds the random generator with the given value.
---
---Seeds that are close together will produce similar results. Seeds from 0 to 341 will produce the same results.
---@param _seed uint
function LuaRandomGenerator.re_seed(_seed) end

---A crafting recipe. Recipes belong to forces (see [LuaForce](LuaForce)) because some recipes are unlocked by research, and researches are per-force.
---@class LuaRecipe
---@field category string @Category of the recipe.`[R]`
---@field enabled boolean @Can the recipe be used?`[RW]`
---@field energy double @Energy required to execute this recipe. This directly affects the crafting time: Recipe's energy is exactly its crafting time in seconds, when crafted in an assembling machine with crafting speed exactly equal to one.`[R]`
---@field force LuaForce @The force that owns this recipe.`[R]`
---@field group LuaGroup @Group of this recipe.`[R]`
---@field hidden boolean @Is the recipe hidden? Hidden recipe don't show up in the crafting menu.`[R]`
---@field hidden_from_flow_stats boolean @Is the recipe hidden from flow statistics?`[RW]`
---Ingredients for this recipe.`[R]`
---
---What the "steel-chest" recipe would return 
---```lua
---{{type="item", name="steel-plate", amount=8}}
---```
---\
---What the "advanced-oil-processing" recipe would return 
---```lua
---{{type="fluid", name="crude-oil", amount=10}, {type="fluid", name="water", amount=5}}
---```
---@field ingredients Ingredient[]
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @Localised name of the recipe.`[R]`
---@field name string @Name of the recipe. This can be different than the name of the result items as there could be more recipes to make the same item.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field products Product[] @The results of this recipe.`[R]`
---@field prototype LuaRecipePrototype @The prototype for this recipe.`[R]`
---@field subgroup LuaGroup @Subgroup of this recipe.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRecipe = {}

---All methods and properties that this object supports.
---@return string
function LuaRecipe.help() end

---Reload the recipe from the prototype.
function LuaRecipe.reload() end

---Prototype of a recipe category.
---@class LuaRecipeCategoryPrototype
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRecipeCategoryPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaRecipeCategoryPrototype.help() end

---A crafting recipe prototype.
---@class LuaRecipePrototype
---@field allow_as_intermediate boolean @If this recipe is enabled for the purpose of intermediate hand-crafting.`[R]`
---@field allow_decomposition boolean @Is this recipe allowed to be broken down for the recipe tooltip "Total raw" calculations?`[R]`
---@field allow_inserter_overload boolean @If the recipe is allowed to have the extra inserter overload bonus applied (4 * stack inserter stack size).`[R]`
---@field allow_intermediates boolean @If this recipe is allowed to use intermediate recipes when hand-crafting.`[R]`
---@field always_show_made_in boolean @Should this recipe always show "Made in" in the tooltip?`[R]`
---@field always_show_products boolean @If the products are always shown in the recipe tooltip.`[R]`
---@field category string @Category of the recipe.`[R]`
---@field emissions_multiplier double @The emissions multiplier for this recipe.`[R]`
---@field enabled boolean @If this recipe prototype is enabled by default (enabled at the beginning of a game).`[R]`
---@field energy double @Energy required to execute this recipe. This directly affects the crafting time: Recipe's energy is exactly its crafting time in seconds, when crafted in an assembling machine with crafting speed exactly equal to one.`[R]`
---@field group LuaGroup @Group of this recipe.`[R]`
---@field hidden boolean @Is the recipe hidden? Hidden recipe don't show up in the crafting menu.`[R]`
---@field hidden_from_flow_stats boolean @Is the recipe hidden from flow statistics (item/fluid production statistics)?`[R]`
---@field hidden_from_player_crafting boolean @Is the recipe hidden from player crafting? The recipe will still show up for selection in machines.`[R]`
---@field ingredients Ingredient[] @Ingredients for this recipe.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @Localised name of the recipe.`[R]`
---@field main_product Product @The main product of this recipe, `nil` if no main product is defined.`[R]`
---@field name string @Name of the recipe. This can be different than the name of the result items as there could be more recipes to make the same item.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field overload_multiplier uint @Used to determine how many extra items are put into an assembling machine before it's considered "full enough".`[R]`
---@field products Product[] @The results of this recipe.`[R]`
---@field request_paste_multiplier uint @The multiplier used when this recipe is copied from an assembling machine to a requester chest. For each item in the recipe the item count * this value is set in the requester chest.`[R]`
---@field show_amount_in_title boolean @If the amount is shown in the recipe tooltip title when the recipe produces more than 1 product.`[R]`
---@field subgroup LuaGroup @Subgroup of this recipe.`[R]`
---@field unlock_results boolean @Is this recipe unlocks the result item(s) so they're shown in filter-select GUIs.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaRecipePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaRecipePrototype.help() end

---Registry of interfaces between scripts. An interface is simply a dictionary mapping names to functions. A script or mod can then register an interface with [LuaRemote](LuaRemote), after that any script can call the registered functions, provided it knows the interface name and the desired function name. An instance of LuaRemote is available through the global object named `remote`.
---
---Will register a remote interface containing two functions. Later, it will call these functions through `remote`. 
---```lua
---remote.add_interface("human interactor",
---                     {hello = function() game.player.print("Hi!") end,
---                      bye = function(name) game.player.print("Bye " .. name) end})
----- Some time later, possibly in a different mod...
---remote.call("human interactor", "hello")
---remote.call("human interactor", "bye", "dear reader")
---```
---@class LuaRemote
---List of all registered interfaces. For each interface name, `remote.interfaces[name]` is a dictionary mapping the interface's registered functions to the value `true`.`[R]`
---
---Assuming the "human interactor" interface is registered as above 
---```lua
---game.player.print(tostring(remote.interfaces["human interactor"]["hello"]))        -- prints true
---game.player.print(tostring(remote.interfaces["human interactor"]["nonexistent"]))  -- prints nil
---```
---@field interfaces table<string, table<string, boolean>>
---@field object_name string @This object's name.`[R]`
local LuaRemote = {}

---Add a remote interface.
---
---It is an error if the given interface `name` is already registered.
---@param _name string @Name of the interface.
---@param _functions table<string, fun()> @List of functions that are members of the new interface.
function LuaRemote.add_interface(_name, _functions) end

---Call a function of an interface.
---@param _interface string @Interface to look up `function` in.
---@param _function string @Function name that belongs to `interface`.
---@return Any
function LuaRemote.call(_interface, _function) end

---Removes an interface with the given name.
---@param _name string @Name of the interface.
---@return boolean @Whether the interface was removed. `False` if the interface didn't exist.
function LuaRemote.remove_interface(_name) end

---Allows rendering of geometric shapes, text and sprites in the game world. Each render object is identified by an id that is universally unique for the lifetime of a whole game.
---
---If an entity target of an object is destroyed or changes surface, then the object is also destroyed.
---@class LuaRendering
---@field object_name string @This object's name.`[R]`
local LuaRendering = {}

---Reorder this object so that it is drawn in front of the already existing objects.
---@param _id uint64
function LuaRendering.bring_to_front(_id) end

---Destroys all render objects.
---@param _mod_name? string @If provided, only the render objects created by this mod are destroyed.
function LuaRendering.clear(_mod_name) end

---Destroy the object with the given id.
---@param _id uint64
function LuaRendering.destroy(_id) end

---Create an animation.
---@param _table LuaRendering.draw_animation
---@return uint64 @Id of the render object
function LuaRendering.draw_animation(_table) end

---Create an arc.
---@param _table LuaRendering.draw_arc
---@return uint64 @Id of the render object
function LuaRendering.draw_arc(_table) end

---Create a circle.
---@param _table LuaRendering.draw_circle
---@return uint64 @Id of the render object
function LuaRendering.draw_circle(_table) end

---Create a light.
---
---The base game uses the utility sprites `light_medium` and `light_small` for lights.
---@param _table LuaRendering.draw_light
---@return uint64 @Id of the render object
function LuaRendering.draw_light(_table) end

---Create a line.
---
---Draw a white and 2 pixel wide line from {0, 0} to {2, 2}. 
---```lua
---rendering.draw_line{surface = game.player.surface, from = {0, 0}, to = {2, 2}, color = {1, 1, 1}, width = 2}
---```
---\
---Draw a red and 3 pixel wide line from {0, 0} to {0, 5}. The line has 1 tile long dashes and gaps. 
---```lua
---rendering.draw_line{surface = game.player.surface, from = {0, 0}, to = {0, 5}, color = {r = 1}, width = 3, gap_length = 1, dash_length = 1}
---```
---@param _table LuaRendering.draw_line
---@return uint64 @Id of the render object
function LuaRendering.draw_line(_table) end

---Create a triangle mesh defined by a triangle strip.
---@param _table LuaRendering.draw_polygon
---@return uint64 @Id of the render object
function LuaRendering.draw_polygon(_table) end

---Create a rectangle.
---@param _table LuaRendering.draw_rectangle
---@return uint64 @Id of the render object
function LuaRendering.draw_rectangle(_table) end

---Create a sprite.
---
---This will draw an iron plate icon at the character's feet. The sprite will move together with the character. 
---```lua
---rendering.draw_sprite{sprite = "item.iron-plate", target = game.player.character, surface = game.player.surface}
---```
---\
---This will draw an iron plate icon at the character's head. The sprite will move together with the character. 
---```lua
---rendering.draw_sprite{sprite = "item.iron-plate", target = game.player.character, target_offset = {0, -2}, surface = game.player.surface}
---```
---@param _table LuaRendering.draw_sprite
---@return uint64 @Id of the render object
function LuaRendering.draw_sprite(_table) end

---Create a text.
---
---Not all fonts support scaling.
---@param _table LuaRendering.draw_text
---@return uint64 @Id of the render object
function LuaRendering.draw_text(_table) end

---Get the alignment of the text with this id.
---@param _id uint64
---@return string @`nil` if the object is not a text.
function LuaRendering.get_alignment(_id) end

---Gets an array of all valid object ids.
---@param _mod_name? string @If provided, get only the render objects created by this mod.
---@return uint64[]
function LuaRendering.get_all_ids(_mod_name) end

---Get the angle of the arc with this id.
---@param _id uint64
---@return float @Angle in radian. `nil` if the object is not a arc.
function LuaRendering.get_angle(_id) end

---Get the animation prototype name of the animation with this id.
---@param _id uint64
---@return string @`nil` if the object is not an animation.
function LuaRendering.get_animation(_id) end

---Get the animation offset of the animation with this id.
---@param _id uint64
---@return double @Animation offset in frames. `nil` if the object is not an animation.
function LuaRendering.get_animation_offset(_id) end

---Get the animation speed of the animation with this id.
---@param _id uint64
---@return double @Animation speed in frames per tick. `nil` if the object is not an animation.
function LuaRendering.get_animation_speed(_id) end

---Get the color or tint of the object with this id.
---@param _id uint64
---@return Color @`nil` if the object does not support color.
function LuaRendering.get_color(_id) end

---Get the dash length of the line with this id.
---@param _id uint64
---@return double @`nil` if the object is not a line.
function LuaRendering.get_dash_length(_id) end

---Get whether this is being drawn on the ground, under most entities and sprites.
---@param _id uint64
---@return boolean
function LuaRendering.get_draw_on_ground(_id) end

---Get if the circle or rectangle with this id is filled.
---@param _id uint64
---@return boolean @`nil` if the object is not a circle or rectangle.
function LuaRendering.get_filled(_id) end

---Get the font of the text with this id.
---@param _id uint64
---@return string @`nil` if the object is not a text.
function LuaRendering.get_font(_id) end

---Get the forces that the object with this id is rendered to or `nil` if visible to all forces.
---@param _id uint64
---@return LuaForce[]
function LuaRendering.get_forces(_id) end

---Get from where the line with this id is drawn.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if this object is not a line.
function LuaRendering.get_from(_id) end

---Get the length of the gaps in the line with this id.
---@param _id uint64
---@return double @`nil` if the object is not a line.
function LuaRendering.get_gap_length(_id) end

---Get the intensity of the light with this id.
---@param _id uint64
---@return float @`nil` if the object is not a light.
function LuaRendering.get_intensity(_id) end

---Get where top left corner of the rectangle with this id is drawn.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object is not a rectangle.
function LuaRendering.get_left_top(_id) end

---Get the radius of the outer edge of the arc with this id.
---@param _id uint64
---@return double @`nil` if the object is not a arc.
function LuaRendering.get_max_radius(_id) end

---Get the radius of the inner edge of the arc with this id.
---@param _id uint64
---@return double @`nil` if the object is not a arc.
function LuaRendering.get_min_radius(_id) end

---Get the minimum darkness at which the light with this id is rendered.
---@param _id uint64
---@return float @`nil` if the object is not a light.
function LuaRendering.get_minimum_darkness(_id) end

---Get whether this is only rendered in alt-mode.
---@param _id uint64
---@return boolean
function LuaRendering.get_only_in_alt_mode(_id) end

---Get the orientation of the object with this id.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@return RealOrientation @`nil` if the object is not a text, polygon, sprite, light or animation.
function LuaRendering.get_orientation(_id) end

---The object rotates so that it faces this target. Note that `orientation` is still applied to the object. Get the orientation_target of the object with this id.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if no target or if this object is not a polygon, sprite, or animation.
function LuaRendering.get_orientation_target(_id) end

---Get if the light with this id is rendered has the same orientation as the target entity. Note that `orientation` is still applied to the sprite.
---@param _id uint64
---@return boolean @`nil` if the object is not a light.
function LuaRendering.get_oriented(_id) end

---Offsets the center of the sprite or animation if `orientation_target` is given. This offset will rotate together with the sprite or animation. Get the oriented_offset of the sprite or animation with this id.
---@param _id uint64
---@return Vector @`nil` if this object is not a sprite or animation.
function LuaRendering.get_oriented_offset(_id) end

---Get the players that the object with this id is rendered to or `nil` if visible to all players.
---@param _id uint64
---@return LuaPlayer[]
function LuaRendering.get_players(_id) end

---Get the radius of the circle with this id.
---@param _id uint64
---@return double @`nil` if the object is not a circle.
function LuaRendering.get_radius(_id) end

---Get the render layer of the sprite or animation with this id.
---@param _id uint64
---@return RenderLayer @`nil` if the object is not a sprite or animation.
function LuaRendering.get_render_layer(_id) end

---Get where bottom right corner of the rectangle with this id is drawn.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object is not a rectangle.
function LuaRendering.get_right_bottom(_id) end

---Get the scale of the text or light with this id.
---@param _id uint64
---@return double @`nil` if the object is not a text or light.
function LuaRendering.get_scale(_id) end

---Get if the text with this id scales with player zoom.
---@param _id uint64
---@return boolean @`nil` if the object is not a text.
function LuaRendering.get_scale_with_zoom(_id) end

---Get the sprite of the sprite or light with this id.
---@param _id uint64
---@return SpritePath @`nil` if the object is not a sprite or light.
function LuaRendering.get_sprite(_id) end

---Get where the arc with this id starts.
---@param _id uint64
---@return float @Angle in radian. `nil` if the object is not a arc.
function LuaRendering.get_start_angle(_id) end

---The surface the object with this id is rendered on.
---@param _id uint64
---@return LuaSurface
function LuaRendering.get_surface(_id) end

---Get where the object with this id is drawn.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object does not support target.
function LuaRendering.get_target(_id) end

---Get the text that is displayed by the text with this id.
---@param _id uint64
---@return LocalisedString @`nil` if the object is not a text.
function LuaRendering.get_text(_id) end

---Get the time to live of the object with this id. This will be 0 if the object does not expire.
---@param _id uint64
---@return uint
function LuaRendering.get_time_to_live(_id) end

---Get where the line with this id is drawn to.
---@param _id uint64
---@return ScriptRenderTarget @`nil` if the object is not a line.
function LuaRendering.get_to(_id) end

---Gets the type of the given object. The types are "text", "line", "circle", "rectangle", "arc", "polygon", "sprite", "light" and "animation".
---@param _id uint64
---@return string
function LuaRendering.get_type(_id) end

---Get the vertical alignment of the text with this id.
---@param _id uint64
---@return string @`nil` if the object is not a text.
function LuaRendering.get_vertical_alignment(_id) end

---Get the vertices of the polygon with this id.
---@param _id uint64
---@return ScriptRenderTarget[] @`nil` if the object is not a polygon.
function LuaRendering.get_vertices(_id) end

---Get whether this is rendered to anyone at all.
---@param _id uint64
---@return boolean
function LuaRendering.get_visible(_id) end

---Get the width of the object with this id. Value is in pixels (32 per tile).
---@param _id uint64
---@return float @`nil` if the object does not support width.
function LuaRendering.get_width(_id) end

---Get the horizontal scale of the sprite or animation with this id.
---@param _id uint64
---@return double @`nil` if the object is not a sprite or animation.
function LuaRendering.get_x_scale(_id) end

---Get the vertical scale of the sprite or animation with this id.
---@param _id uint64
---@return double @`nil` if the object is not a sprite or animation.
function LuaRendering.get_y_scale(_id) end

---Does a font with this name exist?
---@param _font_name string
---@return boolean
function LuaRendering.is_font_valid(_font_name) end

---Does a valid object with this id exist?
---@param _id uint64
---@return boolean
function LuaRendering.is_valid(_id) end

---Set the alignment of the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _alignment string @"left", "right" or "center".
function LuaRendering.set_alignment(_id, _alignment) end

---Set the angle of the arc with this id. Does nothing if this object is not a arc.
---@param _id uint64
---@param _angle float @angle in radian
function LuaRendering.set_angle(_id, _angle) end

---Set the animation prototype name of the animation with this id. Does nothing if this object is not an animation.
---@param _id uint64
---@param _animation string
function LuaRendering.set_animation(_id, _animation) end

---Set the animation offset of the animation with this id. Does nothing if this object is not an animation.
---@param _id uint64
---@param _animation_offset double @Animation offset in frames.
function LuaRendering.set_animation_offset(_id, _animation_offset) end

---Set the animation speed of the animation with this id. Does nothing if this object is not an animation.
---@param _id uint64
---@param _animation_speed double @Animation speed in frames per tick.
function LuaRendering.set_animation_speed(_id, _animation_speed) end

---Set the color or tint of the object with this id. Does nothing if this object does not support color.
---@param _id uint64
---@param _color Color
function LuaRendering.set_color(_id, _color) end

---Set the corners of the rectangle with this id. Does nothing if this object is not a rectangle.
---@param _id uint64
---@param _left_top MapPosition|LuaEntity
---@param _left_top_offset Vector
---@param _right_bottom MapPosition|LuaEntity
---@param _right_bottom_offset Vector
function LuaRendering.set_corners(_id, _left_top, _left_top_offset, _right_bottom, _right_bottom_offset) end

---Set the dash length of the line with this id. Does nothing if this object is not a line.
---@param _id uint64
---@param _dash_length double
function LuaRendering.set_dash_length(_id, _dash_length) end

---Set the length of the dashes and the length of the gaps in the line with this id. Does nothing if this object is not a line.
---@param _id uint64
---@param _dash_length double
---@param _gap_length double
function LuaRendering.set_dashes(_id, _dash_length, _gap_length) end

---Set whether this is being drawn on the ground, under most entities and sprites.
---@param _id uint64
---@param _draw_on_ground boolean
function LuaRendering.set_draw_on_ground(_id, _draw_on_ground) end

---Set if the circle or rectangle with this id is filled. Does nothing if this object is not a circle or rectangle.
---@param _id uint64
---@param _filled boolean
function LuaRendering.set_filled(_id, _filled) end

---Set the font of the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _font string
function LuaRendering.set_font(_id, _font) end

---Set the forces that the object with this id is rendered to.
---@param _id uint64
---@param _forces ForceIdentification[] @Providing an empty array will set the object to be visible to all forces.
function LuaRendering.set_forces(_id, _forces) end

---Set from where the line with this id is drawn. Does nothing if the object is not a line.
---@param _id uint64
---@param _from MapPosition|LuaEntity
---@param _from_offset? Vector
function LuaRendering.set_from(_id, _from, _from_offset) end

---Set the length of the gaps in the line with this id. Does nothing if this object is not a line.
---@param _id uint64
---@param _gap_length double
function LuaRendering.set_gap_length(_id, _gap_length) end

---Set the intensity of the light with this id. Does nothing if this object is not a light.
---@param _id uint64
---@param _intensity float
function LuaRendering.set_intensity(_id, _intensity) end

---Set where top left corner of the rectangle with this id is drawn. Does nothing if this object is not a rectangle.
---@param _id uint64
---@param _left_top MapPosition|LuaEntity
---@param _left_top_offset? Vector
function LuaRendering.set_left_top(_id, _left_top, _left_top_offset) end

---Set the radius of the outer edge of the arc with this id. Does nothing if this object is not a arc.
---@param _id uint64
---@param _max_radius double
function LuaRendering.set_max_radius(_id, _max_radius) end

---Set the radius of the inner edge of the arc with this id. Does nothing if this object is not a arc.
---@param _id uint64
---@param _min_radius double
function LuaRendering.set_min_radius(_id, _min_radius) end

---Set the minimum darkness at which the light with this id is rendered. Does nothing if this object is not a light.
---@param _id uint64
---@param _minimum_darkness float
function LuaRendering.set_minimum_darkness(_id, _minimum_darkness) end

---Set whether this is only rendered in alt-mode.
---@param _id uint64
---@param _only_in_alt_mode boolean
function LuaRendering.set_only_in_alt_mode(_id, _only_in_alt_mode) end

---Set the orientation of the object with this id. Does nothing if this object is not a text, polygon, sprite, light or animation.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@param _orientation RealOrientation
function LuaRendering.set_orientation(_id, _orientation) end

---The object rotates so that it faces this target. Note that `orientation` is still applied to the object. Set the orientation_target of the object with this id. Does nothing if this object is not a polygon, sprite, or animation. Set to `nil` if the object should not have an orientation_target.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@param _orientation_target MapPosition|LuaEntity
---@param _orientation_target_offset? Vector
function LuaRendering.set_orientation_target(_id, _orientation_target, _orientation_target_offset) end

---Set if the light with this id is rendered has the same orientation as the target entity. Does nothing if this object is not a light. Note that `orientation` is still applied to the sprite.
---@param _id uint64
---@param _oriented boolean
function LuaRendering.set_oriented(_id, _oriented) end

---Offsets the center of the sprite or animation if `orientation_target` is given. This offset will rotate together with the sprite or animation. Set the oriented_offset of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _oriented_offset Vector
function LuaRendering.set_oriented_offset(_id, _oriented_offset) end

---Set the players that the object with this id is rendered to.
---@param _id uint64
---@param _players PlayerIdentification[] @Providing an empty array will set the object to be visible to all players.
function LuaRendering.set_players(_id, _players) end

---Set the radius of the circle with this id. Does nothing if this object is not a circle.
---@param _id uint64
---@param _radius double
function LuaRendering.set_radius(_id, _radius) end

---Set the render layer of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _render_layer RenderLayer
function LuaRendering.set_render_layer(_id, _render_layer) end

---Set where top bottom right of the rectangle with this id is drawn. Does nothing if this object is not a rectangle.
---@param _id uint64
---@param _right_bottom MapPosition|LuaEntity
---@param _right_bottom_offset? Vector
function LuaRendering.set_right_bottom(_id, _right_bottom, _right_bottom_offset) end

---Set the scale of the text or light with this id. Does nothing if this object is not a text or light.
---@param _id uint64
---@param _scale double
function LuaRendering.set_scale(_id, _scale) end

---Set if the text with this id scales with player zoom, resulting in it always being the same size on screen, and the size compared to the game world changes. Does nothing if this object is not a text.
---@param _id uint64
---@param _scale_with_zoom boolean
function LuaRendering.set_scale_with_zoom(_id, _scale_with_zoom) end

---Set the sprite of the sprite or light with this id. Does nothing if this object is not a sprite or light.
---@param _id uint64
---@param _sprite SpritePath
function LuaRendering.set_sprite(_id, _sprite) end

---Set where the arc with this id starts. Does nothing if this object is not a arc.
---@param _id uint64
---@param _start_angle float @angle in radian
function LuaRendering.set_start_angle(_id, _start_angle) end

---Set where the object with this id is drawn. Does nothing if this object does not support target.
---
---Polygon vertices that are set to an entity will ignore this.
---@param _id uint64
---@param _target MapPosition|LuaEntity
---@param _target_offset? Vector
function LuaRendering.set_target(_id, _target, _target_offset) end

---Set the text that is displayed by the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _text LocalisedString
function LuaRendering.set_text(_id, _text) end

---Set the time to live of the object with this id. Set to 0 if the object should not expire.
---@param _id uint64
---@param _time_to_live uint
function LuaRendering.set_time_to_live(_id, _time_to_live) end

---Set where the line with this id is drawn to. Does nothing if this object is not a line.
---@param _id uint64
---@param _to MapPosition|LuaEntity
---@param _to_offset? Vector
function LuaRendering.set_to(_id, _to, _to_offset) end

---Set the vertical alignment of the text with this id. Does nothing if this object is not a text.
---@param _id uint64
---@param _alignment string @"top", "middle", "baseline" or "bottom"
function LuaRendering.set_vertical_alignment(_id, _alignment) end

---Set the vertices of the polygon with this id. Does nothing if this object is not a polygon.
---@param _id uint64
---@param _vertices ScriptRenderVertexTarget[]
function LuaRendering.set_vertices(_id, _vertices) end

---Set whether this is rendered to anyone at all.
---@param _id uint64
---@param _visible boolean
function LuaRendering.set_visible(_id, _visible) end

---Set the width of the object with this id. Does nothing if this object does not support width. Value is in pixels (32 per tile).
---@param _id uint64
---@param _width float
function LuaRendering.set_width(_id, _width) end

---Set the horizontal scale of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _x_scale double
function LuaRendering.set_x_scale(_id, _x_scale) end

---Set the vertical scale of the sprite or animation with this id. Does nothing if this object is not a sprite or animation.
---@param _id uint64
---@param _y_scale double
function LuaRendering.set_y_scale(_id, _y_scale) end


---@class LuaRendering.draw_animation
---@field animation string @Name of an [animation prototype](https://wiki.factorio.com/Prototype/Animation).
---@field orientation? RealOrientation @The orientation of the animation. Default is 0.
---@field x_scale? double @Horizontal scale of the animation. Default is 1.
---@field y_scale? double @Vertical scale of the animation. Default is 1.
---@field tint? Color
---@field render_layer? RenderLayer
---@field animation_speed? double @How many frames the animation goes forward per tick. Default is 1.
---@field animation_offset? double @Offset of the animation in frames. Default is 0.
---@field orientation_target? MapPosition|LuaEntity @If given, the animation rotates so that it faces this target. Note that `orientation` is still applied to the animation.
---@field orientation_target_offset? Vector @Only used if `orientation_target` is a LuaEntity.
---@field oriented_offset? Vector @Offsets the center of the animation if `orientation_target` is given. This offset will rotate together with the animation.
---@field target MapPosition|LuaEntity @Center of the animation.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_arc
---@field color Color
---@field max_radius double @The radius of the outer edge of the arc, in tiles.
---@field min_radius double @The radius of the inner edge of the arc, in tiles.
---@field start_angle float @Where the arc starts, in radian.
---@field angle float @The angle of the arc, in radian.
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_circle
---@field color Color
---@field radius double @In tiles.
---@field width? float @Width of the outline, used only if filled = false. Value is in pixels (32 per tile).
---@field filled boolean @If the circle should be filled.
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_light
---@field sprite SpritePath
---@field orientation? RealOrientation @The orientation of the light. Default is 0.
---@field scale? float @Default is 1.
---@field intensity? float @Default is 1.
---@field minimum_darkness? float @The minimum darkness at which this light is rendered. Default is 0.
---@field oriented? boolean @If this light has the same orientation as the entity target, default is false. Note that `orientation` is still applied to the sprite.
---@field color? Color @Defaults to white (no tint).
---@field target MapPosition|LuaEntity @Center of the light.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_line
---@field color Color
---@field width float @In pixels (32 per tile).
---@field gap_length? double @Length of the gaps that this line has, in tiles. Default is 0.
---@field dash_length? double @Length of the dashes that this line has. Used only if gap_length > 0. Default is 0.
---@field from MapPosition|LuaEntity
---@field from_offset? Vector @Only used if `from` is a LuaEntity.
---@field to MapPosition|LuaEntity
---@field to_offset? Vector @Only used if `to` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_polygon
---@field color Color
---@field vertices ScriptRenderVertexTarget[]
---@field target? MapPosition|LuaEntity @Acts like an offset applied to all vertices that are not set to an entity.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field orientation? RealOrientation @The orientation applied to all vertices. Default is 0.
---@field orientation_target? MapPosition|LuaEntity @If given, the vertices (that are not set to an entity) rotate so that it faces this target. Note that `orientation` is still applied.
---@field orientation_target_offset? Vector @Only used if `orientation_target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_rectangle
---@field color Color
---@field width? float @Width of the outline, used only if filled = false. Value is in pixels (32 per tile).
---@field filled boolean @If the rectangle should be filled.
---@field left_top MapPosition|LuaEntity
---@field left_top_offset? Vector @Only used if `left_top` is a LuaEntity.
---@field right_bottom MapPosition|LuaEntity
---@field right_bottom_offset? Vector @Only used if `right_bottom` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_sprite
---@field sprite SpritePath
---@field orientation? RealOrientation @The orientation of the sprite. Default is 0.
---@field x_scale? double @Horizontal scale of the sprite. Default is 1.
---@field y_scale? double @Vertical scale of the sprite. Default is 1.
---@field tint? Color
---@field render_layer? RenderLayer
---@field orientation_target? MapPosition|LuaEntity @If given, the sprite rotates so that it faces this target. Note that `orientation` is still applied to the sprite.
---@field orientation_target_offset? Vector @Only used if `orientation_target` is a LuaEntity.
---@field oriented_offset? Vector @Offsets the center of the sprite if `orientation_target` is given. This offset will rotate together with the sprite.
---@field target MapPosition|LuaEntity @Center of the sprite.
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field surface SurfaceIdentification
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

---@class LuaRendering.draw_text
---@field text LocalisedString @The text to display.
---@field surface SurfaceIdentification
---@field target MapPosition|LuaEntity
---@field target_offset? Vector @Only used if `target` is a LuaEntity.
---@field color Color
---@field scale? double
---@field font? string @Name of font to use. Defaults to the same font as flying-text.
---@field time_to_live? uint @In ticks. Defaults to living forever.
---@field forces? ForceIdentification[] @The forces that this object is rendered to. Passing `nil` or an empty table will render it to all forces.
---@field players? PlayerIdentification[] @The players that this object is rendered to. Passing `nil` or an empty table will render it to all players.
---@field visible? boolean @If this is rendered to anyone at all. Defaults to true.
---@field draw_on_ground? boolean @If this should be drawn below sprites and entities.
---@field orientation? RealOrientation @The orientation of the text. Default is 0.
---@field alignment? string @Defaults to "left". Other options are "right" and "center".
---@field vertical_alignment? string @Defaults to "top". Other options are "middle", "baseline" and "bottom".
---@field scale_with_zoom? boolean @Defaults to false. If true, the text scales with player zoom, resulting in it always being the same size on screen, and the size compared to the game world changes.
---@field only_in_alt_mode? boolean @If this should only be rendered in alt mode. Defaults to false.

