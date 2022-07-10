---@meta

---Called after an entity is destroyed that has been registered with [LuaBootstrap::register_on_entity_destroyed](LuaBootstrap::register_on_entity_destroyed).
---
---Depending on when a given entity is destroyed, this event will be fired at the end of the current tick or at the end of the next tick.
---@class on_entity_destroyed
---@field name defines.events @Identifier of the event
---@field registration_number uint64 @The number returned by [register_on_entity_destroyed](LuaBootstrap::register_on_entity_destroyed) to uniquely identify this entity during this event.
---@field tick uint @Tick the event was generated.
---@field unit_number? uint @The [LuaEntity::unit_number](LuaEntity::unit_number) of the destroyed entity, if it had one.
local on_entity_destroyed = {}

