---@meta

---@class cc.FastTMXTiledMap :cc.Node
local FastTMXTiledMap={ }
cc.FastTMXTiledMap=FastTMXTiledMap




---*  Set object groups. <br>
---* param groups An object groups.
---@param groups array_table
---@return self
function FastTMXTiledMap:setObjectGroups (groups) end
---*  Return the value for the specific property name.<br>
---* return Return the value for the specific property name.
---@param propertyName string
---@return cc.Value
function FastTMXTiledMap:getProperty (propertyName) end
---*  Set the map's size property measured in tiles.<br>
---* param mapSize The map's size property measured in tiles.
---@param mapSize size_table
---@return self
function FastTMXTiledMap:setMapSize (mapSize) end
---*  Return the TMXObjectGroup for the specific group. <br>
---* return Return the TMXObjectGroup for the specific group.
---@param groupName string
---@return cc.TMXObjectGroup
function FastTMXTiledMap:getObjectGroup (groupName) end
---@overload fun():self
---@overload fun():self
---@return array_table
function FastTMXTiledMap:getObjectGroups () end
---*  The tiles's size property measured in pixels.<br>
---* return The tiles's size property measured in pixels.
---@return size_table
function FastTMXTiledMap:getTileSize () end
---*  The map's size property measured in tiles. <br>
---* return The map's size property measured in tiles.
---@return size_table
function FastTMXTiledMap:getMapSize () end
---*  Get properties.<br>
---* return Properties.
---@return map_table
function FastTMXTiledMap:getProperties () end
---*  Return properties dictionary for tile GID.<br>
---* return Return properties dictionary for tile GID.
---@param GID int
---@return cc.Value
function FastTMXTiledMap:getPropertiesForGID (GID) end
---*  Set the tiles's size property measured in pixels. <br>
---* param tileSize The tiles's size property measured in pixels.
---@param tileSize size_table
---@return self
function FastTMXTiledMap:setTileSize (tileSize) end
---*  Set properties. <br>
---* param properties An ValueMap Properties.
---@param properties map_table
---@return self
function FastTMXTiledMap:setProperties (properties) end
---*  Return the FastTMXLayer for the specific layer. <br>
---* return Return the FastTMXLayer for the specific layer.
---@param layerName string
---@return cc.FastTMXLayer
function FastTMXTiledMap:getLayer (layerName) end
---*  Get map orientation. <br>
---* return The map orientation.
---@return int
function FastTMXTiledMap:getMapOrientation () end
---*  Set map orientation. <br>
---* param mapOrientation The map orientation.
---@param mapOrientation int
---@return self
function FastTMXTiledMap:setMapOrientation (mapOrientation) end
---*  Creates a TMX Tiled Map with a TMX file.<br>
---* return An autorelease object.
---@param tmxFile string
---@return self
function FastTMXTiledMap:create (tmxFile) end
---*  Initializes a TMX Tiled Map with a TMX formatted XML string and a path to TMX resources. <br>
---* param tmxString A TMX formatted XML string.<br>
---* param resourcePath A path to TMX resources.<br>
---* return An autorelease object.
---@param tmxString string
---@param resourcePath string
---@return self
function FastTMXTiledMap:createWithXML (tmxString,resourcePath) end
---* 
---@return string
function FastTMXTiledMap:getDescription () end