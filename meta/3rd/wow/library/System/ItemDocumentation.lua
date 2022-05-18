---@meta
C_Item = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.CanItemTransmogAppearance)
---@param itemLoc ItemLocationMixin
---@return boolean canTransmog
---@return number errorCode
function C_Item.CanItemTransmogAppearance(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.CanScrapItem)
---@param itemLoc ItemLocationMixin
---@return boolean canBeScrapped
function C_Item.CanScrapItem(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.CanViewItemPowers)
---@param itemLoc ItemLocationMixin
---@return boolean isItemViewable
function C_Item.CanViewItemPowers(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.DoesItemExist)
---@param emptiableItemLocation ItemLocationMixin
---@return boolean itemExists
function C_Item.DoesItemExist(emptiableItemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.DoesItemExistByID)
---@param itemInfo string
---@return boolean itemExists
function C_Item.DoesItemExistByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.DoesItemMatchBonusTreeReplacement)
---@param itemLoc ItemLocationMixin
---@return boolean matchesBonusTree
function C_Item.DoesItemMatchBonusTreeReplacement(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetAppliedItemTransmogInfo)
---@param itemLoc ItemLocationMixin
---@return ItemTransmogInfoMixin? info
function C_Item.GetAppliedItemTransmogInfo(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetBaseItemTransmogInfo)
---@param itemLoc ItemLocationMixin
---@return ItemTransmogInfoMixin? info
function C_Item.GetBaseItemTransmogInfo(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetCurrentItemLevel)
---@param itemLocation ItemLocationMixin
---@return number? currentItemLevel
function C_Item.GetCurrentItemLevel(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetCurrentItemTransmogInfo)
---@param itemLoc ItemLocationMixin
---@return ItemTransmogInfoMixin? info
function C_Item.GetCurrentItemTransmogInfo(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemConversionOutputIcon)
---@param itemLoc ItemLocationMixin
---@return number? icon
function C_Item.GetItemConversionOutputIcon(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemGUID)
---@param itemLocation ItemLocationMixin
---@return string itemGuid
function C_Item.GetItemGUID(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemID)
---@param itemLocation ItemLocationMixin
---@return number itemID
function C_Item.GetItemID(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemIcon)
---@param itemLocation ItemLocationMixin
---@return number? icon
function C_Item.GetItemIcon(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemIconByID)
---@param itemInfo string
---@return number? icon
function C_Item.GetItemIconByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemInventoryType)
---@param itemLocation ItemLocationMixin
---@return InventoryType? inventoryType
function C_Item.GetItemInventoryType(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemInventoryTypeByID)
---@param itemInfo string
---@return InventoryType? inventoryType
function C_Item.GetItemInventoryTypeByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemLink)
---@param itemLocation ItemLocationMixin
---@return string? itemLink
function C_Item.GetItemLink(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemName)
---@param itemLocation ItemLocationMixin
---@return string? itemName
function C_Item.GetItemName(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemNameByID)
---@param itemInfo string
---@return string? itemName
function C_Item.GetItemNameByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemQuality)
---@param itemLocation ItemLocationMixin
---@return ItemQuality? itemQuality
function C_Item.GetItemQuality(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemQualityByID)
---@param itemInfo string
---@return ItemQuality? itemQuality
function C_Item.GetItemQualityByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetItemUniquenessByID)
---@param itemInfo string
---@return boolean isUnique
---@return string? limitCategoryName
---@return number? limitCategoryCount
---@return number? limitCategoryID
function C_Item.GetItemUniquenessByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.GetStackCount)
---@param itemLocation ItemLocationMixin
---@return number stackCount
function C_Item.GetStackCount(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsAnimaItemByID)
---@param itemInfo string
---@return boolean isAnimaItem
function C_Item.IsAnimaItemByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsBound)
---@param itemLocation ItemLocationMixin
---@return boolean isBound
function C_Item.IsBound(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsDressableItemByID)
---@param itemInfo string
---@return boolean isDressableItem
function C_Item.IsDressableItemByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemConduit)
---@param itemLoc ItemLocationMixin
---@return boolean isConduit
function C_Item.IsItemConduit(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemConvertibleAndValidForPlayer)
---@param itemLoc ItemLocationMixin
---@return boolean isItemConvertibleAndValidForPlayer
function C_Item.IsItemConvertibleAndValidForPlayer(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemCorrupted)
---@param itemLoc ItemLocationMixin
---@return boolean isCorrupted
function C_Item.IsItemCorrupted(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemCorruptionRelated)
---@param itemLoc ItemLocationMixin
---@return boolean isCorruptionRelated
function C_Item.IsItemCorruptionRelated(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemCorruptionResistant)
---@param itemLoc ItemLocationMixin
---@return boolean isCorruptionResistant
function C_Item.IsItemCorruptionResistant(itemLoc) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemDataCached)
---@param itemLocation ItemLocationMixin
---@return boolean isCached
function C_Item.IsItemDataCached(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemDataCachedByID)
---@param itemInfo string
---@return boolean isCached
function C_Item.IsItemDataCachedByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemKeystoneByID)
---@param itemInfo string
---@return boolean isKeystone
function C_Item.IsItemKeystoneByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsItemSpecificToPlayerClass)
---@param itemInfo string
---@return boolean isItemSpecificToPlayerClass
function C_Item.IsItemSpecificToPlayerClass(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.IsLocked)
---@param itemLocation ItemLocationMixin
---@return boolean isLocked
function C_Item.IsLocked(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.LockItem)
---@param itemLocation ItemLocationMixin
function C_Item.LockItem(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.LockItemByGUID)
---@param itemGUID string
function C_Item.LockItemByGUID(itemGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.RequestLoadItemData)
---@param itemLocation ItemLocationMixin
function C_Item.RequestLoadItemData(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.RequestLoadItemDataByID)
---@param itemInfo string
function C_Item.RequestLoadItemDataByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.UnlockItem)
---@param itemLocation ItemLocationMixin
function C_Item.UnlockItem(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Item.UnlockItemByGUID)
---@param itemGUID string
function C_Item.UnlockItemByGUID(itemGUID) end
