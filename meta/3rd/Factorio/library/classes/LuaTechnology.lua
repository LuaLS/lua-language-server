---@meta

---One research item.
---@class LuaTechnology
---@field effects TechnologyModifier[] @Effects applied when this technology is researched.`[R]`
---@field enabled boolean @Can this technology be researched?`[RW]`
---@field force LuaForce @The force this technology belongs to.`[R]`
---@field level uint @The current level of this technology. For level-based technology writing to this is the same as researching the technology to the previous level. Writing the level will set [LuaTechnology::enabled](LuaTechnology::enabled) to `true`.`[RW]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @Localised name of this technology.`[R]`
---@field name string @Name of this technology.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field prerequisites table<string, LuaTechnology> @Prerequisites of this technology. The result maps technology name to the [LuaTechnology](LuaTechnology) object.`[R]`
---@field prototype LuaTechnologyPrototype @The prototype of this technology.`[R]`
---The number of research units required for this technology.`[R]`
---
---This is multiplied by the current research cost multiplier, unless [LuaTechnologyPrototype::ignore_tech_cost_multiplier](LuaTechnologyPrototype::ignore_tech_cost_multiplier) is `true`.
---@field research_unit_count uint
---@field research_unit_count_formula string @The count formula used for this infinite research or nil if this isn't an infinite research.`[R]`
---@field research_unit_energy double @Amount of energy required to finish a unit of research.`[R]`
---@field research_unit_ingredients Ingredient[] @The types of ingredients that labs will require to research this technology.`[R]`
---@field researched boolean @Has this technology been researched? Switching from `false` to `true` will trigger the technology advancement perks; switching from `true` to `false` will reverse them.`[RW]`
---@field upgrade boolean @Is this an upgrade-type research?`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field visible_when_disabled boolean @If this technology will be visible in the research GUI even though it is disabled.`[RW]`
local LuaTechnology = {}

---All methods and properties that this object supports.
---@return string
function LuaTechnology.help() end

---Reload this technology from its prototype.
function LuaTechnology.reload() end

