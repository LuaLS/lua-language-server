---@meta

---Called when a translation request generated through [LuaPlayer::request_translation](LuaPlayer::request_translation) is translated.
---@class on_string_translated
---@field localised_string LocalisedString @The localised string being translated.
---@field name defines.events @Identifier of the event
---@field player_index uint @The player whose locale was used for the translation.
---@field result string @The translated `localised_string`.
---@field tick uint @Tick the event was generated.
---@field translated boolean @Whether the requested localised string was valid and could be translated.
local on_string_translated = {}

