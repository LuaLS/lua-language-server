---@meta
C_TransmogCollection = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.AccountCanCollectSource)
---@param sourceID number
---@return boolean hasItemData
---@return boolean canCollect
function C_TransmogCollection.AccountCanCollectSource(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.CanAppearanceHaveIllusion)
---@param appearanceID number
---@return boolean canHaveIllusion
function C_TransmogCollection.CanAppearanceHaveIllusion(appearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.ClearNewAppearance)
---@param visualID number
function C_TransmogCollection.ClearNewAppearance(visualID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.ClearSearch)
---@param searchType TransmogSearchType
---@return boolean completed
function C_TransmogCollection.ClearSearch(searchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.DeleteOutfit)
---@param outfitID number
function C_TransmogCollection.DeleteOutfit(outfitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.EndSearch)
function C_TransmogCollection.EndSearch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAllAppearanceSources)
---@param itemAppearanceID number
---@return number[] itemModifiedAppearanceIDs
function C_TransmogCollection.GetAllAppearanceSources(itemAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAppearanceCameraID)
---@param itemAppearanceID number
---@param variation? TransmogCameraVariation
---@return number cameraID
function C_TransmogCollection.GetAppearanceCameraID(itemAppearanceID, variation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAppearanceCameraIDBySource)
---@param itemModifiedAppearanceID number
---@param variation? TransmogCameraVariation
---@return number cameraID
function C_TransmogCollection.GetAppearanceCameraIDBySource(itemModifiedAppearanceID, variation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAppearanceInfoBySource)
---@param itemModifiedAppearanceID number
---@return TransmogAppearanceInfoBySourceData info
function C_TransmogCollection.GetAppearanceInfoBySource(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAppearanceSourceDrops)
---@param itemModifiedAppearanceID number
---@return TransmogAppearanceJournalEncounterInfo[] encounterInfo
function C_TransmogCollection.GetAppearanceSourceDrops(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAppearanceSourceInfo)
---@param itemModifiedAppearanceID number
---@return TransmogCollectionType category
---@return number itemAppearanceID
---@return boolean canHaveIllusion
---@return number icon
---@return boolean isCollected
---@return string itemLink
---@return string transmoglink
---@return number? sourceType
---@return number itemSubClass
function C_TransmogCollection.GetAppearanceSourceInfo(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetAppearanceSources)
---@param appearanceID number
---@param categoryType? TransmogCollectionType
---@return AppearanceSourceInfo[] sources
function C_TransmogCollection.GetAppearanceSources(appearanceID, categoryType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetArtifactAppearanceStrings)
---@param appearanceID number
---@return string name
---@return string hyperlink
function C_TransmogCollection.GetArtifactAppearanceStrings(appearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetCategoryAppearances)
---@param category TransmogCollectionType
---@return TransmogCategoryAppearanceInfo[] appearances
function C_TransmogCollection.GetCategoryAppearances(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetCategoryCollectedCount)
---@param category TransmogCollectionType
---@return number count
function C_TransmogCollection.GetCategoryCollectedCount(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetCategoryInfo)
---@param category TransmogCollectionType
---@return string name
---@return boolean isWeapon
---@return boolean canHaveIllusions
---@return boolean canMainHand
---@return boolean canOffHand
function C_TransmogCollection.GetCategoryInfo(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetCategoryTotal)
---@param category TransmogCollectionType
---@return number total
function C_TransmogCollection.GetCategoryTotal(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetCollectedShown)
---@return boolean shown
function C_TransmogCollection.GetCollectedShown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetFallbackWeaponAppearance)
---@return number? appearanceID
function C_TransmogCollection.GetFallbackWeaponAppearance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetIllusionInfo)
---@param illusionID number
---@return TransmogIllusionInfo info
function C_TransmogCollection.GetIllusionInfo(illusionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetIllusionStrings)
---@param illusionID number
---@return string name
---@return string hyperlink
---@return string? sourceText
function C_TransmogCollection.GetIllusionStrings(illusionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetIllusions)
---@return TransmogIllusionInfo[] illusions
function C_TransmogCollection.GetIllusions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetInspectItemTransmogInfoList)
---@return table[] list
function C_TransmogCollection.GetInspectItemTransmogInfoList() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetIsAppearanceFavorite)
---@param itemAppearanceID number
---@return boolean isFavorite
function C_TransmogCollection.GetIsAppearanceFavorite(itemAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetItemInfo)
---@param itemInfo string
---@return number itemAppearanceID
---@return number itemModifiedAppearanceID
function C_TransmogCollection.GetItemInfo(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetItemTransmogInfoListFromOutfitHyperlink)
---@param hyperlink string
---@return table[] list
function C_TransmogCollection.GetItemTransmogInfoListFromOutfitHyperlink(hyperlink) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetLatestAppearance)
---@return number visualID
---@return TransmogCollectionType category
function C_TransmogCollection.GetLatestAppearance() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetNumMaxOutfits)
---@return number maxOutfits
function C_TransmogCollection.GetNumMaxOutfits() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetNumTransmogSources)
---@return number count
function C_TransmogCollection.GetNumTransmogSources() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetOutfitHyperlinkFromItemTransmogInfoList)
---@param itemTransmogInfoList table[]
---@return string hyperlink
function C_TransmogCollection.GetOutfitHyperlinkFromItemTransmogInfoList(itemTransmogInfoList) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetOutfitInfo)
---@param outfitID number
---@return string name
---@return number icon
function C_TransmogCollection.GetOutfitInfo(outfitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetOutfitItemTransmogInfoList)
---@param outfitID number
---@return table[] list
function C_TransmogCollection.GetOutfitItemTransmogInfoList(outfitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetOutfits)
---@return number[] outfitID
function C_TransmogCollection.GetOutfits() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetPairedArtifactAppearance)
---@param itemModifiedAppearanceID number
---@return number pairedItemModifiedAppearanceID
function C_TransmogCollection.GetPairedArtifactAppearance(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetSourceIcon)
---@param itemModifiedAppearanceID number
---@return number icon
function C_TransmogCollection.GetSourceIcon(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetSourceInfo)
---@param sourceID number
---@return AppearanceSourceInfo sourceInfo
function C_TransmogCollection.GetSourceInfo(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetSourceItemID)
---@param itemModifiedAppearanceID number
---@return number itemID
function C_TransmogCollection.GetSourceItemID(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetSourceRequiredHoliday)
---@param itemModifiedAppearanceID number
---@return string holidayName
function C_TransmogCollection.GetSourceRequiredHoliday(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.GetUncollectedShown)
---@return boolean shown
function C_TransmogCollection.GetUncollectedShown() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.HasFavorites)
---@return boolean hasFavorites
function C_TransmogCollection.HasFavorites() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.IsAppearanceHiddenVisual)
---@param appearanceID number
---@return boolean isHiddenVisual
function C_TransmogCollection.IsAppearanceHiddenVisual(appearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.IsCategoryValidForItem)
---@param category TransmogCollectionType
---@param itemInfo string
---@return boolean isValid
function C_TransmogCollection.IsCategoryValidForItem(category, itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.IsNewAppearance)
---@param visualID number
---@return boolean isNew
function C_TransmogCollection.IsNewAppearance(visualID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.IsSearchDBLoading)
---@return boolean isLoading
function C_TransmogCollection.IsSearchDBLoading() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.IsSearchInProgress)
---@param searchType TransmogSearchType
---@return boolean inProgress
function C_TransmogCollection.IsSearchInProgress(searchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.IsSourceTypeFilterChecked)
---@param index number
---@return boolean checked
function C_TransmogCollection.IsSourceTypeFilterChecked(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.ModifyOutfit)
---@param outfitID number
---@param itemTransmogInfoList table[]
function C_TransmogCollection.ModifyOutfit(outfitID, itemTransmogInfoList) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.NewOutfit)
---@param name string
---@param icon number
---@param itemTransmogInfoList table[]
---@return number? outfitID
function C_TransmogCollection.NewOutfit(name, icon, itemTransmogInfoList) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.PlayerCanCollectSource)
---@param sourceID number
---@return boolean hasItemData
---@return boolean canCollect
function C_TransmogCollection.PlayerCanCollectSource(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.PlayerHasTransmog)
---@param itemID number
---@param itemAppearanceModID number
---@return boolean hasTransmog
function C_TransmogCollection.PlayerHasTransmog(itemID, itemAppearanceModID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.PlayerHasTransmogByItemInfo)
---@param itemInfo string
---@return boolean hasTransmog
function C_TransmogCollection.PlayerHasTransmogByItemInfo(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance)
---@param itemModifiedAppearanceID number
---@return boolean hasTransmog
function C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.PlayerKnowsSource)
---@param sourceID number
---@return boolean isKnown
function C_TransmogCollection.PlayerKnowsSource(sourceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.RenameOutfit)
---@param outfitID number
---@param name string
function C_TransmogCollection.RenameOutfit(outfitID, name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SearchProgress)
---@param searchType TransmogSearchType
---@return number progress
function C_TransmogCollection.SearchProgress(searchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SearchSize)
---@param searchType TransmogSearchType
---@return number size
function C_TransmogCollection.SearchSize(searchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetAllSourceTypeFilters)
---@param checked boolean
function C_TransmogCollection.SetAllSourceTypeFilters(checked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetCollectedShown)
---@param shown boolean
function C_TransmogCollection.SetCollectedShown(shown) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetIsAppearanceFavorite)
---@param itemAppearanceID number
---@param isFavorite boolean
function C_TransmogCollection.SetIsAppearanceFavorite(itemAppearanceID, isFavorite) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetSearch)
---@param searchType TransmogSearchType
---@param searchText string
---@return boolean completed
function C_TransmogCollection.SetSearch(searchType, searchText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetSearchAndFilterCategory)
---@param category TransmogCollectionType
function C_TransmogCollection.SetSearchAndFilterCategory(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetSourceTypeFilter)
---@param index number
---@param checked boolean
function C_TransmogCollection.SetSourceTypeFilter(index, checked) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.SetUncollectedShown)
---@param shown boolean
function C_TransmogCollection.SetUncollectedShown(shown) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TransmogCollection.UpdateUsableAppearances)
function C_TransmogCollection.UpdateUsableAppearances() end

---@class TransmogAppearanceInfoBySourceData
---@field appearanceID number
---@field appearanceIsCollected boolean
---@field sourceIsCollected boolean
---@field sourceIsCollectedPermanent boolean
---@field sourceIsCollectedConditional boolean
---@field meetsTransmogPlayerCondition boolean
---@field appearanceHasAnyNonLevelRequirements boolean
---@field appearanceMeetsNonLevelRequirements boolean
---@field appearanceIsUsable boolean
---@field appearanceNumSources number
---@field sourceIsKnown boolean

---@class TransmogAppearanceJournalEncounterInfo
---@field instance string
---@field instanceType number
---@field tiers string[]
---@field encounter string
---@field difficulties string[]

---@class TransmogCategoryAppearanceInfo
---@field visualID number
---@field isCollected boolean
---@field isFavorite boolean
---@field isHideVisual boolean
---@field uiOrder number
---@field exclusions number
---@field restrictedSlotID number|nil
---@field isUsable boolean
---@field hasRequiredHoliday boolean
---@field hasActiveRequiredHoliday boolean
---@field alwaysShowItem boolean|nil

---@class TransmogIllusionInfo
---@field visualID number
---@field sourceID number
---@field icon number
---@field isCollected boolean
---@field isUsable boolean
---@field isHideVisual boolean
