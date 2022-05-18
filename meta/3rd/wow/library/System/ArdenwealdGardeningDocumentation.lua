---@meta
C_ArdenwealdGardening = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArdenwealdGardening.GetGardenData)
---@return ArdenwealdGardenData data
function C_ArdenwealdGardening.GetGardenData() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ArdenwealdGardening.IsGardenAccessible)
---@return boolean accessible
function C_ArdenwealdGardening.IsGardenAccessible() end

---@class ArdenwealdGardenData
---@field active number
---@field ready number
---@field remainingSeconds number
