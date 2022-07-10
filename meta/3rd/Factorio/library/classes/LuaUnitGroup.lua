---@meta

---A collection of units moving and attacking together. The engine creates autonomous unit groups to attack polluted areas. The script can create and control such groups as well. Groups can accept commands in the same manner as regular units.
---@class LuaUnitGroup
---@field command Command @The command given to this group or `nil` is the group has no command.`[R]`
---@field distraction_command Command @The distraction command given to this group or `nil` is the group currently isn't distracted.`[R]`
---@field force LuaForce @The force of this unit group.`[R]`
---@field group_number uint @The group number for this unit group.`[R]`
---@field is_script_driven boolean @Whether this unit group is controlled by a script or by the game engine. This can be changed using [LuaUnitGroup::set_autonomous](LuaUnitGroup::set_autonomous).`[R]`
---@field members LuaEntity[] @Members of this group.`[R]`
---@field object_name string @The class name of this object. Available even when `valid` is false. For LuaStruct objects it may also be suffixed with a dotted path to a member of the struct.`[R]`
---@field position MapPosition @Group position. This can have different meanings depending on the group state. When the group is gathering, the position is the place of gathering. When the group is moving, the position is the expected position of its members along the path. When the group is attacking, it is the average position of its members.`[R]`
---@field state defines.group_state @Whether this group is gathering, moving or attacking.`[R]`
---@field surface LuaSurface @The surface of this unit group.`[R]`
---@field valid boolean @Is this object valid? This Lua object holds a reference to an object within the game engine. It is possible that the game-engine object is removed whilst a mod still holds the corresponding Lua object. If that happens, the object becomes invalid, i.e. this attribute will be `false`. Mods are advised to check for object validity if any change to the game state might have occurred between the creation of the Lua object and its access.`[R]`
local LuaUnitGroup = {}

---Make a unit a member of this group. Has the same effect as giving a `group_command` with this group to the unit.
---
---The member must have the same force as the unit group.
---@param _unit LuaEntity
function LuaUnitGroup.add_member(_unit) end

---Dissolve this group. Its members won't be destroyed, they will be merely unlinked from this group.
function LuaUnitGroup.destroy() end

---All methods and properties that this object supports.
---@return string
function LuaUnitGroup.help() end

---Make this group autonomous. Autonomous groups will automatically attack polluted areas. Autonomous groups aren't considered to be [script-driven](LuaUnitGroup::is_script_driven).
function LuaUnitGroup.set_autonomous() end

---Give this group a command.
---@param _command Command
function LuaUnitGroup.set_command(_command) end

---Give this group a distraction command.
---@param _command Command
function LuaUnitGroup.set_distraction_command(_command) end

---Make the group start moving even if some of its members haven't yet arrived.
function LuaUnitGroup.start_moving() end

