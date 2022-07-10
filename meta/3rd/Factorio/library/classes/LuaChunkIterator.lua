---@meta

---A chunk iterator can be used for iterating chunks coordinates of a surface.
---
---The returned type is a [ChunkPositionAndArea](ChunkPositionAndArea) containing the chunk coordinates and its area.
---
---```lua
---for chunk in some_surface.get_chunks() do
---  game.player.print("x: " .. chunk.x .. ", y: " .. chunk.y)
---  game.player.print("area: " .. serpent.line(chunk.area))
---end
---```
---@class LuaChunkIterator
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaChunkIterator = {}

---All methods and properties that this object supports.
---@return string
function LuaChunkIterator.help() end

