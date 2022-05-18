---@meta
C_TaskQuest = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.DoesMapShowTaskQuestObjectives)
---@param uiMapID number
---@return boolean showsTaskQuestObjectives
function C_TaskQuest.DoesMapShowTaskQuestObjectives(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestInfoByQuestID)
---@param questID number
---@return string questTitle
---@return number? factionID
---@return boolean? capped
---@return boolean? displayAsObjective
function C_TaskQuest.GetQuestInfoByQuestID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestLocation)
---@param questID number
---@param uiMapID number
---@return number locationX
---@return number locationY
function C_TaskQuest.GetQuestLocation(questID, uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestProgressBarInfo)
---@param questID number
---@return number progress
function C_TaskQuest.GetQuestProgressBarInfo(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestTimeLeftMinutes)
---@param questID number
---@return number minutesLeft
function C_TaskQuest.GetQuestTimeLeftMinutes(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestTimeLeftSeconds)
---@param questID number
---@return number secondsLeft
function C_TaskQuest.GetQuestTimeLeftSeconds(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestZoneID)
---@param questID number
---@return number uiMapID
function C_TaskQuest.GetQuestZoneID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetQuestsForPlayerByMapID)
---@param uiMapID number
---@return TaskPOIData[] taskPOIs
function C_TaskQuest.GetQuestsForPlayerByMapID(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetThreatQuests)
---@return number[] quests
function C_TaskQuest.GetThreatQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.GetUIWidgetSetIDFromQuestID)
---@param questID number
---@return number UiWidgetSetID
function C_TaskQuest.GetUIWidgetSetIDFromQuestID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.IsActive)
---@param questID number
---@return boolean active
function C_TaskQuest.IsActive(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaskQuest.RequestPreloadRewardData)
---@param questID number
function C_TaskQuest.RequestPreloadRewardData(questID) end

---@class TaskPOIData
---@field questId number
---@field x number
---@field y number
---@field inProgress boolean
---@field numObjectives number
---@field mapID number
---@field isQuestStart boolean
---@field isDaily boolean
---@field isCombatAllyQuest boolean
---@field childDepth number|nil
