---@meta
C_Garrison = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.AddFollowerToMission)
---@param missionID number
---@param followerID string
---@param boardIndex? number
---@return boolean followerAdded
function C_Garrison.AddFollowerToMission(missionID, followerID, boardIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAutoCombatDamageClassValues)
---@return AutoCombatDamageClassString[] damageClassStrings
function C_Garrison.GetAutoCombatDamageClassValues() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAutoMissionBoardState)
---@param missionID number
---@return AutoMissionTargetingInfo[] targetInfo
function C_Garrison.GetAutoMissionBoardState(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAutoMissionEnvironmentEffect)
---@param missionID number
---@return AutoMissionEnvironmentEffect? autoMissionEnvEffect
function C_Garrison.GetAutoMissionEnvironmentEffect(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAutoMissionTargetingInfo)
---@param missionID number
---@param followerID string
---@param casterBoardIndex number
---@return AutoMissionTargetingInfo[] targetInfo
function C_Garrison.GetAutoMissionTargetingInfo(missionID, followerID, casterBoardIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAutoMissionTargetingInfoForSpell)
---@param missionID number
---@param autoCombatSpellID number
---@param casterBoardIndex number
---@return AutoMissionTargetingInfo[] targetInfo
function C_Garrison.GetAutoMissionTargetingInfoForSpell(missionID, autoCombatSpellID, casterBoardIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetAutoTroops)
---@param followerType number
---@return AutoCombatTroopInfo[] autoTroopInfo
function C_Garrison.GetAutoTroops(followerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCombatLogSpellInfo)
---@param autoCombatSpellID number
---@return AutoCombatSpellInfo? spellInfo
function C_Garrison.GetCombatLogSpellInfo(autoCombatSpellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCurrentCypherEquipmentLevel)
---@return number equipmentLevel
function C_Garrison.GetCurrentCypherEquipmentLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCurrentGarrTalentTreeFriendshipFactionID)
---@return number? currentGarrTalentTreeFriendshipFactionID
function C_Garrison.GetCurrentGarrTalentTreeFriendshipFactionID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCurrentGarrTalentTreeID)
---@return number? currentGarrTalentTreeID
function C_Garrison.GetCurrentGarrTalentTreeID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetCyphersToNextEquipmentLevel)
---@return number? cyphersToNext
function C_Garrison.GetCyphersToNextEquipmentLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAutoCombatSpells)
---@param garrFollowerID string
---@param followerLevel number
---@return AutoCombatSpellInfo[] autoCombatSpells
---@return AutoCombatSpellInfo? autoCombatAutoAttack
function C_Garrison.GetFollowerAutoCombatSpells(garrFollowerID, followerLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerAutoCombatStats)
---@param garrFollowerID string
---@return FollowerAutoCombatStatsInfo? autoCombatInfo
function C_Garrison.GetFollowerAutoCombatStats(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetFollowerMissionCompleteInfo)
---@param followerID string
---@return FollowerMissionCompleteInfo followerMissionCompleteInfo
function C_Garrison.GetFollowerMissionCompleteInfo(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetGarrisonPlotsInstancesForMap)
---@param uiMapID number
---@return GarrisonPlotInstanceMapInfo[] garrisonPlotInstances
function C_Garrison.GetGarrisonPlotsInstancesForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetGarrisonTalentTreeCurrencyTypes)
---@param garrTalentTreeID number
---@return number? garrTalentTreeCurrencyType
function C_Garrison.GetGarrisonTalentTreeCurrencyTypes(garrTalentTreeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetGarrisonTalentTreeType)
---@param garrTalentTreeID number
---@return number garrTalentTreeType
function C_Garrison.GetGarrisonTalentTreeType(garrTalentTreeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMaxCypherEquipmentLevel)
---@return number maxEquipmentLevel
function C_Garrison.GetMaxCypherEquipmentLevel() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionCompleteEncounters)
---@param missionID number
---@return GarrisonEnemyEncounterInfo[] encounters
function C_Garrison.GetMissionCompleteEncounters(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionDeploymentInfo)
---@param missionID number
---@return MissionDeploymentInfo missionDeploymentInfo
function C_Garrison.GetMissionDeploymentInfo(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetMissionEncounterIconInfo)
---@param missionID number
---@return MissionEncounterIconInfo missionEncounterIconInfo
function C_Garrison.GetMissionEncounterIconInfo(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentInfo)
---@param talentID number
---@return GarrisonTalentInfo info
function C_Garrison.GetTalentInfo(talentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentPointsSpentInTalentTree)
---@param garrTalentTreeID number
---@return number talentPoints
function C_Garrison.GetTalentPointsSpentInTalentTree(garrTalentTreeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentTreeIDsByClassID)
---@param garrType number
---@param classID number
---@return number[] treeIDs
function C_Garrison.GetTalentTreeIDsByClassID(garrType, classID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentTreeInfo)
---@param treeID number
---@return GarrisonTalentTreeInfo info
function C_Garrison.GetTalentTreeInfo(treeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentTreeResetInfo)
---@param garrTalentTreeID number
---@return number goldCost
---@return GarrisonTalentCurrencyCostInfo[] currencyCosts
function C_Garrison.GetTalentTreeResetInfo(garrTalentTreeID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentTreeTalentPointResearchInfo)
---@param garrTalentID number
---@param researchRank number
---@param garrTalentTreeID number
---@param talentPointIndex number
---@param isRespec number
---@return number goldCost
---@return GarrisonTalentCurrencyCostInfo[] currencyCosts
---@return number durationSecs
function C_Garrison.GetTalentTreeTalentPointResearchInfo(garrTalentID, researchRank, garrTalentTreeID, talentPointIndex, isRespec) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.GetTalentUnlockWorldQuest)
---@param talentID number
---@return number worldQuestID
function C_Garrison.GetTalentUnlockWorldQuest(talentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.HasAdventures)
---@return boolean hasAdventures
function C_Garrison.HasAdventures() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsAtGarrisonMissionNPC)
---@return boolean atGarrisonMissionNPC
function C_Garrison.IsAtGarrisonMissionNPC() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsEnvironmentCountered)
---@param missionID number
---@return boolean environmentCountered
function C_Garrison.IsEnvironmentCountered(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsFollowerOnCompletedMission)
---@param followerID string
---@return boolean followerOnCompletedMission
function C_Garrison.IsFollowerOnCompletedMission(followerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.IsTalentConditionMet)
---@param talentID number
---@return boolean isMet
---@return string? failureString
function C_Garrison.IsTalentConditionMet(talentID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RegenerateCombatLog)
---@param missionID number
---@return boolean success
function C_Garrison.RegenerateCombatLog(missionID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RemoveFollowerFromMission)
---@param missionID number
---@param followerID string
---@param boardIndex? number
function C_Garrison.RemoveFollowerFromMission(missionID, followerID, boardIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RushHealAllFollowers)
---@param followerType number
function C_Garrison.RushHealAllFollowers(followerType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.RushHealFollower)
---@param garrFollowerID string
function C_Garrison.RushHealFollower(garrFollowerID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Garrison.SetAutoCombatSpellFastForward)
---@param state boolean
function C_Garrison.SetAutoCombatSpellFastForward(state) end

---@class AutoCombatDamageClassString
---@field damageClassValue number
---@field locString string

---@class AutoCombatResult
---@field winner boolean
---@field combatLog AutoMissionRound[]

---@class AutoCombatSpellInfo
---@field autoCombatSpellID number
---@field name string
---@field description string
---@field cooldown number
---@field duration number
---@field schoolMask number
---@field previewMask number
---@field icon number
---@field spellTutorialFlag number
---@field hasThornsEffect boolean

---@class AutoCombatTroopInfo
---@field name string
---@field followerID string
---@field garrFollowerID string
---@field followerTypeID number
---@field displayIDs FollowerDisplayID[]
---@field level number
---@field quality number
---@field levelXP number
---@field maxXP number
---@field height number
---@field scale number
---@field displayScale number|nil
---@field displayHeight number|nil
---@field classSpec number|nil
---@field className string|nil
---@field flavorText string|nil
---@field classAtlas string
---@field portraitIconID number
---@field textureKit string
---@field isTroop boolean
---@field raceID number
---@field health number
---@field maxHealth number
---@field role number
---@field isAutoTroop boolean
---@field isSoulbind boolean
---@field isCollected boolean
---@field autoCombatStats FollowerAutoCombatStatsInfo

---@class AutoMissionCombatEventInfo
---@field boardIndex number
---@field oldHealth number
---@field newHealth number
---@field maxHealth number
---@field points number|nil

---@class AutoMissionEnvironmentEffect
---@field name string
---@field autoCombatSpellInfo AutoCombatSpellInfo

---@class AutoMissionEvent
---@field type number
---@field spellID number
---@field schoolMask number
---@field effectIndex number
---@field casterBoardIndex number
---@field auraType number
---@field targetInfo AutoMissionCombatEventInfo[]

---@class AutoMissionRound
---@field events AutoMissionEvent[]

---@class AutoMissionTargetingInfo
---@field targetIndex number
---@field previewType number
---@field spellID number
---@field effectIndex number

---@class FollowerAutoCombatStatsInfo
---@field currentHealth number
---@field maxHealth number
---@field attack number
---@field healingTimestamp number
---@field healCost number
---@field minutesHealingRemaining number

---@class FollowerDisplayID
---@field id number
---@field followerPageScale number
---@field showWeapon boolean

---@class FollowerMissionCompleteInfo
---@field name string
---@field displayIDs FollowerDisplayID[]
---@field level number
---@field quality number
---@field currentXP number
---@field maxXP number
---@field height number
---@field scale number
---@field movementType number|nil
---@field impactDelay number|nil
---@field castID number|nil
---@field castSoundID number|nil
---@field impactID number|nil
---@field impactSoundID number|nil
---@field targetImpactID number|nil
---@field targetImpactSoundID number|nil
---@field className string|nil
---@field classAtlas string
---@field portraitIconID number
---@field textureKit string
---@field isTroop boolean
---@field boardIndex number
---@field health number
---@field maxHealth number
---@field role number

---@class GarrisonAbilityCounterInfo
---@field id number
---@field icon number
---@field name string
---@field factor number
---@field description string

---@class GarrisonAbilityInfo
---@field id number
---@field name string
---@field description string
---@field icon number
---@field isTrait boolean
---@field isSpecialization boolean
---@field temporary boolean
---@field category string|nil
---@field counters GarrisonAbilityCounterInfo[]
---@field isEmptySlot boolean

---@class GarrisonEnemyEncounterInfo
---@field name string
---@field displayID number
---@field portraitFileDataID number
---@field textureKit string
---@field scale number
---@field height number
---@field mechanics GarrisonMechanicInfo[]
---@field autoCombatSpells AutoCombatSpellInfo[]
---@field autoCombatAutoAttack AutoCombatSpellInfo|nil
---@field role number
---@field health number
---@field maxHealth number
---@field attack number
---@field boardIndex number
---@field isElite boolean

---@class GarrisonFollowerDeathInfo
---@field followerID string
---@field state number

---@class GarrisonMechanicInfo
---@field mechanicTypeID number
---@field icon number
---@field name string
---@field factor number
---@field description string
---@field ability GarrisonAbilityInfo|nil

---@class GarrisonPlotInstanceMapInfo
---@field buildingPlotInstanceID number
---@field position Vector2DMixin
---@field name string
---@field atlasName string

---@class MissionDeploymentInfo
---@field location string
---@field xp number
---@field environment string|nil
---@field environmentDesc string|nil
---@field environmentTexture number
---@field locTextureKit string
---@field isExhausting boolean
---@field enemies GarrisonEnemyEncounterInfo[]

---@class MissionEncounterIconInfo
---@field portraitFileDataID number
---@field missionScalar number
---@field isElite boolean
---@field isRare boolean
