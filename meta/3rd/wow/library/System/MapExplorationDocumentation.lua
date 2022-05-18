---@meta
C_MapExplorationInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MapExplorationInfo.GetExploredAreaIDsAtPosition)
---@param uiMapID number
---@param normalizedPosition Vector2DMixin
---@return number[]? areaID
function C_MapExplorationInfo.GetExploredAreaIDsAtPosition(uiMapID, normalizedPosition) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_MapExplorationInfo.GetExploredMapTextures)
---@param uiMapID number
---@return UiMapExplorationInfo[] overlayInfo
function C_MapExplorationInfo.GetExploredMapTextures(uiMapID) end

---@class UiMapExplorationHitRect
---@field top number
---@field bottom number
---@field left number
---@field right number

---@class UiMapExplorationInfo
---@field textureWidth number
---@field textureHeight number
---@field offsetX number
---@field offsetY number
---@field isShownByMouseOver boolean
---@field fileDataIDs number[]
---@field hitRect UiMapExplorationHitRect
