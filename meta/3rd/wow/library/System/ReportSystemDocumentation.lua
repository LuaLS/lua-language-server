---@meta
C_ReportSystem = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.CanReportPlayer)
---@param playerLocation PlayerLocationMixin
---@return boolean canReport
function C_ReportSystem.CanReportPlayer(playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.CanReportPlayerForLanguage)
---@param playerLocation PlayerLocationMixin
---@return boolean canReport
function C_ReportSystem.CanReportPlayerForLanguage(playerLocation) end

---Not allowed to be called by addons
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.InitiateReportPlayer)
---@param complaintType string
---@param playerLocation? PlayerLocationMixin
---@return number token
function C_ReportSystem.InitiateReportPlayer(complaintType, playerLocation) end

---Addons should use this to open the ReportPlayer dialog. InitiateReportPlayer and SendReportPlayer are no longer accessible to addons.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.OpenReportPlayerDialog)
---@param reportType string
---@param playerName string
---@param playerLocation? PlayerLocationMixin
function C_ReportSystem.OpenReportPlayerDialog(reportType, playerName, playerLocation) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.ReportServerLag)
function C_ReportSystem.ReportServerLag() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.ReportStuckInCombat)
function C_ReportSystem.ReportStuckInCombat() end

---Not allowed to be called by addons
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.SendReportPlayer)
---@param token number
---@param comment? string
function C_ReportSystem.SendReportPlayer(token, comment) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.SetPendingReportPetTarget)
---@param target? string
---@return boolean set
function C_ReportSystem.SetPendingReportPetTarget(target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.SetPendingReportTarget)
---@param target? string
---@return boolean set
function C_ReportSystem.SetPendingReportTarget(target) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ReportSystem.SetPendingReportTargetByGuid)
---@param guid? string
---@return boolean set
function C_ReportSystem.SetPendingReportTargetByGuid(guid) end
