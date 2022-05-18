---@meta
C_SpellBook = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SpellBook.ContainsAnyDisenchantSpell)
---@return boolean contains
function C_SpellBook.ContainsAnyDisenchantSpell() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SpellBook.GetCurrentLevelSpells)
---@param level number
---@return number[] spellIDs
function C_SpellBook.GetCurrentLevelSpells(level) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SpellBook.GetSkillLineIndexByID)
---@param skillLineID number
---@return number? skillIndex
function C_SpellBook.GetSkillLineIndexByID(skillLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SpellBook.GetSpellInfo)
---@param spellID number
---@return SpellInfo spellInfo
function C_SpellBook.GetSpellInfo(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SpellBook.GetSpellLinkFromSpellID)
---@param spellID number
---@return string spellLink
function C_SpellBook.GetSpellLinkFromSpellID(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SpellBook.IsSpellDisabled)
---@param spellID number
---@return boolean disabled
function C_SpellBook.IsSpellDisabled(spellID) end

---@class SpellInfo
---@field name string
---@field iconID number
---@field castTime number
---@field minRange number
---@field maxRange number
---@field spellID number
