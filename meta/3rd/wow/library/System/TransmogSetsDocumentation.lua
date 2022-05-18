---@meta
C_TransmogSets = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.ClearLatestSource)
function C_TransmogSets.ClearLatestSource() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.ClearNewSource)
---@param sourceID number
function C_TransmogSets.ClearNewSource(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.ClearSetNewSourcesForSlot)
---@param transmogSetID number
---@param slot number
function C_TransmogSets.ClearSetNewSourcesForSlot(transmogSetID, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetAllSets)
---@return TransmogSetInfo[] sets
function C_TransmogSets.GetAllSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetAllSourceIDs)
---@param transmogSetID number
---@return number[] sources
function C_TransmogSets.GetAllSourceIDs(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetBaseSetID)
---@param transmogSetID number
---@return number baseTransmogSetID
function C_TransmogSets.GetBaseSetID(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetBaseSets)
---@return TransmogSetInfo[] sets
function C_TransmogSets.GetBaseSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetBaseSetsCounts)
---@return number numCollected
---@return number numTotal
function C_TransmogSets.GetBaseSetsCounts() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetBaseSetsFilter)
---@param index number
---@return boolean isChecked
function C_TransmogSets.GetBaseSetsFilter(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetCameraIDs)
---@return number? detailsCameraID
---@return number? vendorCameraID
function C_TransmogSets.GetCameraIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetIsFavorite)
---@param transmogSetID number
---@return boolean isFavorite
---@return boolean isGroupFavorite
function C_TransmogSets.GetIsFavorite(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetLatestSource)
---@return number sourceID
function C_TransmogSets.GetLatestSource() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetSetInfo)
---@param transmogSetID number
---@return TransmogSetInfo set
function C_TransmogSets.GetSetInfo(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetSetNewSources)
---@param transmogSetID number
---@return number[] sourceIDs
function C_TransmogSets.GetSetNewSources(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetSetPrimaryAppearances)
---@param transmogSetID number
---@return TransmogSetPrimaryAppearanceInfo[] apppearances
function C_TransmogSets.GetSetPrimaryAppearances(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetSetsContainingSourceID)
---@param sourceID number
---@return number[] setIDs
function C_TransmogSets.GetSetsContainingSourceID(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetSourceIDsForSlot)
---@param transmogSetID number
---@param slot number
---@return number[] sources
function C_TransmogSets.GetSourceIDsForSlot(transmogSetID, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetSourcesForSlot)
---@param transmogSetID number
---@param slot number
---@return AppearanceSourceInfo[] sources
function C_TransmogSets.GetSourcesForSlot(transmogSetID, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetUsableSets)
---@return TransmogSetInfo[] sets
function C_TransmogSets.GetUsableSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.GetVariantSets)
---@param transmogSetID number
---@return TransmogSetInfo[] sets
function C_TransmogSets.GetVariantSets(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.HasUsableSets)
---@return boolean hasUsableSets
function C_TransmogSets.HasUsableSets() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.IsBaseSetCollected)
---@param transmogSetID number
---@return boolean isCollected
function C_TransmogSets.IsBaseSetCollected(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.IsNewSource)
---@param sourceID number
---@return boolean isNew
function C_TransmogSets.IsNewSource(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.IsSetVisible)
---@param transmogSetID number
---@return boolean isVisible
function C_TransmogSets.IsSetVisible(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.SetBaseSetsFilter)
---@param index number
---@param isChecked boolean
function C_TransmogSets.SetBaseSetsFilter(index, isChecked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.SetHasNewSources)
---@param transmogSetID number
---@return boolean hasNewSources
function C_TransmogSets.SetHasNewSources(transmogSetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.SetHasNewSourcesForSlot)
---@param transmogSetID number
---@param slot number
---@return boolean hasNewSources
function C_TransmogSets.SetHasNewSourcesForSlot(transmogSetID, slot) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogSets.SetIsFavorite)
---@param transmogSetID number
---@param isFavorite boolean
function C_TransmogSets.SetIsFavorite(transmogSetID, isFavorite) end

---@class TransmogSetInfo
---@field setID number
---@field name string
---@field baseSetID number|nil
---@field description string|nil
---@field label string|nil
---@field expansionID number
---@field patchID number
---@field uiOrder number
---@field classMask number
---@field hiddenUntilCollected boolean
---@field requiredFaction string|nil
---@field collected boolean
---@field favorite boolean
---@field limitedTimeSet boolean

---@class TransmogSetPrimaryAppearanceInfo
---@field appearanceID number
---@field collected boolean
