---@meta
C_QuestLog = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.AbandonQuest)
function C_QuestLog.AbandonQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.AddQuestWatch)
---@param questID number
---@param watchType? QuestWatchType
---@return boolean wasWatched
function C_QuestLog.AddQuestWatch(questID, watchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.AddWorldQuestWatch)
---@param questID number
---@param watchType? QuestWatchType
---@return boolean wasWatched
function C_QuestLog.AddWorldQuestWatch(questID, watchType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.CanAbandonQuest)
---@param questID number
---@return boolean canAbandon
function C_QuestLog.CanAbandonQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetAbandonQuest)
---@return number questID
function C_QuestLog.GetAbandonQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetAbandonQuestItems)
---@return number[] itemIDs
function C_QuestLog.GetAbandonQuestItems() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetActiveThreatMaps)
---@return number[] uiMapIDs
function C_QuestLog.GetActiveThreatMaps() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetAllCompletedQuestIDs)
---@return number[] quests
function C_QuestLog.GetAllCompletedQuestIDs() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetBountiesForMapID)
---@param uiMapID number
---@return BountyInfo[]? bounties
function C_QuestLog.GetBountiesForMapID(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetBountySetInfoForMapID)
---@param uiMapID number
---@return MapOverlayDisplayLocation displayLocation
---@return number lockQuestID
---@return number bountySetID
function C_QuestLog.GetBountySetInfoForMapID(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetDistanceSqToQuest)
---@param questID number
---@return number distanceSq
---@return boolean onContinent
function C_QuestLog.GetDistanceSqToQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetInfo)
---@param questLogIndex number
---@return QuestInfo? info
function C_QuestLog.GetInfo(questLogIndex) end

---Only returns a log index for actual quests, not headers
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetLogIndexForQuestID)
---@param questID number
---@return number? questLogIndex
function C_QuestLog.GetLogIndexForQuestID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetMapForQuestPOIs)
---@return number uiMapID
function C_QuestLog.GetMapForQuestPOIs() end

---This is the maximum number of quests a player can be on, including hidden quests, world quests, emissaries etc
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetMaxNumQuests)
---@return number maxNumQuests
function C_QuestLog.GetMaxNumQuests() end

---This is the maximum number of standard quests a player can accept. These are quests that are normally visible in the quest log.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetMaxNumQuestsCanAccept)
---@return number maxNumQuestsCanAccept
function C_QuestLog.GetMaxNumQuestsCanAccept() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNextWaypoint)
---@param questID number
---@return number mapID
---@return number x
---@return number y
function C_QuestLog.GetNextWaypoint(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNextWaypointForMap)
---@param questID number
---@param uiMapID number
---@return number x
---@return number y
function C_QuestLog.GetNextWaypointForMap(questID, uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNextWaypointText)
---@param questID number
---@return string waypointText
function C_QuestLog.GetNextWaypointText(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNumQuestLogEntries)
---@return number numShownEntries
---@return number numQuests
function C_QuestLog.GetNumQuestLogEntries() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNumQuestObjectives)
---@param questID number
---@return number leaderboardCount
function C_QuestLog.GetNumQuestObjectives(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNumQuestWatches)
---@return number numQuestWatches
function C_QuestLog.GetNumQuestWatches() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetNumWorldQuestWatches)
---@return number numQuestWatches
function C_QuestLog.GetNumWorldQuestWatches() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestAdditionalHighlights)
---@param questID number
---@return number uiMapID
---@return boolean worldQuests
---@return boolean worldQuestsElite
---@return boolean dungeons
---@return boolean treasures
function C_QuestLog.GetQuestAdditionalHighlights(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestDetailsTheme)
---@param questID number
---@return QuestTheme? theme
function C_QuestLog.GetQuestDetailsTheme(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestDifficultyLevel)
---@param questID number
---@return number level
function C_QuestLog.GetQuestDifficultyLevel(questID) end

---Only returns a questID for actual quests, not headers
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestIDForLogIndex)
---@param questLogIndex number
---@return number? questID
function C_QuestLog.GetQuestIDForLogIndex(questLogIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestIDForQuestWatchIndex)
---@param questWatchIndex number
---@return number? questID
function C_QuestLog.GetQuestIDForQuestWatchIndex(questWatchIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestIDForWorldQuestWatchIndex)
---@param questWatchIndex number
---@return number? questID
function C_QuestLog.GetQuestIDForWorldQuestWatchIndex(questWatchIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestLogPortraitGiver)
---@param questLogIndex? number
---@return number portraitGiver
---@return string portraitGiverText
---@return string portraitGiverName
---@return number portraitGiverMount
---@return number? portraitGiverModelSceneID
function C_QuestLog.GetQuestLogPortraitGiver(questLogIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestObjectives)
---@param questID number
---@return QuestObjectiveInfo[] objectives
function C_QuestLog.GetQuestObjectives(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestTagInfo)
---@param questID number
---@return QuestTagInfo? info
function C_QuestLog.GetQuestTagInfo(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestType)
---@param questID number
---@return number? questType
function C_QuestLog.GetQuestType(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestWatchType)
---@param questID number
---@return QuestWatchType? watchType
function C_QuestLog.GetQuestWatchType(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetQuestsOnMap)
---@param uiMapID number
---@return QuestOnMapInfo[] quests
function C_QuestLog.GetQuestsOnMap(uiMapID) end

---Uses the selected quest if no questID is provided
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetRequiredMoney)
---@param questID? number
---@return number requiredMoney
function C_QuestLog.GetRequiredMoney(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetSelectedQuest)
---@return number questID
function C_QuestLog.GetSelectedQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetSuggestedGroupSize)
---@param questID number
---@return number suggestedGroupSize
function C_QuestLog.GetSuggestedGroupSize(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetTimeAllowed)
---@param questID number
---@return number totalTime
---@return number elapsedTime
function C_QuestLog.GetTimeAllowed(questID) end

---Returns a valid title for anything that is in the quest log.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetTitleForLogIndex)
---@param questLogIndex number
---@return string? title
function C_QuestLog.GetTitleForLogIndex(questLogIndex) end

---Only returns a valid title for quests, header titles cannot be discovered using this.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetTitleForQuestID)
---@param questID number
---@return string? title
function C_QuestLog.GetTitleForQuestID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.GetZoneStoryInfo)
---@param uiMapID number
---@return number achievementID
---@return number storyMapID
function C_QuestLog.GetZoneStoryInfo(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.HasActiveThreats)
---@return boolean hasActiveThreats
function C_QuestLog.HasActiveThreats() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsAccountQuest)
---@param questID number
---@return boolean isAccountQuest
function C_QuestLog.IsAccountQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsComplete)
---@param questID number
---@return boolean isComplete
function C_QuestLog.IsComplete(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsFailed)
---@param questID number
---@return boolean isFailed
function C_QuestLog.IsFailed(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsLegendaryQuest)
---@param questID number
---@return boolean isLegendaryQuest
function C_QuestLog.IsLegendaryQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsOnMap)
---@param questID number
---@return boolean onMap
---@return boolean hasLocalPOI
function C_QuestLog.IsOnMap(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsOnQuest)
---@param questID number
---@return boolean isOnQuest
function C_QuestLog.IsOnQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsPushableQuest)
---@param questID number
---@return boolean isPushable
function C_QuestLog.IsPushableQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestBounty)
---@param questID number
---@return boolean isBounty
function C_QuestLog.IsQuestBounty(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestCalling)
---@param questID number
---@return boolean isCalling
function C_QuestLog.IsQuestCalling(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestCriteriaForBounty)
---@param questID number
---@param bountyQuestID number
---@return boolean isCriteriaForBounty
function C_QuestLog.IsQuestCriteriaForBounty(questID, bountyQuestID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestDisabledForSession)
---@param questID number
---@return boolean isDisabled
function C_QuestLog.IsQuestDisabledForSession(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestFlaggedCompleted)
---@param questID number
---@return boolean isCompleted
function C_QuestLog.IsQuestFlaggedCompleted(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestInvasion)
---@param questID number
---@return boolean isInvasion
function C_QuestLog.IsQuestInvasion(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestReplayable)
---@param questID number
---@return boolean isReplayable
function C_QuestLog.IsQuestReplayable(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestReplayedRecently)
---@param questID number
---@return boolean recentlyReplayed
function C_QuestLog.IsQuestReplayedRecently(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestTask)
---@param questID number
---@return boolean isTask
function C_QuestLog.IsQuestTask(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsQuestTrivial)
---@param questID number
---@return boolean isTrivial
function C_QuestLog.IsQuestTrivial(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsRepeatableQuest)
---@param questID number
---@return boolean isRepeatable
function C_QuestLog.IsRepeatableQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsThreatQuest)
---@param questID number
---@return boolean isThreat
function C_QuestLog.IsThreatQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsUnitOnQuest)
---@param unit string
---@param questID number
---@return boolean isOnQuest
function C_QuestLog.IsUnitOnQuest(unit, questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.IsWorldQuest)
---@param questID number
---@return boolean isWorldQuest
function C_QuestLog.IsWorldQuest(questID) end

---Tests whether a quest is eligible for warmode bonuses (e.g. most world quests, some daily quests
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.QuestCanHaveWarModeBonus)
---@param questID number
---@return boolean hasBonus
function C_QuestLog.QuestCanHaveWarModeBonus(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.QuestHasQuestSessionBonus)
---@param questID number
---@return boolean hasBonus
function C_QuestLog.QuestHasQuestSessionBonus(questID) end

---Tests whether a quest in the player's quest log that is eligible for warmode bonuses (see 'QuestCanHaveWarModeBOnus') has been completed in warmode (including accepting it)
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.QuestHasWarModeBonus)
---@param questID number
---@return boolean hasBonus
function C_QuestLog.QuestHasWarModeBonus(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.ReadyForTurnIn)
---@param questID number
---@return boolean? readyForTurnIn
function C_QuestLog.ReadyForTurnIn(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.RemoveQuestWatch)
---@param questID number
---@return boolean wasRemoved
function C_QuestLog.RemoveQuestWatch(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.RemoveWorldQuestWatch)
---@param questID number
---@return boolean wasRemoved
function C_QuestLog.RemoveWorldQuestWatch(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.RequestLoadQuestByID)
---@param questID number
function C_QuestLog.RequestLoadQuestByID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.SetAbandonQuest)
function C_QuestLog.SetAbandonQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.SetMapForQuestPOIs)
---@param uiMapID number
function C_QuestLog.SetMapForQuestPOIs(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.SetSelectedQuest)
---@param questID number
function C_QuestLog.SetSelectedQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.ShouldDisplayTimeRemaining)
---@param questID number
---@return boolean displayTimeRemaining
function C_QuestLog.ShouldDisplayTimeRemaining(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.ShouldShowQuestRewards)
---@param questID number
---@return boolean shouldShow
function C_QuestLog.ShouldShowQuestRewards(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLog.SortQuestWatches)
function C_QuestLog.SortQuestWatches() end

---@class QuestInfo
---@field title string
---@field questLogIndex number
---@field questID number
---@field campaignID number|nil
---@field level number
---@field difficultyLevel number
---@field suggestedGroup number
---@field frequency QuestFrequency|nil
---@field isHeader boolean
---@field isCollapsed boolean
---@field startEvent boolean
---@field isTask boolean
---@field isBounty boolean
---@field isStory boolean
---@field isScaling boolean
---@field isOnMap boolean
---@field hasLocalPOI boolean
---@field isHidden boolean
---@field isAutoComplete boolean
---@field overridesSortOrder boolean
---@field readyForTranslation boolean

---@class QuestObjectiveInfo
---@field text string
---@field type string
---@field finished boolean
---@field numFulfilled number
---@field numRequired number

---@class QuestOnMapInfo
---@field questID number
---@field x number
---@field y number
---@field type number
---@field isMapIndicatorQuest boolean

---@class QuestTagInfo
---@field tagName string
---@field tagID number
---@field worldQuestType number|nil
---@field quality WorldQuestQuality|nil
---@field tradeskillLineID number|nil
---@field isElite boolean|nil
---@field displayExpiration boolean|nil

---@class QuestTheme
---@field background string
---@field seal string
---@field signature string
---@field poiIcon string
