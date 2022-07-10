---@meta

---A custom tag that shows on the map view.
---@class LuaCustomChartTag
---@field force LuaForce @The force this tag belongs to.`[R]`
---@field icon SignalID @This tag's icon, if it has one. Writing `nil` removes it.`[RW]`
---@field last_user LuaPlayer @The player who last edited this tag.`[RW]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field position MapPosition @The position of this tag.`[R]`
---@field surface LuaSurface @The surface this tag belongs to.`[R]`
---@field tag_number uint @The unique ID for this tag on this force.`[R]`
---@field text string @`[RW]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaCustomChartTag = {}

---Destroys this tag.
function LuaCustomChartTag.destroy() end

---All methods and properties that this object supports.
---@return string
function LuaCustomChartTag.help() end

