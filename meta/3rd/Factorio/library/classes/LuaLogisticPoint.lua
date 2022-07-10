---@meta

---Logistic point of a particular [LuaEntity](LuaEntity). A "Logistic point" is the name given for settings and properties used by requester, provider, and storage points in a given logistic network. These "points" don't have to be a logistic container but often are. One other entity that can own several points is the "character" character type entity.
---@class LuaLogisticPoint
---@field exact boolean @If this logistic point is using the exact mode. In exact mode robots never over-deliver requests.`[R]`
---The logistic filters for this logistic point or `nil` if this doesn't use logistic filters.`[R]`
---
---The returned array will always have an entry for each filter and will be indexed in sequence when not nil.
---@field filters LogisticFilter[]
---The force of this logistic point.`[R]`
---
---This will always be the same as the [LuaLogisticPoint::owner](LuaLogisticPoint::owner) force.
---@field force LuaForce
---@field logistic_member_index uint @The Logistic member index of this logistic point.`[R]`
---@field logistic_network LuaLogisticNetwork @`[R]`
---@field mode defines.logistic_mode @The logistic mode.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity @The [LuaEntity](LuaEntity) owner of this [LuaLogisticPoint](LuaLogisticPoint).`[R]`
---@field targeted_items_deliver table<string, uint> @Items targeted to be dropped off into this logistic point by robots. The attribute is a dictionary mapping the item prototype names to their item counts.`[R]`
---@field targeted_items_pickup table<string, uint> @Items targeted to be picked up from this logistic point by robots. The attribute is a dictionary mapping the item prototype names to their item counts.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLogisticPoint = {}

---All methods and properties that this object supports.
---@return string
function LuaLogisticPoint.help() end

