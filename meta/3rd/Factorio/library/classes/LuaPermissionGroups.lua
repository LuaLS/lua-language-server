---@meta

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

