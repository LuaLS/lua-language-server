---@meta

---Called when players uses an item to build something. Called before [on_built_entity](on_built_entity).
---@class on_pre_build
---@field created_by_moving boolean @Item was placed while moving.
---@field direction defines.direction @The direction the item was facing when placed.
---@field flip_horizontal boolean @If building this blueprint was flipped horizontally.
---@field flip_vertical boolean @If building this blueprint was flipped vertically.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player who did the placing.
---@field position MapPosition @Where the item was placed.
---@field shift_build boolean @Item was placed using shift building.
---@field tick uint @Tick the event was generated.
local on_pre_build = {}

