---@meta
C_PlayerInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.CanPlayerEnterChromieTime)
---@return boolean canEnter
function C_PlayerInfo.CanPlayerEnterChromieTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.CanPlayerUseAreaLoot)
---@return boolean canUseAreaLoot
function C_PlayerInfo.CanPlayerUseAreaLoot() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.CanPlayerUseMountEquipment)
---@return boolean canUseMountEquipment
---@return string failureReason
function C_PlayerInfo.CanPlayerUseMountEquipment() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetAlternateFormInfo)
---@return boolean hasAlternateForm
---@return boolean inAlternateForm
function C_PlayerInfo.GetAlternateFormInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetContentDifficultyCreatureForPlayer)
---@param unitToken string
---@return RelativeContentDifficulty difficulty
function C_PlayerInfo.GetContentDifficultyCreatureForPlayer(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetContentDifficultyQuestForPlayer)
---@param questID number
---@return RelativeContentDifficulty difficulty
function C_PlayerInfo.GetContentDifficultyQuestForPlayer(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetInstancesUnlockedAtLevel)
---@param level number
---@param isRaid boolean
---@return number[] dungeonID
function C_PlayerInfo.GetInstancesUnlockedAtLevel(level, isRaid) end

---Returns the players mythic+ rating summary which includes the runs they've completed as well as their current season m+ rating
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.GetPlayerMythicPlusRatingSummary)
---@param playerToken string
---@return MythicPlusRatingSummary ratingSummary
function C_PlayerInfo.GetPlayerMythicPlusRatingSummary(playerToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.IsPlayerEligibleForNPE)
---@return boolean isEligible
---@return string failureReason
function C_PlayerInfo.IsPlayerEligibleForNPE() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.IsPlayerEligibleForNPEv2)
---@return boolean isEligible
---@return string failureReason
function C_PlayerInfo.IsPlayerEligibleForNPEv2() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.IsPlayerInChromieTime)
---@return boolean inChromieTime
function C_PlayerInfo.IsPlayerInChromieTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerInfo.IsPlayerNPERestricted)
---@return boolean isRestricted
function C_PlayerInfo.IsPlayerNPERestricted() end

---@class MythicPlusRatingMapSummary
---@field challengeModeID number
---@field mapScore number
---@field bestRunLevel number
---@field bestRunDurationMS number
---@field finishedSuccess boolean

---@class MythicPlusRatingSummary
---@field currentSeasonScore number
---@field runs MythicPlusRatingMapSummary[]
