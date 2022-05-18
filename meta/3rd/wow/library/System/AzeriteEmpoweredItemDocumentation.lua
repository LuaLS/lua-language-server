---@meta
C_AzeriteEmpoweredItem = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.CanSelectPower)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@param powerID number
---@return boolean canSelect
function C_AzeriteEmpoweredItem.CanSelectPower(azeriteEmpoweredItemLocation, powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.CloseAzeriteEmpoweredItemRespec)
function C_AzeriteEmpoweredItem.CloseAzeriteEmpoweredItemRespec() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.ConfirmAzeriteEmpoweredItemRespec)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
function C_AzeriteEmpoweredItem.ConfirmAzeriteEmpoweredItemRespec(azeriteEmpoweredItemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.GetAllTierInfo)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@return AzeriteEmpoweredItemTierInfo[] tierInfo
function C_AzeriteEmpoweredItem.GetAllTierInfo(azeriteEmpoweredItemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.GetAllTierInfoByItemID)
---@param itemInfo string
---@param classID? number
---@return AzeriteEmpoweredItemTierInfo[] tierInfo
function C_AzeriteEmpoweredItem.GetAllTierInfoByItemID(itemInfo, classID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.GetAzeriteEmpoweredItemRespecCost)
---@return number cost
function C_AzeriteEmpoweredItem.GetAzeriteEmpoweredItemRespecCost() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.GetPowerInfo)
---@param powerID number
---@return AzeriteEmpoweredItemPowerInfo powerInfo
function C_AzeriteEmpoweredItem.GetPowerInfo(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.GetPowerText)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@param powerID number
---@param level AzeritePowerLevel
---@return AzeriteEmpoweredItemPowerText powerText
function C_AzeriteEmpoweredItem.GetPowerText(azeriteEmpoweredItemLocation, powerID, level) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.GetSpecsForPower)
---@param powerID number
---@return AzeriteSpecInfo[] specInfo
function C_AzeriteEmpoweredItem.GetSpecsForPower(powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.HasAnyUnselectedPowers)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@return boolean hasAnyUnselectedPowers
function C_AzeriteEmpoweredItem.HasAnyUnselectedPowers(azeriteEmpoweredItemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.HasBeenViewed)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@return boolean hasBeenViewed
function C_AzeriteEmpoweredItem.HasBeenViewed(azeriteEmpoweredItemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem)
---@param itemLocation ItemLocationMixin
---@return boolean isAzeriteEmpoweredItem
function C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItem(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID)
---@param itemInfo string
---@return boolean isAzeriteEmpoweredItem
function C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.IsAzeritePreviewSourceDisplayable)
---@param itemInfo string
---@param classID? number
---@return boolean isAzeritePreviewSourceDisplayable
function C_AzeriteEmpoweredItem.IsAzeritePreviewSourceDisplayable(itemInfo, classID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.IsHeartOfAzerothEquipped)
---@return boolean isHeartOfAzerothEquipped
function C_AzeriteEmpoweredItem.IsHeartOfAzerothEquipped() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.IsPowerAvailableForSpec)
---@param powerID number
---@param specID number
---@return boolean isPowerAvailableForSpec
function C_AzeriteEmpoweredItem.IsPowerAvailableForSpec(powerID, specID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.IsPowerSelected)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@param powerID number
---@return boolean isSelected
function C_AzeriteEmpoweredItem.IsPowerSelected(azeriteEmpoweredItemLocation, powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.SelectPower)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
---@param powerID number
---@return boolean success
function C_AzeriteEmpoweredItem.SelectPower(azeriteEmpoweredItemLocation, powerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_AzeriteEmpoweredItem.SetHasBeenViewed)
---@param azeriteEmpoweredItemLocation ItemLocationMixin
function C_AzeriteEmpoweredItem.SetHasBeenViewed(azeriteEmpoweredItemLocation) end

---@class AzeriteEmpoweredItemPowerInfo
---@field azeritePowerID number
---@field spellID number

---@class AzeriteEmpoweredItemPowerText
---@field name string
---@field description string

---@class AzeriteEmpoweredItemTierInfo
---@field azeritePowerIDs number[]
---@field unlockLevel number

---@class AzeriteSpecInfo
---@field classID number
---@field specID number
