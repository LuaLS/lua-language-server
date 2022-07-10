---@meta

---Called when a message is sent to the in-game console, either by a player or through the server interface.
---
---This event only fires for plain messages, not for any commands (including `/shout` or `/whisper`).
---@class on_console_chat
---@field message string @The chat message that was sent.
---@field name defines.events @Identifier of the event
---@field player_index? uint @The player doing the chatting, if any.
---@field tick uint @Tick the event was generated.
local on_console_chat = {}

