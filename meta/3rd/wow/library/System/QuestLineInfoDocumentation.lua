---@meta
C_QuestLine = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLine.GetAvailableQuestLines)
---@param uiMapID number
---@return QuestLineInfo[] questLines
function C_QuestLine.GetAvailableQuestLines(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLine.GetQuestLineInfo)
---@param questID number
---@param uiMapID number
---@return QuestLineInfo? questLineInfo
function C_QuestLine.GetQuestLineInfo(questID, uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLine.GetQuestLineQuests)
---@param questLineID number
---@return number[] questIDs
function C_QuestLine.GetQuestLineQuests(questLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLine.IsComplete)
---@param questLineID number
---@return boolean isComplete
function C_QuestLine.IsComplete(questLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestLine.RequestQuestLinesForMap)
---@param uiMapID number
function C_QuestLine.RequestQuestLinesForMap(uiMapID) end

---@class QuestLineInfo
---@field questLineName string
---@field questName string
---@field questLineID number
---@field questID number
---@field x number
---@field y number
---@field isHidden boolean
---@field isLegendary boolean
---@field isDaily boolean
---@field isCampaign boolean
---@field floorLocation QuestLineFloorLocation
