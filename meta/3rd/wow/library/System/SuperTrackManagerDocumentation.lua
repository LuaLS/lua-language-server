---@meta
C_SuperTrack = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.GetHighestPrioritySuperTrackingType)
---@return SuperTrackingType? type
function C_SuperTrack.GetHighestPrioritySuperTrackingType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.GetSuperTrackedQuestID)
---@return number? questID
function C_SuperTrack.GetSuperTrackedQuestID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.IsSuperTrackingAnything)
---@return boolean isSuperTracking
function C_SuperTrack.IsSuperTrackingAnything() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.IsSuperTrackingCorpse)
---@return boolean isSuperTracking
function C_SuperTrack.IsSuperTrackingCorpse() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.IsSuperTrackingQuest)
---@return boolean isSuperTracking
function C_SuperTrack.IsSuperTrackingQuest() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.IsSuperTrackingUserWaypoint)
---@return boolean isSuperTracking
function C_SuperTrack.IsSuperTrackingUserWaypoint() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.SetSuperTrackedQuestID)
---@param questID number
function C_SuperTrack.SetSuperTrackedQuestID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SuperTrack.SetSuperTrackedUserWaypoint)
---@param superTracked boolean
function C_SuperTrack.SetSuperTrackedUserWaypoint(superTracked) end
