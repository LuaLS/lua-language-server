---@meta
C_UserFeedback = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UserFeedback.SubmitBug)
---@param bugInfo string
---@param suppressNotification boolean
---@return boolean success
function C_UserFeedback.SubmitBug(bugInfo, suppressNotification) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_UserFeedback.SubmitSuggestion)
---@param suggestion string
---@return boolean success
function C_UserFeedback.SubmitSuggestion(suggestion) end
