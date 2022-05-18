---@meta
C_ChromieTime = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChromieTime.CloseUI)
function C_ChromieTime.CloseUI() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChromieTime.GetChromieTimeExpansionOption)
---@param expansionRecID number
---@return ChromieTimeExpansionInfo? info
function C_ChromieTime.GetChromieTimeExpansionOption(expansionRecID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChromieTime.GetChromieTimeExpansionOptions)
---@return ChromieTimeExpansionInfo[] expansionOptions
function C_ChromieTime.GetChromieTimeExpansionOptions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ChromieTime.SelectChromieTimeOption)
---@param chromieTimeExpansionInfoId number
function C_ChromieTime.SelectChromieTimeOption(chromieTimeExpansionInfoId) end

---@class ChromieTimeExpansionInfo
---@field id number
---@field name string
---@field description string
---@field mapAtlas string
---@field previewAtlas string
---@field completed boolean
---@field alreadyOn boolean
