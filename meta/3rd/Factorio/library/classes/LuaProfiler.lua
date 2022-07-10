---@meta

---An object used to measure script performance.
---
---Since performance is non-deterministic, these objects don't allow reading the raw time values from Lua. They can be used anywhere a [LocalisedString](LocalisedString) is used, except for [LuaGuiElement::add](LuaGuiElement::add)'s LocalisedString arguments, [LuaSurface::create_entity](LuaSurface::create_entity)'s `text` argument, and [LuaEntity::add_market_item](LuaEntity::add_market_item).
---@class LuaProfiler
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaProfiler = {}

---Add the duration of another timer to this timer. Useful to reduce start/stop overhead when accumulating time onto many timers at once.
---
---If other is running, the time to now will be added.
---@param _other LuaProfiler @The timer to add to this timer.
function LuaProfiler.add(_other) end

---Divides the current duration by a set value. Useful for calculating the average of many iterations.
---
---Does nothing if this isn't stopped.
---@param _number double @The number to divide by. Must be > 0.
function LuaProfiler.divide(_number) end

---All methods and properties that this object supports.
---@return string
function LuaProfiler.help() end

---Resets the clock, also restarting it.
function LuaProfiler.reset() end

---Start the clock again, without resetting it.
function LuaProfiler.restart() end

---Stops the clock.
function LuaProfiler.stop() end

