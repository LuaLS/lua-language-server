---@meta
C_PlayerMentorship = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerMentorship.GetMentorLevelRequirement)
---@return number? level
function C_PlayerMentorship.GetMentorLevelRequirement() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerMentorship.GetMentorRequirements)
---@return number[] achievementIDs
---@return number[] optionalAchievementIDs
---@return number optionalCompleteAtLeastCount
function C_PlayerMentorship.GetMentorRequirements() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerMentorship.GetMentorshipStatus)
---@param playerLocation PlayerLocationMixin
---@return PlayerMentorshipStatus status
function C_PlayerMentorship.GetMentorshipStatus(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerMentorship.IsActivePlayerConsideredNewcomer)
---@return boolean isConsideredNewcomer
function C_PlayerMentorship.IsActivePlayerConsideredNewcomer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerMentorship.IsMentorRestricted)
---@return boolean isRestricted
function C_PlayerMentorship.IsMentorRestricted() end
