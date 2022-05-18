---@meta
C_AzeriteEssence = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.ActivateEssence)
---@param essenceID number
---@param milestoneID number
function C_AzeriteEssence.ActivateEssence(essenceID, milestoneID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.CanActivateEssence)
---@param essenceID number
---@param milestoneID number
---@return boolean canActivate
function C_AzeriteEssence.CanActivateEssence(essenceID, milestoneID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.CanDeactivateEssence)
---@param milestoneID number
---@return boolean canDeactivate
function C_AzeriteEssence.CanDeactivateEssence(milestoneID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.CanOpenUI)
---@return boolean canOpen
function C_AzeriteEssence.CanOpenUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.ClearPendingActivationEssence)
function C_AzeriteEssence.ClearPendingActivationEssence() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.CloseForge)
function C_AzeriteEssence.CloseForge() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetEssenceHyperlink)
---@param essenceID number
---@param rank number
---@return string link
function C_AzeriteEssence.GetEssenceHyperlink(essenceID, rank) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetEssenceInfo)
---@param essenceID number
---@return AzeriteEssenceInfo info
function C_AzeriteEssence.GetEssenceInfo(essenceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetEssences)
---@return AzeriteEssenceInfo[] essences
function C_AzeriteEssence.GetEssences() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetMilestoneEssence)
---@param milestoneID number
---@return number essenceID
function C_AzeriteEssence.GetMilestoneEssence(milestoneID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetMilestoneInfo)
---@param milestoneID number
---@return AzeriteMilestoneInfo info
function C_AzeriteEssence.GetMilestoneInfo(milestoneID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetMilestoneSpell)
---@param milestoneID number
---@return number spellID
function C_AzeriteEssence.GetMilestoneSpell(milestoneID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetMilestones)
---@return AzeriteMilestoneInfo[] milestones
function C_AzeriteEssence.GetMilestones() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetNumUnlockedEssences)
---@return number numUnlockedEssences
function C_AzeriteEssence.GetNumUnlockedEssences() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetNumUsableEssences)
---@return number numUsableEssences
function C_AzeriteEssence.GetNumUsableEssences() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.GetPendingActivationEssence)
---@return number essenceID
function C_AzeriteEssence.GetPendingActivationEssence() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.HasNeverActivatedAnyEssences)
---@return boolean hasNeverActivatedAnyEssences
function C_AzeriteEssence.HasNeverActivatedAnyEssences() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.HasPendingActivationEssence)
---@return boolean hasEssence
function C_AzeriteEssence.HasPendingActivationEssence() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.IsAtForge)
---@return boolean isAtForge
function C_AzeriteEssence.IsAtForge() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.SetPendingActivationEssence)
---@param essenceID number
function C_AzeriteEssence.SetPendingActivationEssence(essenceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEssence.UnlockMilestone)
---@param milestoneID number
function C_AzeriteEssence.UnlockMilestone(milestoneID) end

---@class AzeriteEssenceInfo
---@field ID number
---@field name string
---@field rank number
---@field unlocked boolean
---@field valid boolean
---@field icon number

---@class AzeriteMilestoneInfo
---@field ID number
---@field requiredLevel number
---@field canUnlock boolean
---@field unlocked boolean
---@field rank number|nil
---@field slot AzeriteEssenceSlot|nil
