---@meta

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

