---@meta
C_PvP = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanDisplayDamage)
---@return boolean canDisplay
function C_PvP.CanDisplayDamage() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanDisplayDeaths)
---@return boolean canDisplay
function C_PvP.CanDisplayDeaths() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanDisplayHealing)
---@return boolean canDisplay
function C_PvP.CanDisplayHealing() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanDisplayHonorableKills)
---@return boolean canDisplay
function C_PvP.CanDisplayHonorableKills() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanDisplayKillingBlows)
---@return boolean canDisplay
function C_PvP.CanDisplayKillingBlows() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanPlayerUseRatedPVPUI)
---@return boolean canUse
---@return string failureReason
function C_PvP.CanPlayerUseRatedPVPUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanToggleWarMode)
---@param toggle boolean
---@return boolean canTogglePvP
function C_PvP.CanToggleWarMode(toggle) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.CanToggleWarModeInArea)
---@return boolean canTogglePvPInArea
function C_PvP.CanToggleWarModeInArea() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.DoesMatchOutcomeAffectRating)
---@return boolean doesAffect
function C_PvP.DoesMatchOutcomeAffectRating() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetActiveBrawlInfo)
---@return PvpBrawlInfo? brawlInfo
function C_PvP.GetActiveBrawlInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetActiveMatchBracket)
---@return number bracket
function C_PvP.GetActiveMatchBracket() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetActiveMatchDuration)
---@return number seconds
function C_PvP.GetActiveMatchDuration() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetActiveMatchState)
---@return PvPMatchState state
function C_PvP.GetActiveMatchState() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetActiveMatchWinner)
---@return number winner
function C_PvP.GetActiveMatchWinner() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetArenaCrowdControlInfo)
---@param playerToken string
---@return number spellID
---@return number startTime
---@return number duration
function C_PvP.GetArenaCrowdControlInfo(playerToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetArenaRewards)
---@param teamSize number
---@return number honor
---@return number experience
---@return BattlefieldItemReward[]? itemRewards
---@return BattlefieldCurrencyReward[]? currencyRewards
function C_PvP.GetArenaRewards(teamSize) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetArenaSkirmishRewards)
---@return number honor
---@return number experience
---@return BattlefieldItemReward[]? itemRewards
---@return BattlefieldCurrencyReward[]? currencyRewards
function C_PvP.GetArenaSkirmishRewards() end

---If nil is returned, PVP_BRAWL_INFO_UPDATED event will be sent when the data is ready.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetAvailableBrawlInfo)
---@return PvpBrawlInfo? brawlInfo
function C_PvP.GetAvailableBrawlInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetBattlefieldFlagPosition)
---@param flagIndex number
---@param uiMapId number
---@return number? uiPosx
---@return number? uiPosy
---@return number flagTexture
function C_PvP.GetBattlefieldFlagPosition(flagIndex, uiMapId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetBattlefieldVehicleInfo)
---@param vehicleIndex number
---@param uiMapID number
---@return BattlefieldVehicleInfo info
function C_PvP.GetBattlefieldVehicleInfo(vehicleIndex, uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetBattlefieldVehicles)
---@param uiMapID number
---@return BattlefieldVehicleInfo[] vehicles
function C_PvP.GetBattlefieldVehicles(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetBrawlRewards)
---@param brawlType BrawlType
---@return number honor
---@return number experience
---@return BattlefieldItemReward[]? itemRewards
---@return BattlefieldCurrencyReward[]? currencyRewards
---@return boolean hasWon
function C_PvP.GetBrawlRewards(brawlType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetCustomVictoryStatID)
---@return number statID
function C_PvP.GetCustomVictoryStatID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetGlobalPvpScalingInfoForSpecID)
---@param specializationID number
---@return PvpScalingData[] pvpScalingData
function C_PvP.GetGlobalPvpScalingInfoForSpecID(specializationID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetHonorRewardInfo)
---@param honorLevel number
---@return HonorRewardInfo? info
function C_PvP.GetHonorRewardInfo(honorLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetLevelUpBattlegrounds)
---@param level number
---@return LevelUpBattlegroundInfo[] battlefields
function C_PvP.GetLevelUpBattlegrounds(level) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetMatchPVPStatColumn)
---@param pvpStatID number
---@return MatchPVPStatColumn? info
function C_PvP.GetMatchPVPStatColumn(pvpStatID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetMatchPVPStatColumns)
---@return MatchPVPStatColumn[] columns
function C_PvP.GetMatchPVPStatColumns() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetNextHonorLevelForReward)
---@param honorLevel number
---@return number? nextHonorLevelWithReward
function C_PvP.GetNextHonorLevelForReward(honorLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetOutdoorPvPWaitTime)
---@param uiMapID number
---@return number pvpWaitTime
function C_PvP.GetOutdoorPvPWaitTime(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetPVPActiveMatchPersonalRatedInfo)
---@return PVPPersonalRatedInfo? info
function C_PvP.GetPVPActiveMatchPersonalRatedInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetPVPSeasonRewardAchievementID)
---@return number achievementID
function C_PvP.GetPVPSeasonRewardAchievementID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetPostMatchCurrencyRewards)
---@return PVPPostMatchCurrencyReward[] rewards
function C_PvP.GetPostMatchCurrencyRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetPostMatchItemRewards)
---@return PVPPostMatchItemReward[] rewards
function C_PvP.GetPostMatchItemRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetPvpTierID)
---@param tierEnum number
---@param bracketEnum number
---@return number? id
function C_PvP.GetPvpTierID(tierEnum, bracketEnum) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetPvpTierInfo)
---@param tierID number
---@return PvpTierInfo? pvpTierInfo
function C_PvP.GetPvpTierInfo(tierID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetRandomBGInfo)
---@return RandomBGInfo info
function C_PvP.GetRandomBGInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetRandomBGRewards)
---@return number honor
---@return number experience
---@return BattlefieldItemReward[]? itemRewards
---@return BattlefieldCurrencyReward[]? currencyRewards
function C_PvP.GetRandomBGRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetRandomEpicBGInfo)
---@return RandomBGInfo info
function C_PvP.GetRandomEpicBGInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetRandomEpicBGRewards)
---@return number honor
---@return number experience
---@return BattlefieldItemReward[]? itemRewards
---@return BattlefieldCurrencyReward[]? currencyRewards
function C_PvP.GetRandomEpicBGRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetRatedBGRewards)
---@return number honor
---@return number experience
---@return BattlefieldItemReward[]? itemRewards
---@return BattlefieldCurrencyReward[]? currencyRewards
function C_PvP.GetRatedBGRewards() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetRewardItemLevelsByTierEnum)
---@param pvpTierEnum number
---@return number activityItemLevel
---@return number weeklyItemLevel
function C_PvP.GetRewardItemLevelsByTierEnum(pvpTierEnum) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetScoreInfo)
---@param offsetIndex number
---@return PVPScoreInfo? info
function C_PvP.GetScoreInfo(offsetIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetScoreInfoByPlayerGuid)
---@param guid string
---@return PVPScoreInfo? info
function C_PvP.GetScoreInfoByPlayerGuid(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetSeasonBestInfo)
---@return number tierID
---@return number? nextTierID
function C_PvP.GetSeasonBestInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetSkirmishInfo)
---@param pvpBracket number
---@return BattlemasterListInfo battlemasterListInfo
function C_PvP.GetSkirmishInfo(pvpBracket) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetSpecialEventBrawlInfo)
---@return PvpBrawlInfo? brawlInfo
function C_PvP.GetSpecialEventBrawlInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetTeamInfo)
---@param factionIndex number
---@return PVPTeamInfo? info
function C_PvP.GetTeamInfo(factionIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetWarModeRewardBonus)
---@return number rewardBonus
function C_PvP.GetWarModeRewardBonus() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetWarModeRewardBonusDefault)
---@return number defaultBonus
function C_PvP.GetWarModeRewardBonusDefault() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.GetWeeklyChestInfo)
---@return boolean rewardAchieved
---@return boolean lastWeekRewardAchieved
---@return boolean lastWeekRewardClaimed
---@return number pvpTierMaxFromWins
function C_PvP.GetWeeklyChestInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.HasArenaSkirmishWinToday)
---@return boolean hasArenaSkirmishWinToday
function C_PvP.HasArenaSkirmishWinToday() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsActiveBattlefield)
---@return boolean isActiveBattlefield
function C_PvP.IsActiveBattlefield() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsActiveMatchRegistered)
---@return boolean registered
function C_PvP.IsActiveMatchRegistered() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsArena)
---@return boolean isArena
function C_PvP.IsArena() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsBattleground)
---@return boolean isBattleground
function C_PvP.IsBattleground() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsBattlegroundEnlistmentBonusActive)
---@return boolean battlegroundActive
---@return boolean brawlActive
function C_PvP.IsBattlegroundEnlistmentBonusActive() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsInBrawl)
---@return boolean isInBrawl
function C_PvP.IsInBrawl() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsMatchConsideredArena)
---@return boolean asArena
function C_PvP.IsMatchConsideredArena() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsMatchFactional)
---@return boolean isFactional
function C_PvP.IsMatchFactional() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsPVPMap)
---@return boolean isPVPMap
function C_PvP.IsPVPMap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsRatedArena)
---@return boolean isRatedArena
function C_PvP.IsRatedArena() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsRatedBattleground)
---@return boolean isRatedBattleground
function C_PvP.IsRatedBattleground() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsRatedMap)
---@return boolean isRatedMap
function C_PvP.IsRatedMap() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsSoloShuffle)
---@return boolean isSoloShuffle
function C_PvP.IsSoloShuffle() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsWarModeActive)
---@return boolean warModeActive
function C_PvP.IsWarModeActive() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsWarModeDesired)
---@return boolean warModeDesired
function C_PvP.IsWarModeDesired() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.IsWarModeFeatureEnabled)
---@return boolean warModeEnabled
function C_PvP.IsWarModeFeatureEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.JoinBrawl)
---@param isSpecialBrawl boolean
function C_PvP.JoinBrawl(isSpecialBrawl) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.RequestCrowdControlSpell)
---@param playerToken string
function C_PvP.RequestCrowdControlSpell(playerToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.SetWarModeDesired)
---@param warModeDesired boolean
function C_PvP.SetWarModeDesired(warModeDesired) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PvP.ToggleWarMode)
function C_PvP.ToggleWarMode() end

---@class BattlefieldCurrencyReward
---@field id number
---@field quantity number

---@class BattlefieldItemReward
---@field id number
---@field name string
---@field texture number
---@field quantity number

---@class BattlefieldVehicleInfo
---@field x number
---@field y number
---@field name string
---@field isOccupied boolean
---@field atlas string
---@field textureWidth number
---@field textureHeight number
---@field facing number
---@field isPlayer boolean
---@field isAlive boolean
---@field shouldDrawBelowPlayerBlips boolean

---@class BattlemasterListInfo
---@field name string
---@field instanceType number
---@field minPlayers number
---@field maxPlayers number
---@field icon number
---@field longDescription string
---@field shortDescription string

---@class HonorRewardInfo
---@field honorLevelName string
---@field badgeFileDataID number
---@field achievementRewardedID number

---@class LevelUpBattlegroundInfo
---@field id number
---@field icon number
---@field name string
---@field isEpic boolean

---@class MatchPVPStatColumn
---@field pvpStatID number
---@field columnHeaderID number
---@field orderIndex number
---@field name string
---@field tooltip string

---@class PvpBrawlInfo
---@field brawlID number
---@field name string
---@field shortDescription string
---@field longDescription string
---@field canQueue boolean
---@field timeLeftUntilNextChange number|nil
---@field brawlType BrawlType
---@field mapNames string[]
---@field includesAllArenas boolean

---@class PVPPersonalRatedInfo
---@field personalRating number
---@field bestSeasonRating number
---@field bestWeeklyRating number
---@field seasonPlayed number
---@field seasonWon number
---@field weeklyPlayed number
---@field weeklyWon number
---@field lastWeeksBestRating number
---@field hasWonBracketToday boolean
---@field tier number
---@field ranking number|nil

---@class PVPPostMatchCurrencyReward
---@field currencyType number
---@field quantityChanged number

---@class PVPPostMatchItemReward
---@field type string
---@field link string
---@field quantity number
---@field specID number
---@field sex number
---@field isUpgraded boolean

---@class PvpRoleQueueInfo
---@field role string
---@field totalRole number
---@field totalAccepted number
---@field totalDeclined number

---@class PvpScalingData
---@field scalingDataID number
---@field specializationID number
---@field name string
---@field value number

---@class PVPScoreInfo
---@field name string
---@field guid string
---@field killingBlows number
---@field honorableKills number
---@field deaths number
---@field honorGained number
---@field faction number
---@field raceName string
---@field className string
---@field classToken string
---@field damageDone number
---@field healingDone number
---@field rating number
---@field ratingChange number
---@field prematchMMR number
---@field mmrChange number
---@field talentSpec string
---@field honorLevel number
---@field roleAssigned number
---@field stats PVPStatInfo[]

---@class PVPStatInfo
---@field pvpStatID number
---@field pvpStatValue number
---@field orderIndex number
---@field name string
---@field tooltip string
---@field iconName string

---@class PVPTeamInfo
---@field name string
---@field size number
---@field rating number
---@field ratingNew number
---@field ratingMMR number

---@class PvpTierInfo
---@field name string
---@field descendRating number
---@field ascendRating number
---@field descendTier number
---@field ascendTier number
---@field pvpTierEnum number
---@field tierIconID number

---@class RandomBGInfo
---@field canQueue boolean
---@field bgID number
---@field hasRandomWinToday boolean
---@field minLevel number
---@field maxLevel number
