---@meta
C_SocialRestrictions = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SocialRestrictions.AcknowledgeRegionalChatDisabled)
function C_SocialRestrictions.AcknowledgeRegionalChatDisabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SocialRestrictions.IsChatDisabled)
---@return boolean disabled
function C_SocialRestrictions.IsChatDisabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SocialRestrictions.IsMuted)
---@return boolean isMuted
function C_SocialRestrictions.IsMuted() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SocialRestrictions.IsSilenced)
---@return boolean isSilenced
function C_SocialRestrictions.IsSilenced() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SocialRestrictions.IsSquelched)
---@return boolean isSquelched
function C_SocialRestrictions.IsSquelched() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SocialRestrictions.SetChatDisabled)
---@param disabled boolean
function C_SocialRestrictions.SetChatDisabled(disabled) end
