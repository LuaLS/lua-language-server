---@meta

---A single "square" on the map.
---@class LuaTile
---@field hidden_tile string @The name of the [LuaTilePrototype](LuaTilePrototype) hidden under this tile or `nil` if there is no hidden tile. During normal gameplay, only [non-mineable](LuaTilePrototype::mineable_properties) tiles can become hidden. This can however be circumvented with [LuaSurface::set_hidden_tile](LuaSurface::set_hidden_tile).`[R]`
---@field name string @Prototype name of this tile. E.g. `"sand-3"` or `"grass-2"`.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field position TilePosition @The position this tile references.`[R]`
---@field prototype LuaTilePrototype @`[R]`
---@field surface LuaSurface @The surface this tile is on.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaTile = {}

---Cancels deconstruction if it is scheduled, does nothing otherwise.
---@param _force ForceIdentification @The force who did the deconstruction order.
---@param _player? PlayerIdentification @The player to set the last_user to if any.
function LuaTile.cancel_deconstruction(_force, _player) end

---What type of things can collide with this tile?
---
---Check if the character would collide with a tile 
---```lua
---game.player.print(tostring(game.player.surface.get_tile(1, 1).collides_with("player-layer")))
---```
---@param _layer CollisionMaskLayer
---@return boolean
function LuaTile.collides_with(_layer) end

---Gets all tile ghosts on this tile.
---@param _force? ForceIdentification @Get tile ghosts of this force.
---@return LuaTile[]
function LuaTile.get_tile_ghosts(_force) end

---Does this tile have any tile ghosts on it.
---@param _force? ForceIdentification @Check for tile ghosts of this force.
---@return boolean
function LuaTile.has_tile_ghost(_force) end

---All methods and properties that this object supports.
---@return string
function LuaTile.help() end

---Orders deconstruction of this tile by the given force.
---@param _force ForceIdentification @The force whose robots are supposed to do the deconstruction.
---@param _player? PlayerIdentification @The player to set the last_user to if any.
---@return LuaEntity @The deconstructible tile proxy created, if any.
function LuaTile.order_deconstruction(_force, _player) end

---Is this tile marked for deconstruction?
---@param _force? ForceIdentification @The force who did the deconstruction order.
---@return boolean
function LuaTile.to_be_deconstructed(_force) end

