---@meta

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

