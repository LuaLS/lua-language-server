---@meta
C_VignetteInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_VignetteInfo.FindBestUniqueVignette)
---@param vignetteGUIDs string[]
---@return number? bestUniqueVignetteIndex
function C_VignetteInfo.FindBestUniqueVignette(vignetteGUIDs) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_VignetteInfo.GetVignetteInfo)
---@param vignetteGUID string
---@return VignetteInfo? vignetteInfo
function C_VignetteInfo.GetVignetteInfo(vignetteGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_VignetteInfo.GetVignettePosition)
---@param vignetteGUID string
---@param uiMapID number
---@return Vector2DMixin? vignettePosition
function C_VignetteInfo.GetVignettePosition(vignetteGUID, uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_VignetteInfo.GetVignettes)
---@return string[] vignetteGUIDs
function C_VignetteInfo.GetVignettes() end

---@class VignetteInfo
---@field vignetteGUID string
---@field objectGUID string
---@field name string
---@field isDead boolean
---@field onWorldMap boolean
---@field zoneInfiniteAOI boolean
---@field onMinimap boolean
---@field isUnique boolean
---@field inFogOfWar boolean
---@field atlasName string
---@field hasTooltip boolean
---@field vignetteID number
---@field type VignetteType
---@field rewardQuestID number
---@field widgetSetID number|nil
