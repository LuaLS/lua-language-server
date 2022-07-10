---@meta

---Called just after a script inventory is resized.
---@class on_script_inventory_resized
---@field inventory LuaInventory
---@field mod string @The mod that did the resizing. This will be `"core"` if done by console command or scenario script.
---@field name defines.events @Identifier of the event
---@field new_size uint @The new inventory size.
---@field old_size uint @The old inventory size.
---@field overflow_inventory LuaInventory @Any items which didn't fit into the new inventory size.
---@field player_index? uint @If done by console command; the player who ran the command.
---@field tick uint @Tick the event was generated.
local on_script_inventory_resized = {}

