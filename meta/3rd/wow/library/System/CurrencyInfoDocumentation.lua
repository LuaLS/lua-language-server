---@meta
C_CurrencyInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.DoesWarModeBonusApply)
---@param currencyID number
---@return boolean? warModeApplies
---@return boolean? limitOncePerTooltip
function C_CurrencyInfo.DoesWarModeBonusApply(currencyID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.ExpandCurrencyList)
---@param index number
---@param expand boolean
function C_CurrencyInfo.ExpandCurrencyList(index, expand) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetAzeriteCurrencyID)
---@return number azeriteCurrencyID
function C_CurrencyInfo.GetAzeriteCurrencyID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetBackpackCurrencyInfo)
---@param index number
---@return BackpackCurrencyInfo info
function C_CurrencyInfo.GetBackpackCurrencyInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetBasicCurrencyInfo)
---@param currencyType number
---@param quantity? number
---@return CurrencyDisplayInfo info
function C_CurrencyInfo.GetBasicCurrencyInfo(currencyType, quantity) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyContainerInfo)
---@param currencyType number
---@param quantity number
---@return CurrencyDisplayInfo info
function C_CurrencyInfo.GetCurrencyContainerInfo(currencyType, quantity) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyIDFromLink)
---@param currencyLink string
---@return number currencyID
function C_CurrencyInfo.GetCurrencyIDFromLink(currencyLink) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyInfo)
---@param type number
---@return CurrencyInfo info
function C_CurrencyInfo.GetCurrencyInfo(type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyInfoFromLink)
---@param link string
---@return CurrencyInfo info
function C_CurrencyInfo.GetCurrencyInfoFromLink(link) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyLink)
---@param type number
---@param amount? number
---@return string link
function C_CurrencyInfo.GetCurrencyLink(type, amount) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyListInfo)
---@param index number
---@return CurrencyInfo info
function C_CurrencyInfo.GetCurrencyListInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyListLink)
---@param index number
---@return string link
function C_CurrencyInfo.GetCurrencyListLink(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetCurrencyListSize)
---@return number currencyListSize
function C_CurrencyInfo.GetCurrencyListSize() end

---Gets the faction ID for currency that is immediately converted into reputation with that faction instead.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetFactionGrantedByCurrency)
---@param currencyID number
---@return number? factionID
function C_CurrencyInfo.GetFactionGrantedByCurrency(currencyID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.GetWarResourcesCurrencyID)
---@return number warResourceCurrencyID
function C_CurrencyInfo.GetWarResourcesCurrencyID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.IsCurrencyContainer)
---@param currencyID number
---@param quantity number
---@return boolean isCurrencyContainer
function C_CurrencyInfo.IsCurrencyContainer(currencyID, quantity) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.PickupCurrency)
---@param type number
function C_CurrencyInfo.PickupCurrency(type) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.SetCurrencyBackpack)
---@param index number
---@param backpack boolean
function C_CurrencyInfo.SetCurrencyBackpack(index, backpack) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CurrencyInfo.SetCurrencyUnused)
---@param index number
---@param unused boolean
function C_CurrencyInfo.SetCurrencyUnused(index, unused) end

---@class BackpackCurrencyInfo
---@field name string
---@field quantity number
---@field iconFileID number
---@field currencyTypesID number

---@class CurrencyDisplayInfo
---@field name string
---@field description string
---@field icon number
---@field quality number
---@field displayAmount number
---@field actualAmount number

---@class CurrencyInfo
---@field name string
---@field isHeader boolean
---@field isHeaderExpanded boolean
---@field isTypeUnused boolean
---@field isShowInBackpack boolean
---@field quantity number
---@field trackedQuantity number
---@field iconFileID number
---@field maxQuantity number
---@field canEarnPerWeek boolean
---@field quantityEarnedThisWeek number
---@field isTradeable boolean
---@field quality ItemQuality
---@field maxWeeklyQuantity number
---@field totalEarned number
---@field discovered boolean
---@field useTotalEarnedForMaxQty boolean
