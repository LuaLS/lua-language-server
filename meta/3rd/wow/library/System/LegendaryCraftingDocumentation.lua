---@meta
C_LegendaryCrafting = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.CloseRuneforgeInteraction)
function C_LegendaryCrafting.CloseRuneforgeInteraction() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.CraftRuneforgeLegendary)
---@param description RuneforgeLegendaryCraftDescription
function C_LegendaryCrafting.CraftRuneforgeLegendary(description) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeItemPreviewInfo)
---@param baseItem ItemLocationMixin
---@param runeforgePowerID? number
---@param modifiers? number[]
---@return RuneforgeItemPreviewInfo? info
function C_LegendaryCrafting.GetRuneforgeItemPreviewInfo(baseItem, runeforgePowerID, modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeLegendaryComponentInfo)
---@param runeforgeLegendary ItemLocationMixin
---@return RuneforgeLegendaryComponentInfo componentInfo
function C_LegendaryCrafting.GetRuneforgeLegendaryComponentInfo(runeforgeLegendary) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeLegendaryCost)
---@param baseItem ItemLocationMixin
---@return CurrencyCost[] cost
function C_LegendaryCrafting.GetRuneforgeLegendaryCost(baseItem) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeLegendaryCraftSpellID)
---@return number spellID
function C_LegendaryCrafting.GetRuneforgeLegendaryCraftSpellID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeLegendaryCurrencies)
---@return number[] currencies
function C_LegendaryCrafting.GetRuneforgeLegendaryCurrencies() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeLegendaryUpgradeCost)
---@param runeforgeLegendary ItemLocationMixin
---@param upgradeItem ItemLocationMixin
---@return CurrencyCost[] cost
function C_LegendaryCrafting.GetRuneforgeLegendaryUpgradeCost(runeforgeLegendary, upgradeItem) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeModifierInfo)
---@param baseItem ItemLocationMixin
---@param powerID? number
---@param addedModifierIndex number
---@param modifiers number[]
---@return string name
---@return string description
function C_LegendaryCrafting.GetRuneforgeModifierInfo(baseItem, powerID, addedModifierIndex, modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgeModifiers)
---@return number[] modifiedReagentItemIDs
function C_LegendaryCrafting.GetRuneforgeModifiers() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgePowerInfo)
---@param runeforgePowerID number
---@return RuneforgePower power
function C_LegendaryCrafting.GetRuneforgePowerInfo(runeforgePowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgePowerSlots)
---@param runeforgePowerID number
---@return string[] slotNames
function C_LegendaryCrafting.GetRuneforgePowerSlots(runeforgePowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgePowers)
---@param baseItem? ItemLocationMixin
---@param filter? RuneforgePowerFilter
---@return number[] primaryRuneforgePowerIDs
---@return number[] otherRuneforgePowerIDs
function C_LegendaryCrafting.GetRuneforgePowers(baseItem, filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.GetRuneforgePowersByClassSpecAndCovenant)
---@param classID? number
---@param specID? number
---@param covenantID? number
---@param filter? RuneforgePowerFilter
---@return number[] runeforgePowerIDs
function C_LegendaryCrafting.GetRuneforgePowersByClassSpecAndCovenant(classID, specID, covenantID, filter) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.IsRuneforgeLegendary)
---@param item ItemLocationMixin
---@return boolean isRuneforgeLegendary
function C_LegendaryCrafting.IsRuneforgeLegendary(item) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.IsRuneforgeLegendaryMaxLevel)
---@param runeforgeLegendary ItemLocationMixin
---@return boolean isMaxLevel
function C_LegendaryCrafting.IsRuneforgeLegendaryMaxLevel(runeforgeLegendary) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.IsUpgradeItemValidForRuneforgeLegendary)
---@param runeforgeLegendary ItemLocationMixin
---@param upgradeItem ItemLocationMixin
---@return boolean isValid
function C_LegendaryCrafting.IsUpgradeItemValidForRuneforgeLegendary(runeforgeLegendary, upgradeItem) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.IsValidRuneforgeBaseItem)
---@param baseItem ItemLocationMixin
---@return boolean isValid
function C_LegendaryCrafting.IsValidRuneforgeBaseItem(baseItem) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.MakeRuneforgeCraftDescription)
---@param baseItem ItemLocationMixin
---@param runeforgePowerID number
---@param modifiers number[]
---@return RuneforgeLegendaryCraftDescription description
function C_LegendaryCrafting.MakeRuneforgeCraftDescription(baseItem, runeforgePowerID, modifiers) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LegendaryCrafting.UpgradeRuneforgeLegendary)
---@param runeforgeLegendary ItemLocationMixin
---@param upgradeItem ItemLocationMixin
function C_LegendaryCrafting.UpgradeRuneforgeLegendary(runeforgeLegendary, upgradeItem) end
