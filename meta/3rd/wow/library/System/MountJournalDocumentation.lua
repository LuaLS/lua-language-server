---@meta
C_MountJournal = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.ApplyMountEquipment)
---@param itemLocation ItemLocationMixin
---@return boolean canContinue
function C_MountJournal.ApplyMountEquipment(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.AreMountEquipmentEffectsSuppressed)
---@return boolean areEffectsSuppressed
function C_MountJournal.AreMountEquipmentEffectsSuppressed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.ClearFanfare)
---@param mountID number
function C_MountJournal.ClearFanfare(mountID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.ClearRecentFanfares)
function C_MountJournal.ClearRecentFanfares() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.Dismiss)
function C_MountJournal.Dismiss() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetAppliedMountEquipmentID)
---@return number? itemID
function C_MountJournal.GetAppliedMountEquipmentID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetCollectedFilterSetting)
---@param filterIndex number
---@return boolean isChecked
function C_MountJournal.GetCollectedFilterSetting(filterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetDisplayedMountAllCreatureDisplayInfo)
---@param mountIndex number
---@return MountCreatureDisplayInfo[] allDisplayInfo
function C_MountJournal.GetDisplayedMountAllCreatureDisplayInfo(mountIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetDisplayedMountInfo)
---@param displayIndex number
---@return string name
---@return number spellID
---@return number icon
---@return boolean isActive
---@return boolean isUsable
---@return number sourceType
---@return boolean isFavorite
---@return boolean isFactionSpecific
---@return number? faction
---@return boolean shouldHideOnChar
---@return boolean isCollected
---@return number mountID
function C_MountJournal.GetDisplayedMountInfo(displayIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetDisplayedMountInfoExtra)
---@param mountIndex number
---@return number? creatureDisplayInfoID
---@return string description
---@return string source
---@return boolean isSelfMount
---@return number mountTypeID
---@return number uiModelSceneID
---@return number animID
---@return number spellVisualKitID
---@return boolean disablePlayerMountPreview
function C_MountJournal.GetDisplayedMountInfoExtra(mountIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetIsFavorite)
---@param mountIndex number
---@return boolean isFavorite
---@return boolean canSetFavorite
function C_MountJournal.GetIsFavorite(mountIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountAllCreatureDisplayInfoByID)
---@param mountID number
---@return MountCreatureDisplayInfo[] allDisplayInfo
function C_MountJournal.GetMountAllCreatureDisplayInfoByID(mountID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountEquipmentUnlockLevel)
---@return number level
function C_MountJournal.GetMountEquipmentUnlockLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountFromItem)
---@param itemID number
---@return number? mountID
function C_MountJournal.GetMountFromItem(itemID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountFromSpell)
---@param spellID number
---@return number? mountID
function C_MountJournal.GetMountFromSpell(spellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountIDs)
---@return number[] mountIDs
function C_MountJournal.GetMountIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountInfoByID)
---@param mountID number
---@return string name
---@return number spellID
---@return number icon
---@return boolean isActive
---@return boolean isUsable
---@return number sourceType
---@return boolean isFavorite
---@return boolean isFactionSpecific
---@return number? faction
---@return boolean shouldHideOnChar
---@return boolean isCollected
---@return number mountID
function C_MountJournal.GetMountInfoByID(mountID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountInfoExtraByID)
---@param mountID number
---@return number? creatureDisplayInfoID
---@return string description
---@return string source
---@return boolean isSelfMount
---@return number mountTypeID
---@return number uiModelSceneID
---@return number animID
---@return number spellVisualKitID
---@return boolean disablePlayerMountPreview
function C_MountJournal.GetMountInfoExtraByID(mountID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetMountUsabilityByID)
---@param mountID number
---@param checkIndoors boolean
---@return boolean isUsable
---@return string? useError
function C_MountJournal.GetMountUsabilityByID(mountID, checkIndoors) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetNumDisplayedMounts)
---@return number numMounts
function C_MountJournal.GetNumDisplayedMounts() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetNumMounts)
---@return number numMounts
function C_MountJournal.GetNumMounts() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.GetNumMountsNeedingFanfare)
---@return number numMountsNeedingFanfare
function C_MountJournal.GetNumMountsNeedingFanfare() end

---Determines if the item is mount equipment based on its class and subclass.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.IsItemMountEquipment)
---@param itemLocation ItemLocationMixin
---@return boolean isMountEquipment
function C_MountJournal.IsItemMountEquipment(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.IsMountEquipmentApplied)
---@return boolean isApplied
function C_MountJournal.IsMountEquipmentApplied() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.IsSourceChecked)
---@param filterIndex number
---@return boolean isChecked
function C_MountJournal.IsSourceChecked(filterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.IsTypeChecked)
---@param filterIndex number
---@return boolean isChecked
function C_MountJournal.IsTypeChecked(filterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.IsValidSourceFilter)
---@param filterIndex number
---@return boolean isValid
function C_MountJournal.IsValidSourceFilter(filterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.IsValidTypeFilter)
---@param filterIndex number
---@return boolean isValid
function C_MountJournal.IsValidTypeFilter(filterIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.NeedsFanfare)
---@param mountID number
---@return boolean needsFanfare
function C_MountJournal.NeedsFanfare(mountID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.Pickup)
---@param displayIndex number
function C_MountJournal.Pickup(displayIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetAllSourceFilters)
---@param isChecked boolean
function C_MountJournal.SetAllSourceFilters(isChecked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetAllTypeFilters)
---@param isChecked boolean
function C_MountJournal.SetAllTypeFilters(isChecked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetCollectedFilterSetting)
---@param filterIndex number
---@param isChecked boolean
function C_MountJournal.SetCollectedFilterSetting(filterIndex, isChecked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetIsFavorite)
---@param mountIndex number
---@param isFavorite boolean
function C_MountJournal.SetIsFavorite(mountIndex, isFavorite) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetSearch)
---@param searchValue string
function C_MountJournal.SetSearch(searchValue) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetSourceFilter)
---@param filterIndex number
---@param isChecked boolean
function C_MountJournal.SetSourceFilter(filterIndex, isChecked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SetTypeFilter)
---@param filterIndex number
---@param isChecked boolean
function C_MountJournal.SetTypeFilter(filterIndex, isChecked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MountJournal.SummonByID)
---@param mountID number
function C_MountJournal.SummonByID(mountID) end

---@class MountCreatureDisplayInfo
---@field creatureDisplayID number
---@field isVisible boolean
