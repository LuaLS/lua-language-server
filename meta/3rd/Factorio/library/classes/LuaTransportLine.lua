---@meta

---One line on a transport belt.
---@class LuaTransportLine
---@field input_lines LuaTransportLine[] @The transport lines that this transport line is fed by or an empty table if none.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field output_lines LuaTransportLine[] @The transport lines that this transport line outputs items to or an empty table if none.`[R]`
---@field owner LuaEntity @The entity this transport line belongs to.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field [number] LuaItemStack @The indexing operator.`[R]`
local LuaTransportLine = {}

---Can an item be inserted at a given position?
---@param _position float @Where to insert an item.
---@return boolean
function LuaTransportLine.can_insert_at(_position) end

---Can an item be inserted at the back of this line?
---@return boolean
function LuaTransportLine.can_insert_at_back() end

---Remove all items from this transport line.
function LuaTransportLine.clear() end

---Get counts of all items on this line, similar to how [LuaInventory::get_contents](LuaInventory::get_contents) does.
---@return table<string, uint> @The counts, indexed by item names.
function LuaTransportLine.get_contents() end

---Count some or all items on this line, similar to how [LuaInventory::get_item_count](LuaInventory::get_item_count) does.
---@param _item? string @Prototype name of the item to count. If not specified, count all items.
---@return uint
function LuaTransportLine.get_item_count(_item) end

---All methods and properties that this object supports.
---@return string
function LuaTransportLine.help() end

---Insert items at a given position.
---@param _position float @Where on the line to insert the items.
---@param _items ItemStackIdentification @Items to insert.
---@return boolean @Were the items inserted successfully?
function LuaTransportLine.insert_at(_position, _items) end

---Insert items at the back of this line.
---@param _items ItemStackIdentification
---@return boolean @Were the items inserted successfully?
function LuaTransportLine.insert_at_back(_items) end

---Returns whether the associated internal transport line of this line is the same as the others associated internal transport line.
---
---This can return true even when the [LuaTransportLine::owner](LuaTransportLine::owner)s are different (so `this == other` is false), because the internal transport lines can span multiple tiles.
---@param _other LuaTransportLine
---@return boolean
function LuaTransportLine.line_equals(_other) end

---Remove some items from this line.
---@param _items ItemStackIdentification @Items to remove.
---@return uint @Number of items actually removed.
function LuaTransportLine.remove_item(_items) end

