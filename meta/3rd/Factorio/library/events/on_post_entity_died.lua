---@meta

---Called after an entity dies. Can be filtered using [LuaPostEntityDiedEventFilter](LuaPostEntityDiedEventFilter).
---@class on_post_entity_died
---@field corpses LuaEntity[] @The corpses created by the entity dying if any.
---@field damage_type? LuaDamagePrototype @The damage type if any.
---@field force? LuaForce @The force that did the killing if any.
---@field ghost? LuaEntity @The ghost created by the entity dying if any.
---@field name defines.events @Identifier of the event
---@field position MapPosition @Position where the entity died.
---@field prototype LuaEntityPrototype @The entity prototype of the entity that died.
---@field surface_index uint @The surface the entity was on.
---@field tick uint @Tick the event was generated.
---@field unit_number? uint @The unit number the entity had if any.
local on_post_entity_died = {}

