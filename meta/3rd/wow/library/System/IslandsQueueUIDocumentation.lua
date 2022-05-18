---@meta
C_IslandsQueue = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_IslandsQueue.CloseIslandsQueueScreen)
function C_IslandsQueue.CloseIslandsQueueScreen() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_IslandsQueue.GetIslandDifficultyInfo)
---@return IslandsQueueDifficultyInfo[] islandDifficultyInfo
function C_IslandsQueue.GetIslandDifficultyInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_IslandsQueue.GetIslandsMaxGroupSize)
---@return number maxGroupSize
function C_IslandsQueue.GetIslandsMaxGroupSize() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_IslandsQueue.GetIslandsWeeklyQuestID)
---@return number? questID
function C_IslandsQueue.GetIslandsWeeklyQuestID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_IslandsQueue.QueueForIsland)
---@param difficultyID number
function C_IslandsQueue.QueueForIsland(difficultyID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_IslandsQueue.RequestPreloadRewardData)
---@param questId number
function C_IslandsQueue.RequestPreloadRewardData(questId) end

---@class IslandsQueueDifficultyInfo
---@field difficultyId number
---@field previewRewardQuestId number
