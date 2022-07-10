---@meta

---Lazily evaluated table. For performance reasons, we sometimes return a custom table-like type instead of a native Lua table. This custom type lazily constructs the necessary Lua wrappers of the corresponding C++ objects, therefore preventing their unnecessary construction in some cases.
---
---There are some notable consequences to the usage of a custom table type rather than the native Lua table type: Iterating a custom table is only possible using the `pairs` Lua function; `ipairs` won't work. Another key difference is that custom tables cannot be serialised into a game save file -- if saving the game would require serialisation of a custom table, an error will be displayed and the game will not be saved.
---
---In previous versions of Factorio, this would create a [LuaPlayer](LuaPlayer) instance for every player in the game, even though only one such wrapper is needed. In the current version, accessing [game.players](LuaGameScript::players) by itself does not create any [LuaPlayer](LuaPlayer) instances; they are created lazily when accessed. Therefore, this example only constructs one [LuaPlayer](LuaPlayer) instance, no matter how many elements there are in `game.players`. 
---```lua
---game.players["Oxyd"].character.die()
---```
---\
---Custom tables may be iterated using `pairs`. 
---```lua
---for _, p in pairs(game.players) do game.player.print(p.name); end
---```
---\
---The following will produce no output because `ipairs` is not supported with custom tables. 
---```lua
---for _, p in ipairs(game.players) do game.player.print(p.name); end  -- incorrect; use pairs instead
---```
---\
---This statement will execute successfully and `global.p` will be useable as one might expect. However, as soon as the user tries to save the game, a "LuaCustomTable cannot be serialized" error will be shown. The game will remain unsaveable so long as `global.p` refers to an instance of a custom table. 
---```lua
---global.p = game.players  -- This has high potential to make the game unsaveable
---```
---@class LuaCustomTable
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
---@field [number] Any @Access an element of this custom table.`[RW]`
local LuaCustomTable = {}

---All methods and properties that this object supports.
---@return string
function LuaCustomTable.help() end

