---@meta

---@class cc.TMXTiledMap :cc.Node
local TMXTiledMap={ }
cc.TMXTiledMap=TMXTiledMap




---*  Set the object groups. <br>
---* param groups The object groups.
---@param groups array_table
---@return self
function TMXTiledMap:setObjectGroups (groups) end
---*  Return the value for the specific property name. <br>
---* param propertyName The specific property name.<br>
---* return Return the value for the specific property name.
---@param propertyName string
---@return cc.Value
function TMXTiledMap:getProperty (propertyName) end
---* 
---@return int
function TMXTiledMap:getLayerNum () end
---*  Set the map's size property measured in tiles. <br>
---* param mapSize The map's size property measured in tiles.
---@param mapSize size_table
---@return self
function TMXTiledMap:setMapSize (mapSize) end
---*  Return the TMXObjectGroup for the specific group. <br>
---* param groupName The group Name.<br>
---* return A Type of TMXObjectGroup.
---@param groupName string
---@return cc.TMXObjectGroup
function TMXTiledMap:getObjectGroup (groupName) end
---@overload fun():self
---@overload fun():self
---@return array_table
function TMXTiledMap:getObjectGroups () end
---* 
---@return string
function TMXTiledMap:getResourceFile () end
---*  initializes a TMX Tiled Map with a TMX file 
---@param tmxFile string
---@return boolean
function TMXTiledMap:initWithTMXFile (tmxFile) end
---*  The tiles's size property measured in pixels. <br>
---* return The tiles's size property measured in pixels.
---@return size_table
function TMXTiledMap:getTileSize () end
---*  The map's size property measured in tiles. <br>
---* return The map's size property measured in tiles.
---@return size_table
function TMXTiledMap:getMapSize () end
---*  initializes a TMX Tiled Map with a TMX formatted XML string and a path to TMX resources 
---@param tmxString string
---@param resourcePath string
---@return boolean
function TMXTiledMap:initWithXML (tmxString,resourcePath) end
---*  Properties. <br>
---* return Properties.
---@return map_table
function TMXTiledMap:getProperties () end
---*  Set the tiles's size property measured in pixels. <br>
---* param tileSize The tiles's size property measured in pixels.
---@param tileSize size_table
---@return self
function TMXTiledMap:setTileSize (tileSize) end
---*  Set the properties.<br>
---* param properties A  Type of ValueMap to set the properties.
---@param properties map_table
---@return self
function TMXTiledMap:setProperties (properties) end
---*  Return the TMXLayer for the specific layer. <br>
---* param layerName A specific layer.<br>
---* return The TMXLayer for the specific layer.
---@param layerName string
---@return cc.TMXLayer
function TMXTiledMap:getLayer (layerName) end
---*  Map orientation. <br>
---* return Map orientation.
---@return int
function TMXTiledMap:getMapOrientation () end
---*  Set map orientation. <br>
---* param mapOrientation The map orientation.
---@param mapOrientation int
---@return self
function TMXTiledMap:setMapOrientation (mapOrientation) end
---*  Creates a TMX Tiled Map with a TMX file.<br>
---* param tmxFile A TMX file.<br>
---* return An autorelease object.
---@param tmxFile string
---@return self
function TMXTiledMap:create (tmxFile) end
---*  Initializes a TMX Tiled Map with a TMX formatted XML string and a path to TMX resources. <br>
---* param tmxString A TMX formatted XML string.<br>
---* param resourcePath The path to TMX resources.<br>
---* return An autorelease object.<br>
---* js NA
---@param tmxString string
---@param resourcePath string
---@return self
function TMXTiledMap:createWithXML (tmxString,resourcePath) end
---*  Get the description.<br>
---* js NA
---@return string
function TMXTiledMap:getDescription () end
---* js ctor
---@return self
function TMXTiledMap:TMXTiledMap () end