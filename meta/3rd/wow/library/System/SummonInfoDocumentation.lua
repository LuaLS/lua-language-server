---@meta
C_SummonInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.CancelSummon)
function C_SummonInfo.CancelSummon() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.ConfirmSummon)
function C_SummonInfo.ConfirmSummon() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.GetSummonConfirmAreaName)
---@return string areaName
function C_SummonInfo.GetSummonConfirmAreaName() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.GetSummonConfirmSummoner)
---@return string? summoner
function C_SummonInfo.GetSummonConfirmSummoner() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.GetSummonConfirmTimeLeft)
---@return number timeLeft
function C_SummonInfo.GetSummonConfirmTimeLeft() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.GetSummonReason)
---@return number summonReason
function C_SummonInfo.GetSummonReason() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SummonInfo.IsSummonSkippingStartExperience)
---@return boolean isSummonSkippingStartExperience
function C_SummonInfo.IsSummonSkippingStartExperience() end
