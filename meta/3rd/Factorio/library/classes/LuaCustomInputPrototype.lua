---@meta

---Prototype of a custom input.
---@class LuaCustomInputPrototype
---@field action string @The action that happens when this custom input is triggered.`[R]`
---@field alternative_key_sequence string @The default alternative key sequence for this custom input. `nil` when not defined.`[R]`
---@field consuming string @The consuming type: `"none"` or `"game-only"`.`[R]`
---@field enabled boolean @Whether this custom input is enabled. Disabled custom inputs exist but are not used by the game.`[R]`
---@field enabled_while_in_cutscene boolean @Whether this custom input is enabled while using the cutscene controller.`[R]`
---@field enabled_while_spectating boolean @Whether this custom input is enabled while using the spectator controller.`[R]`
---@field include_selected_prototype boolean @Whether this custom input will include the selected prototype (if any) when triggered.`[R]`
---@field item_to_spawn LuaItemPrototype @The item that gets spawned when this custom input is fired or `nil`.`[R]`
---@field key_sequence string @The default key sequence for this custom input.`[R]`
---@field linked_game_control string @The linked game control name or `nil`.`[R]`
---@field localised_description LocalisedString @`[R]`
---@field localised_name LocalisedString @`[R]`
---@field name string @Name of this prototype.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field order string @The string used to alphabetically sort these prototypes. It is a simple string that has no additional semantic meaning.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaCustomInputPrototype = {}

---All methods and properties that this object supports.
---@return string
function LuaCustomInputPrototype.help() end

