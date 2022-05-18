---@meta
C_DeathInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DeathInfo.GetCorpseMapPosition)
---@param uiMapID number
---@return Vector2DMixin? position
function C_DeathInfo.GetCorpseMapPosition(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DeathInfo.GetDeathReleasePosition)
---@param uiMapID number
---@return Vector2DMixin? position
function C_DeathInfo.GetDeathReleasePosition(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DeathInfo.GetGraveyardsForMap)
---@param uiMapID number
---@return GraveyardMapInfo[] graveyards
function C_DeathInfo.GetGraveyardsForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DeathInfo.GetSelfResurrectOptions)
---@return SelfResurrectOption[] options
function C_DeathInfo.GetSelfResurrectOptions() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DeathInfo.UseSelfResurrectOption)
---@param optionType SelfResurrectOptionType
---@param id number
function C_DeathInfo.UseSelfResurrectOption(optionType, id) end

---@class GraveyardMapInfo
---@field areaPoiID number
---@field position Vector2DMixin
---@field name string
---@field textureIndex number
---@field graveyardID number
---@field isGraveyardSelectable boolean

---@class SelfResurrectOption
---@field name string
---@field optionType SelfResurrectOptionType
---@field id number
---@field canUse boolean
---@field isLimited boolean
---@field priority number
