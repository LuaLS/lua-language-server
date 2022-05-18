---@meta
C_Spell = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Spell.DoesSpellExist)
---@param spellID number
---@return boolean spellExists
function C_Spell.DoesSpellExist(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Spell.GetMawPowerBorderAtlasBySpellID)
---@param spellID number
---@return string rarityBorderAtlas
function C_Spell.GetMawPowerBorderAtlasBySpellID(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Spell.IsSpellDataCached)
---@param spellID number
---@return boolean isCached
function C_Spell.IsSpellDataCached(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Spell.RequestLoadSpellData)
---@param spellID number
function C_Spell.RequestLoadSpellData(spellID) end
