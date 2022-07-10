---@meta

---Prototype of a tile.
---@class LuaTilePrototype
---@field allowed_neighbors table<string, LuaTilePrototype> @`[R]`
---@field automatic_neighbors boolean @`[R]`
---@field autoplace_specification AutoplaceSpecification @Autoplace specification for this prototype. `nil` if none.`[R]`
---@field can_be_part_of_blueprint boolean @False if this tile is not allowed in blueprints regardless of the ability to build it.`[R]`
---@field check_collision_with_entities boolean @True if building this tile should check for colliding entities above and prevent building if such are found. Also during mining tiles above this tile checks for entities colliding with this tile and prevents mining if such are found.`[R]`
---@field collision_mask CollisionMask @The collision mask this tile uses`[R]`
---@field collision_mask_with_flags CollisionMaskWithFlags @`[R]`
---@field decorative_removal_probability float @The probability that decorative entities will be removed from on top of this tile when this tile is generated.`[R]`
---@field emissions_per_second double @Amount of pollution emissions per second this tile will absorb.`[R]`
---@field items_to_place_this SimpleItemStack[] @Items that when placed will produce this tile. It is a dictionary indexed by the item prototype name. `nil` (instead of an empty table) if no items can place this tile.`[R]`
---@field layer uint @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field map_color Color @`[R]`
---@field mineable_properties LuaTilePrototype.mineable_properties @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field needs_correction boolean @If this tile needs correction logic applied when it's generated in the world..`[R]`
---@field next_direction LuaTilePrototype @The next direction of this tile or `nil` - used when a tile has multiple directions (such as hazard concrete)`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field vehicle_friction_modifier float @`[R]`
---@field walking_speed_modifier float @`[R]`
local LuaTilePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaTilePrototype.help() end


---@class LuaTilePrototype.mineable_properties
---@field minable boolean @Is this tile mineable at all?
---@field mining_particle? string @Prototype name of the particle produced when mining this tile. Will only be present if this tile produces any particle during mining.
---@field mining_time double @Energy required to mine a tile.
---@field products Product[] @Products obtained by mining this tile.

