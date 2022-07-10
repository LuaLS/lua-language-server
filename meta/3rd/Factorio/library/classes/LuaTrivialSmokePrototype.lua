---@meta

---Prototype of a trivial smoke.
---@class LuaTrivialSmokePrototype
---@field affected_by_wind boolean @`[R]`
---@field color Color @`[R]`
---@field cyclic boolean @`[R]`
---@field duration uint @`[R]`
---@field end_scale double @`[R]`
---@field fade_away_duration uint @`[R]`
---@field fade_in_duration uint @`[R]`
---@field glow_animation boolean @`[R]`
---@field glow_fade_away_duration uint @`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field movement_slow_down_factor double @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field render_layer RenderLayer @`[R]`
---@field show_when_smoke_off boolean @`[R]`
---@field spread_duration uint @`[R]`
---@field start_scale double @`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaTrivialSmokePrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaTrivialSmokePrototype.help() end

