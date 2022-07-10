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

