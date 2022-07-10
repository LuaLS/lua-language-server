---@meta

---Called after an entity has been renamed either by the player or through script.
---@class on_entity_renamed
---@field by_script boolean
---@field entity LuaEntity
---@field name defines.events @Identifier of the event
---@field old_name string
---@field player_index? uint @If by_script is true this will not be included.
---@field tick uint @Tick the event was generated.
local on_entity_renamed = {}

