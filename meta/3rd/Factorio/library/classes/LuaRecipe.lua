---@meta

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

