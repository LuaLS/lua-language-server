---@meta

---Prototype of an optimized decorative.
---@class LuaDecorativePrototype
---@field autoplace_specification AutoplaceSpecification @Autoplace specification for this decorative prototype. `nil` if none.`[R]`
---@field collision_box BoundingBox @The bounding box used for collision checking.`[R]`
---@field collision_mask CollisionMask @The collision masks this decorative uses`[R]`
---@field collision_mask_with_flags CollisionMaskWithFlags @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaDecorativePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaDecorativePrototype.help() end

