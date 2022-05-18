---@meta
C_QuestSession = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.CanStart)
---@return boolean allowed
function C_QuestSession.CanStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.CanStop)
---@return boolean allowed
function C_QuestSession.CanStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.Exists)
---@return boolean exists
function C_QuestSession.Exists() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.GetAvailableSessionCommand)
---@return QuestSessionCommand command
function C_QuestSession.GetAvailableSessionCommand() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.GetPendingCommand)
---@return QuestSessionCommand command
function C_QuestSession.GetPendingCommand() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.GetProposedMaxLevelForSession)
---@return number proposedMaxLevel
function C_QuestSession.GetProposedMaxLevelForSession() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.GetSessionBeginDetails)
---@return QuestSessionPlayerDetails? details
function C_QuestSession.GetSessionBeginDetails() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.GetSuperTrackedQuest)
---@return number? questID
function C_QuestSession.GetSuperTrackedQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.HasJoined)
---@return boolean hasJoined
function C_QuestSession.HasJoined() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.HasPendingCommand)
---@return boolean hasPendingCommand
function C_QuestSession.HasPendingCommand() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.RequestSessionStart)
function C_QuestSession.RequestSessionStart() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.RequestSessionStop)
function C_QuestSession.RequestSessionStop() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.SendSessionBeginResponse)
---@param beginSession boolean
function C_QuestSession.SendSessionBeginResponse(beginSession) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_QuestSession.SetQuestIsSuperTracked)
---@param questID number
---@param superTrack boolean
function C_QuestSession.SetQuestIsSuperTracked(questID, superTrack) end

---@class QuestSessionPlayerDetails
---@field name string
---@field guid string
