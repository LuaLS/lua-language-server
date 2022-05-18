---@meta
C_LFGInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.CanPlayerUseGroupFinder)
---@return boolean canUse
---@return string failureReason
function C_LFGInfo.CanPlayerUseGroupFinder() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.CanPlayerUseLFD)
---@return boolean canUse
---@return string failureReason
function C_LFGInfo.CanPlayerUseLFD() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.CanPlayerUseLFR)
---@return boolean canUse
---@return string failureReason
function C_LFGInfo.CanPlayerUseLFR() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.CanPlayerUsePVP)
---@return boolean canUse
---@return string failureReason
function C_LFGInfo.CanPlayerUsePVP() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.CanPlayerUsePremadeGroup)
---@return boolean canUse
---@return string failureReason
function C_LFGInfo.CanPlayerUsePremadeGroup() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.ConfirmLfgExpandSearch)
function C_LFGInfo.ConfirmLfgExpandSearch() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.GetAllEntriesForCategory)
---@param category number
---@return number[] lfgDungeonIDs
function C_LFGInfo.GetAllEntriesForCategory(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.GetDungeonInfo)
---@param lfgDungeonID number
---@return LFGDungeonInfo dungeonInfo
function C_LFGInfo.GetDungeonInfo(lfgDungeonID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.GetLFDLockStates)
---@return LFGLockInfo[] lockInfo
function C_LFGInfo.GetLFDLockStates() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.GetRoleCheckDifficultyDetails)
---@return number? maxLevel
---@return boolean isLevelReduced
function C_LFGInfo.GetRoleCheckDifficultyDetails() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_LFGInfo.HideNameFromUI)
---@param dungeonID number
---@return boolean shouldHide
function C_LFGInfo.HideNameFromUI(dungeonID) end

---@class LFGDungeonInfo
---@field name string
---@field iconID number
---@field link string|nil

---@class LFGLockInfo
---@field lfgID number
---@field reason number
---@field hideEntry boolean
