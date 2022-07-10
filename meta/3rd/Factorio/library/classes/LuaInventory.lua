---@meta

---A storage of item stacks.
---@class LuaInventory
---@field entity_owner LuaEntity @The entity that owns this inventory or `nil` if this isn't owned by an entity.`[R]`
---@field equipment_owner LuaEquipment @The equipment that owns this inventory or `nil` if this isn't owned by an equipment.`[R]`
---@field index defines.inventory @The inventory index this inventory uses, or `nil` if the inventory doesn't have an index.`[R]`
---@field mod_owner string @The mod that owns this inventory or `nil` if this isn't owned by a mod.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field player_owner LuaPlayer @The player that owns this inventory or `nil` if this isn't owned by a player.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---The indexing operator.`[R]`
---
---Will get the first item in the player's inventory. 
---```lua
---game.player.get_main_inventory()[1]
---```
---@field [number] LuaItemStack
local LuaInventory = {}

---Can at least some items be inserted?
---@param _items ItemStackIdentification @Items that would be inserted.
---@return boolean @`true` if at least a part of the given items could be inserted into this inventory.
function LuaInventory.can_insert(_items) end

---If the given inventory slot filter can be set to the given filter.
---@param _index uint @The item stack index
---@param _filter string @The item name of the filter
---@return boolean
function LuaInventory.can_set_filter(_index, _filter) end

---Make this inventory empty.
function LuaInventory.clear() end

---Counts the number of empty stacks.
---@param _include_filtered? boolean @If true, filtered slots will be included. Defaults to false.
---@return uint
function LuaInventory.count_empty_stacks(_include_filtered) end

---Destroys this inventory.
---
---Only inventories created by [LuaGameScript::create_inventory](LuaGameScript::create_inventory) can be destroyed this way.
function LuaInventory.destroy() end

---Finds the first empty stack. Filtered slots are excluded unless a filter item is given.
---@param _item? string @If given, empty stacks that are filtered for this item will be included.
---@return LuaItemStack @The first empty stack, or `nil` if there aren't any empty stacks.
---@return uint @The stack index of the matching stack, if any is found.
function LuaInventory.find_empty_stack(_item) end

---Gets the first LuaItemStack in the inventory that matches the given item name.
---@param _item string @The item name to find
---@return LuaItemStack @The first matching stack, or `nil` if none match.
---@return uint @The stack index of the matching stack, if any is found.
function LuaInventory.find_item_stack(_item) end

---Get the current bar. This is the index at which the red area starts.
---
---Only useable if this inventory supports having a bar.
---@return uint
function LuaInventory.get_bar() end

---Get counts of all items in this inventory.
---@return table<string, uint> @The counts, indexed by item names.
function LuaInventory.get_contents() end

---Gets the filter for the given item stack index.
---@param _index uint @The item stack index
---@return string @The current filter or `nil` if none.
function LuaInventory.get_filter(_index) end

---Gets the number of the given item that can be inserted into this inventory.
---
---This is a "best guess" number; things like assembling machine filtered slots, module slots, items with durability, and items with mixed health will cause the result to be inaccurate.
---\
---The main use for this is in checking how many of a basic item can fit into a basic inventory.
---\
---This accounts for the 'bar' on the inventory.
---@param _item string @The item to check.
function LuaInventory.get_insertable_count(_item) end

---Get the number of all or some items in this inventory.
---@param _item? string @Prototype name of the item to count. If not specified, count all items.
---@return uint
function LuaInventory.get_item_count(_item) end

---All methods and properties that this object supports.
---@return string
function LuaInventory.help() end

---Insert items into this inventory.
---@param _items ItemStackIdentification @Items to insert.
---@return uint @Number of items actually inserted.
function LuaInventory.insert(_items) end

---Does this inventory contain nothing?
---@return boolean
function LuaInventory.is_empty() end

---If this inventory supports filters and has at least 1 filter set.
---@return boolean
function LuaInventory.is_filtered() end

---Remove items from this inventory.
---@param _items ItemStackIdentification @Items to remove.
---@return uint @Number of items actually removed.
function LuaInventory.remove(_items) end

---Resizes the inventory.
---
---Items in slots beyond the new capacity are deleted.
---\
---Only inventories created by [LuaGameScript::create_inventory](LuaGameScript::create_inventory) can be resized.
---@param _size uint16 @New size of a inventory
function LuaInventory.resize(_size) end

---Set the current bar.
---
---Only useable if this inventory supports having a bar.
---@param _bar? uint @The new limit. Omitting this parameter will clear the limit.
function LuaInventory.set_bar(_bar) end

---Sets the filter for the given item stack index.
---
---Some inventory slots don't allow some filters (gun ammo can't be filtered for non-ammo).
---@param _index uint @The item stack index
---@param _filter string @The new filter or nil to erase the filter
---@return boolean @If the filter was allowed to be set.
function LuaInventory.set_filter(_index, _filter) end

---Sorts and merges the items in this inventory.
function LuaInventory.sort_and_merge() end

---Does this inventory support a bar? Bar is the draggable red thing, found for example on chests, that limits the portion of the inventory that may be manipulated by machines.
---
---"Supporting a bar" doesn't mean that the bar is set to some nontrivial value. Supporting a bar means the inventory supports having this limit at all. The character's inventory is an example of an inventory without a bar; the wooden chest's inventory is an example of one with a bar.
---@return boolean
function LuaInventory.supports_bar() end

---If this inventory supports filters.
---@return boolean
function LuaInventory.supports_filters() end

