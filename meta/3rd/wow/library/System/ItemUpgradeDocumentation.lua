---@meta
C_ItemUpgrade = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.CanUpgradeItem)
---@param baseItem ItemLocationMixin
---@return boolean isValid
function C_ItemUpgrade.CanUpgradeItem(baseItem) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.ClearItemUpgrade)
function C_ItemUpgrade.ClearItemUpgrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.CloseItemUpgrade)
function C_ItemUpgrade.CloseItemUpgrade() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.GetItemHyperlink)
---@return string link
function C_ItemUpgrade.GetItemHyperlink() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.GetItemUpgradeCurrentLevel)
---@return number itemLevel
---@return boolean isPvpItemLevel
function C_ItemUpgrade.GetItemUpgradeCurrentLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.GetItemUpgradeEffect)
---@param effectIndex number
---@param numUpgradeLevels? number
---@return string outBaseEffect
---@return string outUpgradedEffect
function C_ItemUpgrade.GetItemUpgradeEffect(effectIndex, numUpgradeLevels) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.GetItemUpgradeItemInfo)
---@return ItemUpgradeItemInfo itemInfo
function C_ItemUpgrade.GetItemUpgradeItemInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.GetItemUpgradePvpItemLevelDeltaValues)
---@param numUpgradeLevels number
---@return number currentPvPItemLevel
---@return number upgradedPvPItemLevel
function C_ItemUpgrade.GetItemUpgradePvpItemLevelDeltaValues(numUpgradeLevels) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.GetNumItemUpgradeEffects)
---@return number numItemUpgradeEffects
function C_ItemUpgrade.GetNumItemUpgradeEffects() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.SetItemUpgradeFromCursorItem)
function C_ItemUpgrade.SetItemUpgradeFromCursorItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.SetItemUpgradeFromLocation)
---@param itemToSet ItemLocationMixin
function C_ItemUpgrade.SetItemUpgradeFromLocation(itemToSet) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ItemUpgrade.UpgradeItem)
---@param numUpgrades number
function C_ItemUpgrade.UpgradeItem(numUpgrades) end

---@class ItemUpgradeCurrencyCost
---@field cost number
---@field currencyID number

---@class ItemUpgradeItemInfo
---@field iconID number
---@field name string
---@field itemUpgradeable boolean
---@field displayQuality number
---@field currUpgrade number
---@field maxUpgrade number
---@field upgradeLevelInfos ItemUpgradeLevelInfo[]

---@class ItemUpgradeLevelInfo
---@field upgradeLevel number
---@field displayQuality number
---@field itemLevelIncrement number
---@field levelStats ItemUpgradeStat[]
---@field costsToUpgrade ItemUpgradeCurrencyCost[]
---@field failureMessage string|nil

---@class ItemUpgradeStat
---@field displayString string
---@field statValue number
---@field active boolean
