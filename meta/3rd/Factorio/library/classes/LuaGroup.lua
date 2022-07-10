---@meta

---Item group or subgroup.
---@class LuaGroup
---@field group LuaGroup @The parent group if any; `nil` if none.`[R]`
---@field localised_name LocalisedString @Localised name of the group.`[R]`
---@field name string @`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---The additional order value used in recipe ordering.`[R]`
---
---Can only be used on groups, not on subgroups.
---@field order_in_recipe string
---Subgroups of this group.`[R]`
---
---Can only be used on groups, not on subgroups.
---@field subgroups LuaGroup[]
---@field type string @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaGroup = {}

---All methods and properties that this object supports.
---@return string
function LuaGroup.help() end

