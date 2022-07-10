---@meta

---Called when the map difficulty settings are changed.
---
---It's not guaranteed that both settings are changed - just that at least one has been changed.
---@class on_difficulty_settings_changed
---@field name defines.events @Identifier of the event
---@field old_recipe_difficulty uint
---@field old_technology_difficulty uint
---@field tick uint @Tick the event was generated.
local on_difficulty_settings_changed = {}

