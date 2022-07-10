---@meta

---The control behavior for an entity. Inserters have logistic network and circuit network behavior logic, lamps have circuit logic and so on. This is an abstract base class that concrete control behaviors inherit.
---
---An control reference becomes invalid once the control behavior is removed or the entity (see [LuaEntity](LuaEntity)) it resides in is destroyed.
---@class LuaControlBehavior
---@field entity LuaEntity @The entity this control behavior belongs to.`[R]`
---@field type defines.control_behavior.type @The concrete type of this control behavior.`[R]`
local LuaControlBehavior = {}

---@param _wire defines.wire_type @Wire color of the network connected to this entity.
---@param _circuit_connector? defines.circuit_connector_id @The connector to get circuit network for. Must be specified for entities with more than one circuit network connector.
---@return LuaCircuitNetwork @The circuit network or nil.
function LuaControlBehavior.get_circuit_network(_wire, _circuit_connector) end

