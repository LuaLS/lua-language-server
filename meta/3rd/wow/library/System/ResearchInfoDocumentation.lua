---@meta
C_ResearchInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ResearchInfo.GetDigSitesForMap)
---@param uiMapID number
---@return DigSiteMapInfo[] digSites
function C_ResearchInfo.GetDigSitesForMap(uiMapID) end

---@class DigSiteMapInfo
---@field researchSiteID number
---@field position Vector2DMixin
---@field name string
---@field textureIndex number
