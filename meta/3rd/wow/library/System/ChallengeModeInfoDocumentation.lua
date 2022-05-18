---@meta
C_ChallengeMode = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.CanUseKeystoneInCurrentMap)
---@param itemLocation ItemLocationMixin
---@return boolean canUse
function C_ChallengeMode.CanUseKeystoneInCurrentMap(itemLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.ClearKeystone)
function C_ChallengeMode.ClearKeystone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.CloseKeystoneFrame)
function C_ChallengeMode.CloseKeystoneFrame() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetActiveChallengeMapID)
---@return number? mapChallengeModeID
function C_ChallengeMode.GetActiveChallengeMapID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetActiveKeystoneInfo)
---@return number activeKeystoneLevel
---@return number[] activeAffixIDs
---@return boolean wasActiveKeystoneCharged
function C_ChallengeMode.GetActiveKeystoneInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetAffixInfo)
---@param affixID number
---@return string name
---@return string description
---@return number filedataid
function C_ChallengeMode.GetAffixInfo(affixID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetCompletionInfo)
---@return number mapChallengeModeID
---@return number level
---@return number time
---@return boolean onTime
---@return number keystoneUpgradeLevels
---@return boolean practiceRun
---@return number? oldOverallDungeonScore
---@return number? newOverallDungeonScore
---@return boolean IsMapRecord
---@return boolean IsAffixRecord
---@return number PrimaryAffix
---@return boolean isEligibleForScore
---@return ChallengeModeCompletionMemberInfo[] members
function C_ChallengeMode.GetCompletionInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetDeathCount)
---@return number numDeaths
---@return number timeLost
function C_ChallengeMode.GetDeathCount() end

---Returns a color value from the passed in overall season M+ rating.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetDungeonScoreRarityColor)
---@param dungeonScore number
---@return ColorMixin scoreColor
function C_ChallengeMode.GetDungeonScoreRarityColor(dungeonScore) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetGuildLeaders)
---@return ChallengeModeGuildTopAttempt[] topAttempt
function C_ChallengeMode.GetGuildLeaders() end

---Returns a color value from the passed in keystone level.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetKeystoneLevelRarityColor)
---@param level number
---@return ColorMixin levelScore
function C_ChallengeMode.GetKeystoneLevelRarityColor(level) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetMapScoreInfo)
---@return MythicPlusRatingLinkInfo[] displayScores
function C_ChallengeMode.GetMapScoreInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetMapTable)
---@return number[] mapChallengeModeIDs
function C_ChallengeMode.GetMapTable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetMapUIInfo)
---@param mapChallengeModeID number
---@return string name
---@return number id
---@return number timeLimit
---@return number? texture
---@return number backgroundTexture
function C_ChallengeMode.GetMapUIInfo(mapChallengeModeID) end

---Gets the overall season mythic+ rating for the player.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetOverallDungeonScore)
---@return number overallDungeonScore
function C_ChallengeMode.GetOverallDungeonScore() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetPowerLevelDamageHealthMod)
---@param powerLevel number
---@return number damageMod
---@return number healthMod
function C_ChallengeMode.GetPowerLevelDamageHealthMod(powerLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetSlottedKeystoneInfo)
---@return number mapChallengeModeID
---@return number[] affixIDs
---@return number keystoneLevel
function C_ChallengeMode.GetSlottedKeystoneInfo() end

---Returns a color value from the passed in mythic+ rating from the combined affix scores for a specific dungeon
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor)
---@param specificDungeonOverallScore number
---@return ColorMixin specificDungeonOverallScoreColor
function C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor(specificDungeonOverallScore) end

---Returns a color value from the passed in mythic+ rating for a specific dungeon.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.GetSpecificDungeonScoreRarityColor)
---@param specificDungeonScore number
---@return ColorMixin specificDungeonScoreColor
function C_ChallengeMode.GetSpecificDungeonScoreRarityColor(specificDungeonScore) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.HasSlottedKeystone)
---@return boolean hasSlottedKeystone
function C_ChallengeMode.HasSlottedKeystone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.IsChallengeModeActive)
---@return boolean challengeModeActive
function C_ChallengeMode.IsChallengeModeActive() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.RemoveKeystone)
---@return boolean removalSuccessful
function C_ChallengeMode.RemoveKeystone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.RequestLeaders)
---@param mapChallengeModeID number
function C_ChallengeMode.RequestLeaders(mapChallengeModeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.Reset)
function C_ChallengeMode.Reset() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.SetKeystoneTooltip)
function C_ChallengeMode.SetKeystoneTooltip() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.SlotKeystone)
function C_ChallengeMode.SlotKeystone() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChallengeMode.StartChallengeMode)
---@return boolean success
function C_ChallengeMode.StartChallengeMode() end

---@class ChallengeModeCompletionMemberInfo
---@field memberGUID string
---@field name string

---@class ChallengeModeGuildAttemptMember
---@field name string
---@field classFileName string

---@class ChallengeModeGuildTopAttempt
---@field name string
---@field classFileName string
---@field keystoneLevel number
---@field mapChallengeModeID number
---@field isYou boolean
---@field members ChallengeModeGuildAttemptMember[]
