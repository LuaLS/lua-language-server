---@meta
C_GossipInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.CloseGossip)
function C_GossipInfo.CloseGossip() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.ForceGossip)
---@return boolean forceGossip
function C_GossipInfo.ForceGossip() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetActiveQuests)
---@return GossipQuestUIInfo[] info
function C_GossipInfo.GetActiveQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetAvailableQuests)
---@return GossipQuestUIInfo[] info
function C_GossipInfo.GetAvailableQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetCompletedOptionDescriptionString)
---@return string? description
function C_GossipInfo.GetCompletedOptionDescriptionString() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetCustomGossipDescriptionString)
---@return string? description
function C_GossipInfo.GetCustomGossipDescriptionString() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetNumActiveQuests)
---@return number numQuests
function C_GossipInfo.GetNumActiveQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetNumAvailableQuests)
---@return number numQuests
function C_GossipInfo.GetNumAvailableQuests() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetNumOptions)
---@return number numOptions
function C_GossipInfo.GetNumOptions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetOptions)
---@return GossipOptionUIInfo[] info
function C_GossipInfo.GetOptions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetPoiForUiMapID)
---@param uiMapID number
---@return number? gossipPoiID
function C_GossipInfo.GetPoiForUiMapID(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetPoiInfo)
---@param uiMapID number
---@param gossipPoiID number
---@return GossipPoiInfo? gossipPoiInfo
function C_GossipInfo.GetPoiInfo(uiMapID, gossipPoiID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.GetText)
---@return string gossipText
function C_GossipInfo.GetText() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.RefreshOptions)
function C_GossipInfo.RefreshOptions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.SelectActiveQuest)
---@param index number
function C_GossipInfo.SelectActiveQuest(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.SelectAvailableQuest)
---@param index number
function C_GossipInfo.SelectAvailableQuest(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GossipInfo.SelectOption)
---@param index number
---@param text? string
---@param confirmed? boolean
function C_GossipInfo.SelectOption(index, text, confirmed) end

---@class GossipOptionRewardInfo
---@field id number
---@field quantity number
---@field rewardType GossipOptionRewardType

---@class GossipOptionUIInfo
---@field name string
---@field type string
---@field rewards GossipOptionRewardInfo[]
---@field status GossipOptionStatus
---@field spellID number|nil

---@class GossipPoiInfo
---@field name string
---@field textureIndex number
---@field position Vector2DMixin
---@field inBattleMap boolean

---@class GossipQuestUIInfo
---@field title string
---@field questLevel number
---@field isTrivial boolean
---@field frequency number|nil
---@field repeatable boolean|nil
---@field isComplete boolean|nil
---@field isLegendary boolean
---@field isIgnored boolean
---@field questID number
