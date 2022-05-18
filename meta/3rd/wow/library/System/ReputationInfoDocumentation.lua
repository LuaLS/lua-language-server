---@meta
C_Reputation = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Reputation.GetFactionParagonInfo)
---@param factionID number
---@return number currentValue
---@return number threshold
---@return number rewardQuestID
---@return boolean hasRewardPending
---@return boolean tooLowLevelForParagon
function C_Reputation.GetFactionParagonInfo(factionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Reputation.IsFactionParagon)
---@param factionID number
---@return boolean hasParagon
function C_Reputation.IsFactionParagon(factionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Reputation.RequestFactionParagonPreloadRewardData)
---@param factionID number
function C_Reputation.RequestFactionParagonPreloadRewardData(factionID) end
