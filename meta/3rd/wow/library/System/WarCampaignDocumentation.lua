---@meta
C_CampaignInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetAvailableCampaigns)
---@return number[] campaignIDs
function C_CampaignInfo.GetAvailableCampaigns() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetCampaignChapterInfo)
---@param campaignChapterID number
---@return CampaignChapterInfo? campaignChapterInfo
function C_CampaignInfo.GetCampaignChapterInfo(campaignChapterID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetCampaignID)
---@param questID number
---@return number campaignID
function C_CampaignInfo.GetCampaignID(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetCampaignInfo)
---@param campaignID number
---@return CampaignInfo? campaignInfo
function C_CampaignInfo.GetCampaignInfo(campaignID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetChapterIDs)
---@param campaignID number
---@return number[]? chapterIDs
function C_CampaignInfo.GetChapterIDs(campaignID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetCurrentChapterID)
---@param campaignID number
---@return number? currentChapterID
function C_CampaignInfo.GetCurrentChapterID(campaignID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetFailureReason)
---@param campaignID number
---@return CampaignFailureReason? failureReason
function C_CampaignInfo.GetFailureReason(campaignID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.GetState)
---@param campaignID number
---@return CampaignState state
function C_CampaignInfo.GetState(campaignID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.IsCampaignQuest)
---@param questID number
---@return boolean isCampaignQuest
function C_CampaignInfo.IsCampaignQuest(questID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_CampaignInfo.UsesNormalQuestIcons)
---@param campaignID number
---@return boolean useNormalQuestIcons
function C_CampaignInfo.UsesNormalQuestIcons(campaignID) end

---@class CampaignChapterInfo
---@field name string
---@field description string
---@field rewardQuestID number

---@class CampaignFailureReason
---@field text string
---@field questID number|nil
---@field mapID number|nil

---@class CampaignInfo
---@field name string
---@field description string
---@field uiTextureKit string
---@field isWarCampaign boolean
