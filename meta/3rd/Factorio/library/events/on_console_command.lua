---@meta

---Called when someone enters a command-like message regardless of it being a valid command.
---@class on_console_command
---@field command string @The command as typed without the preceding forward slash ('/').
---@field name defines.events @Identifier of the event
---@field parameters string @The parameters provided if any.
---@field player_index? uint @The player if any.
---@field tick uint @Tick the event was generated.
local on_console_command = {}

