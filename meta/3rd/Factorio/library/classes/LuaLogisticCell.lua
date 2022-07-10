---@meta

---Logistic cell of a particular [LuaEntity](LuaEntity). A "Logistic Cell" is the given name for settings and properties used by what would normally be seen as a "Roboport". A logistic cell however doesn't have to be attached to the roboport entity (the character has one for the personal roboport).
---@class LuaLogisticCell
---@field charge_approach_distance float @Radius at which the robots hover when waiting to be charged.`[R]`
---@field charging_robot_count uint @Number of robots currently charging.`[R]`
---@field charging_robots LuaEntity[] @Robots currently being charged.`[R]`
---@field construction_radius float @Construction radius of this cell.`[R]`
---@field logistic_network LuaLogisticNetwork @The network that owns this cell or `nil`.`[R]`
---@field logistic_radius float @Logistic radius of this cell.`[R]`
---@field logistics_connection_distance float @Logistic connection distance of this cell.`[R]`
---@field mobile boolean @`true` if this is a mobile cell. In vanilla, only the logistic cell created by a character's personal roboport is mobile.`[R]`
---@field neighbours LuaLogisticCell[] @Neighbouring cells.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field owner LuaEntity @This cell's owner.`[R]`
---@field stationed_construction_robot_count uint @Number of stationed construction robots in this cell.`[R]`
---@field stationed_logistic_robot_count uint @Number of stationed logistic robots in this cell.`[R]`
---@field to_charge_robot_count uint @Number of robots waiting to charge.`[R]`
---@field to_charge_robots LuaEntity[] @Robots waiting to charge.`[R]`
---@field transmitting boolean @`true` if this cell is active.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaLogisticCell = {}

---All methods and properties that this object supports.
---@return string
function LuaLogisticCell.help() end

---Is a given position within the construction range of this cell?
---@param _position MapPosition
---@return boolean
function LuaLogisticCell.is_in_construction_range(_position) end

---Is a given position within the logistic range of this cell?
---@param _position MapPosition
---@return boolean
function LuaLogisticCell.is_in_logistic_range(_position) end

---Are two cells neighbours?
---@param _other LuaLogisticCell
---@return boolean
function LuaLogisticCell.is_neighbour_with(_other) end

