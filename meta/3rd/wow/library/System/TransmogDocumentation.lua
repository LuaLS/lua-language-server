---@meta
C_Transmog = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.ApplyAllPending)
---@param currentSpecOnly boolean
---@return boolean requestSent
function C_Transmog.ApplyAllPending(currentSpecOnly) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.CanHaveSecondaryAppearanceForSlotID)
---@param slotID number
---@return boolean canHaveSecondaryAppearance
function C_Transmog.CanHaveSecondaryAppearanceForSlotID(slotID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.CanTransmogItem)
---@param itemInfo string
---@return boolean canBeTransmogged
---@return string? selfFailureReason
---@return boolean canTransmogOthers
---@return string? othersFailureReason
function C_Transmog.CanTransmogItem(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.CanTransmogItemWithItem)
---@param targetItemInfo string
---@param sourceItemInfo string
---@return boolean canTransmog
---@return string? failureReason
function C_Transmog.CanTransmogItemWithItem(targetItemInfo, sourceItemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.ClearAllPending)
function C_Transmog.ClearAllPending() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.ClearPending)
---@param transmogLocation TransmogLocationMixin
function C_Transmog.ClearPending(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.Close)
function C_Transmog.Close() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.ExtractTransmogIDList)
---@param input string
---@return number[] transmogIDList
function C_Transmog.ExtractTransmogIDList(input) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetApplyCost)
---@return number? cost
function C_Transmog.GetApplyCost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetApplyWarnings)
---@return TransmogApplyWarningInfo[] warnings
function C_Transmog.GetApplyWarnings() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetBaseCategory)
---@param transmogID number
---@return TransmogCollectionType categoryID
function C_Transmog.GetBaseCategory(transmogID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetCreatureDisplayIDForSource)
---@param itemModifiedAppearanceID number
---@return number? creatureDisplayID
function C_Transmog.GetCreatureDisplayIDForSource(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetItemIDForSource)
---@param itemModifiedAppearanceID number
---@return number? itemID
function C_Transmog.GetItemIDForSource(itemModifiedAppearanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetPending)
---@param transmogLocation TransmogLocationMixin
---@return TransmogPendingInfoMixin pendingInfo
function C_Transmog.GetPending(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetSlotEffectiveCategory)
---@param transmogLocation TransmogLocationMixin
---@return TransmogCollectionType categoryID
function C_Transmog.GetSlotEffectiveCategory(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetSlotForInventoryType)
---@param inventoryType number
---@return number slot
function C_Transmog.GetSlotForInventoryType(inventoryType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetSlotInfo)
---@param transmogLocation TransmogLocationMixin
---@return boolean isTransmogrified
---@return boolean hasPending
---@return boolean isPendingCollected
---@return boolean canTransmogrify
---@return number cannotTransmogrifyReason
---@return boolean hasUndo
---@return boolean isHideVisual
---@return number? texture
function C_Transmog.GetSlotInfo(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetSlotUseError)
---@param transmogLocation TransmogLocationMixin
---@return number errorCode
---@return string errorString
function C_Transmog.GetSlotUseError(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.GetSlotVisualInfo)
---@param transmogLocation TransmogLocationMixin
---@return number baseSourceID
---@return number baseVisualID
---@return number appliedSourceID
---@return number appliedVisualID
---@return number pendingSourceID
---@return number pendingVisualID
---@return boolean hasUndo
---@return boolean isHideVisual
---@return number itemSubclass
function C_Transmog.GetSlotVisualInfo(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.IsAtTransmogNPC)
---@return boolean isAtNPC
function C_Transmog.IsAtTransmogNPC() end

---Returns true if the only pending for the location's slot is a ToggleOff for the secondary appearance.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.IsSlotBeingCollapsed)
---@param transmogLocation TransmogLocationMixin
---@return boolean isBeingCollapsed
function C_Transmog.IsSlotBeingCollapsed(transmogLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.LoadOutfit)
---@param outfitID number
function C_Transmog.LoadOutfit(outfitID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Transmog.SetPending)
---@param transmogLocation TransmogLocationMixin
---@param pendingInfo TransmogPendingInfoMixin
function C_Transmog.SetPending(transmogLocation, pendingInfo) end

---@class TransmogApplyWarningInfo
---@field itemLink string
---@field text string
