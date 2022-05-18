---@meta
C_TaxiMap = {}

---Returns information on taxi nodes at the current flight master.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaxiMap.GetAllTaxiNodes)
---@param uiMapID number
---@return TaxiNodeInfo[] taxiNodes
function C_TaxiMap.GetAllTaxiNodes(uiMapID) end

---Returns information on taxi nodes for a given map, without considering the current flight master.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaxiMap.GetTaxiNodesForMap)
---@param uiMapID number
---@return MapTaxiNodeInfo[] mapTaxiNodes
function C_TaxiMap.GetTaxiNodesForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TaxiMap.ShouldMapShowTaxiNodes)
---@param uiMapID number
---@return boolean shouldShowNodes
function C_TaxiMap.ShouldMapShowTaxiNodes(uiMapID) end

---@class MapTaxiNodeInfo
---@field nodeID number
---@field position Vector2DMixin
---@field name string
---@field atlasName string
---@field faction FlightPathFaction
---@field textureKit string

---@class TaxiNodeInfo
---@field nodeID number
---@field position Vector2DMixin
---@field name string
---@field state FlightPathState
---@field slotIndex number
---@field textureKit string
---@field useSpecialIcon boolean
---@field specialIconCostString string|nil
