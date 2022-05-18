---@meta
---@class AceLocale-3.0
local AceLocale = {}

---@param application string Unique name of addon / module
---@param silent? boolean If true, the locale is optional, silently return nil if it's not found (defaults to false, optional)
---@return table -- The locale table for the current language.
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0#title-1)
function AceLocale:GetLocale(application, silent) end

---@paramsig application, locale[, isDefault[, silent]]
---@param application string Unique name of addon / module
---@param locale GAME_LOCALE Name of the locale to register, e.g. "enUS", "deDE", etc.
---@param isDefault? boolean If this is the default locale being registered. Your addon is written in this language, generally enUS, set this to true (defaults to false)
---@param silent? boolean If true, the locale will not issue warnings for missing keys. Must be `true` on the first locale registered. If set to "raw", nils will be returned for unknown keys (no metatable used).
---@return table -- Locale Table to add localizations to, or nil if the current locale is not required.
--- ---
---[Documentation](https://www.wowace.com/projects/ace3/pages/api/ace-locale-3-0#title-2)
function AceLocale:NewLocale(application, locale, isDefault, silent) end


---@alias GAME_LOCALE
---| "frFR" French (France)
---| "deDE": German (Germany)
---| "enGB": English (Great Britain) if returned, can substitute 'enUS' for consistancy
---| "enUS": English (America)
---| "itIT": Italian (Italy)
---| "koKR": Korean (Korea) RTL - right-to-left
---| "zhCN": Chinese (China) (simplified) implemented LTR left-to-right in WoW
---| "zhTW": Chinese (Taiwan) (traditional) implemented LTR left-to-right in WoW
---| "ruRU": Russian (Russia)
---| "esES": Spanish (Spain)
---| "esMX": Spanish (Mexico)
---| "ptBR": Portuguese (Brazil)