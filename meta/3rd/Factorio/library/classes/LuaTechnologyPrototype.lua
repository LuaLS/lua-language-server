---@meta

---A Technology prototype.
---@class LuaTechnologyPrototype
---@field effects TechnologyModifier[] @Effects applied when this technology is researched.`[R]`
---@field enabled boolean @If this technology prototype is enabled by default (enabled at the beginning of a game).`[R]`
---@field hidden boolean @If this technology prototype is hidden.`[R]`
---If this technology ignores the technology cost multiplier setting.`[R]`
---
---[LuaTechnologyPrototype::research_unit_count](LuaTechnologyPrototype::research_unit_count) will already take this setting into account.
---@field ignore_tech_cost_multiplier boolean
---@field level uint @The level of this research.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @Localised name of this technology.`[R]`
---@field max_level uint @The max level of this research.`[R]`
---@field name string @Name of this technology.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field prerequisites table<string, LuaTechnologyPrototype> @Prerequisites of this technology. The result maps technology name to the [LuaTechnologyPrototype](LuaTechnologyPrototype) object.`[R]`
---The number of research units required for this technology.`[R]`
---
---This is multiplied by the current research cost multiplier, unless [LuaTechnologyPrototype::ignore_tech_cost_multiplier](LuaTechnologyPrototype::ignore_tech_cost_multiplier) is `true`.
---@field research_unit_count uint
---@field research_unit_count_formula string @The count formula used for this infinite research or nil if this isn't an infinite research.`[R]`
---@field research_unit_energy double @Amount of energy required to finish a unit of research.`[R]`
---@field research_unit_ingredients Ingredient[] @The types of ingredients that labs will require to research this technology.`[R]`
---@field upgrade boolean @If the is technology prototype is an upgrade to some other technology.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field visible_when_disabled boolean @If this technology will be visible in the research GUI even though it is disabled.`[R]`
local LuaTechnologyPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaTechnologyPrototype.help() end

