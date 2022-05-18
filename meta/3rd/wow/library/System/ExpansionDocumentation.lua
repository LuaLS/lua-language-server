---@meta
---[Documentation](https://wowpedia.fandom.com/wiki/API_CanUpgradeExpansion)
---@return boolean canUpgradeExpansion
function CanUpgradeExpansion() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_DoesCurrentLocaleSellExpansionLevels)
---@return boolean regionSellsExpansions
function DoesCurrentLocaleSellExpansionLevels() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetAccountExpansionLevel)
---@return number expansionLevel
function GetAccountExpansionLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetClientDisplayExpansionLevel)
---@return number expansionLevel
function GetClientDisplayExpansionLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetCurrentRegionName)
---@return string regionName
function GetCurrentRegionName() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetExpansionDisplayInfo)
---@param expansionLevel number
---@return ExpansionDisplayInfo? info
function GetExpansionDisplayInfo(expansionLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetExpansionForLevel)
---@param playerLevel number
---@return number expansionLevel
function GetExpansionForLevel(playerLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetExpansionLevel)
---@return number expansionLevel
function GetExpansionLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetExpansionTrialInfo)
---@return boolean isExpansionTrialAccount
---@return number? expansionTrialRemainingSeconds
function GetExpansionTrialInfo() end

---Maps an expansion level to a maximum character level for that expansion.
---[Documentation](https://wowpedia.fandom.com/wiki/API_GetMaxLevelForExpansionLevel)
---@param expansionLevel number
---@return number maxLevel
function GetMaxLevelForExpansionLevel(expansionLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetMaxLevelForLatestExpansion)
---@return number maxLevel
function GetMaxLevelForLatestExpansion() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetMaxLevelForPlayerExpansion)
---@return number maxLevel
function GetMaxLevelForPlayerExpansion() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetMaximumExpansionLevel)
---@return number expansionLevel
function GetMaximumExpansionLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetMinimumExpansionLevel)
---@return number expansionLevel
function GetMinimumExpansionLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetNumExpansions)
---@return number numExpansions
function GetNumExpansions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_GetServerExpansionLevel)
---@return number serverExpansionLevel
function GetServerExpansionLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsExpansionTrial)
---@return boolean isExpansionTrialAccount
function IsExpansionTrial() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsTrialAccount)
---@return boolean isTrialAccount
function IsTrialAccount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_IsVeteranTrialAccount)
---@return boolean isVeteranTrialAccount
function IsVeteranTrialAccount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_SendSubscriptionInterstitialResponse)
---@param response SubscriptionInterstitialResponseType
function SendSubscriptionInterstitialResponse(response) end

---@class ExpansionDisplayInfo
---@field logo number
---@field banner string
---@field features ExpansionDisplayInfoFeature[]

---@class ExpansionDisplayInfoFeature
---@field icon number
---@field text string
