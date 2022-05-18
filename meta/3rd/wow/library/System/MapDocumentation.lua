---@meta
C_Map = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.CanSetUserWaypointOnMap)
---@param uiMapID number
---@return boolean canSet
function C_Map.CanSetUserWaypointOnMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.ClearUserWaypoint)
function C_Map.ClearUserWaypoint() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.CloseWorldMapInteraction)
function C_Map.CloseWorldMapInteraction() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetAreaInfo)
---@param areaID number
---@return string name
function C_Map.GetAreaInfo(areaID) end

---Only works for the player and party members.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetBestMapForUnit)
---@param unitToken string
---@return number? uiMapID
function C_Map.GetBestMapForUnit(unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetBountySetMaps)
---@param bountySetID number
---@return number[] mapIDs
function C_Map.GetBountySetMaps(bountySetID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetFallbackWorldMapID)
---@return number uiMapID
function C_Map.GetFallbackWorldMapID() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapArtBackgroundAtlas)
---@param uiMapID number
---@return string atlasName
function C_Map.GetMapArtBackgroundAtlas(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapArtHelpTextPosition)
---@param uiMapID number
---@return MapCanvasPosition position
function C_Map.GetMapArtHelpTextPosition(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapArtID)
---@param uiMapID number
---@return number uiMapArtID
function C_Map.GetMapArtID(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapArtLayerTextures)
---@param uiMapID number
---@param layerIndex number
---@return number[] textures
function C_Map.GetMapArtLayerTextures(uiMapID, layerIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapArtLayers)
---@param uiMapID number
---@return UiMapLayerInfo[] layerInfo
function C_Map.GetMapArtLayers(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapBannersForMap)
---@param uiMapID number
---@return MapBannerInfo[] mapBanners
function C_Map.GetMapBannersForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapChildrenInfo)
---@param uiMapID number
---@param mapType? UIMapType
---@param allDescendants? boolean
---@return UiMapDetails[] info
function C_Map.GetMapChildrenInfo(uiMapID, mapType, allDescendants) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapDisplayInfo)
---@param uiMapID number
---@return boolean hideIcons
function C_Map.GetMapDisplayInfo(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapGroupID)
---@param uiMapID number
---@return number uiMapGroupID
function C_Map.GetMapGroupID(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapGroupMembersInfo)
---@param uiMapGroupID number
---@return UiMapGroupMemberInfo[] info
function C_Map.GetMapGroupMembersInfo(uiMapGroupID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapHighlightInfoAtPosition)
---@param uiMapID number
---@param x number
---@param y number
---@return number fileDataID
---@return string atlasID
---@return number texturePercentageX
---@return number texturePercentageY
---@return number textureX
---@return number textureY
---@return number scrollChildX
---@return number scrollChildY
function C_Map.GetMapHighlightInfoAtPosition(uiMapID, x, y) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapInfo)
---@param uiMapID number
---@return UiMapDetails info
function C_Map.GetMapInfo(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapInfoAtPosition)
---@param uiMapID number
---@param x number
---@param y number
---@return UiMapDetails info
function C_Map.GetMapInfoAtPosition(uiMapID, x, y) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapLevels)
---@param uiMapID number
---@return number playerMinLevel
---@return number playerMaxLevel
---@return number petMinLevel
---@return number petMaxLevel
function C_Map.GetMapLevels(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapLinksForMap)
---@param uiMapID number
---@return MapLinkInfo[] mapLinks
function C_Map.GetMapLinksForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapPosFromWorldPos)
---@param continentID number
---@param worldPosition Vector2DMixin
---@param overrideUiMapID? number
---@return number uiMapID
---@return Vector2DMixin mapPosition
function C_Map.GetMapPosFromWorldPos(continentID, worldPosition, overrideUiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapRectOnMap)
---@param uiMapID number
---@param topUiMapID number
---@return number minX
---@return number maxX
---@return number minY
---@return number maxY
function C_Map.GetMapRectOnMap(uiMapID, topUiMapID) end

---Returns the size in yards of the area represented by the map.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetMapWorldSize)
---@param uiMapID number
---@return number width
---@return number height
function C_Map.GetMapWorldSize(uiMapID) end

---Only works for the player and party members.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetPlayerMapPosition)
---@param uiMapID number
---@param unitToken string
---@return Vector2DMixin? position
function C_Map.GetPlayerMapPosition(uiMapID, unitToken) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetUserWaypoint)
---@return table point
function C_Map.GetUserWaypoint() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetUserWaypointFromHyperlink)
---@param hyperlink string
---@return table point
function C_Map.GetUserWaypointFromHyperlink(hyperlink) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetUserWaypointHyperlink)
---@return string hyperlink
function C_Map.GetUserWaypointHyperlink() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetUserWaypointPositionForMap)
---@param uiMapID number
---@return Vector2DMixin mapPosition
function C_Map.GetUserWaypointPositionForMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.GetWorldPosFromMapPos)
---@param uiMapID number
---@param mapPosition Vector2DMixin
---@return number continentID
---@return Vector2DMixin worldPosition
function C_Map.GetWorldPosFromMapPos(uiMapID, mapPosition) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.HasUserWaypoint)
---@return boolean hasUserWaypoint
function C_Map.HasUserWaypoint() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.IsMapValidForNavBarDropDown)
---@param uiMapID number
---@return boolean isValid
function C_Map.IsMapValidForNavBarDropDown(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.MapHasArt)
---@param uiMapID number
---@return boolean hasArt
function C_Map.MapHasArt(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.RequestPreloadMap)
---@param uiMapID number
function C_Map.RequestPreloadMap(uiMapID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Map.SetUserWaypoint)
---@param point table
function C_Map.SetUserWaypoint(point) end

---@class MapBannerInfo
---@field areaPoiID number
---@field name string
---@field atlasName string
---@field uiTextureKit string|nil

---@class MapLinkInfo
---@field areaPoiID number
---@field position Vector2DMixin
---@field name string
---@field atlasName string
---@field linkedUiMapID number

---@class UiMapDetails
---@field mapID number
---@field name string
---@field mapType UIMapType
---@field parentMapID number
---@field flags number

---@class UiMapGroupMemberInfo
---@field mapID number
---@field relativeHeightIndex number
---@field name string

---@class UiMapLayerInfo
---@field layerWidth number
---@field layerHeight number
---@field tileWidth number
---@field tileHeight number
---@field minScale number
---@field maxScale number
---@field additionalZoomSteps number
