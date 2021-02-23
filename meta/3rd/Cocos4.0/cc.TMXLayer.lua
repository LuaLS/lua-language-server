---@meta

---@class cc.TMXLayer :cc.SpriteBatchNode
local TMXLayer={ }
cc.TMXLayer=TMXLayer




---*  Returns the position in points of a given tile coordinate.<br>
---* param tileCoordinate The tile coordinate.<br>
---* return The position in points of a given tile coordinate.
---@param tileCoordinate vec2_table
---@return vec2_table
function TMXLayer:getPositionAt (tileCoordinate) end
---*  Set layer orientation, which is the same as the map orientation.<br>
---* param orientation Layer orientation,which is the same as the map orientation.
---@param orientation int
---@return self
function TMXLayer:setLayerOrientation (orientation) end
---*  Dealloc the map that contains the tile position from memory.<br>
---* Unless you want to know at runtime the tiles positions, you can safely call this method.<br>
---* If you are going to call layer->tileGIDAt() then, don't release the map.
---@return self
function TMXLayer:releaseMap () end
---*  Size of the layer in tiles.<br>
---* return Size of the layer in tiles.
---@return size_table
function TMXLayer:getLayerSize () end
---*  Set the size of the map's tile.<br>
---* param size The size of the map's tile.
---@param size size_table
---@return self
function TMXLayer:setMapTileSize (size) end
---*  Layer orientation, which is the same as the map orientation.<br>
---* return Layer orientation, which is the same as the map orientation.
---@return int
function TMXLayer:getLayerOrientation () end
---*  Set an Properties from to layer.<br>
---* param properties It is used to set the layer Properties.
---@param properties map_table
---@return self
function TMXLayer:setProperties (properties) end
---*  Set the layer name.<br>
---* param layerName The layer name.
---@param layerName string
---@return self
function TMXLayer:setLayerName (layerName) end
---*  Removes a tile at given tile coordinate. <br>
---* param tileCoordinate The tile coordinate.
---@param tileCoordinate vec2_table
---@return self
function TMXLayer:removeTileAt (tileCoordinate) end
---*  Initializes a TMXLayer with a tileset info, a layer info and a map info.<br>
---* param tilesetInfo An tileset info.<br>
---* param layerInfo A layer info.<br>
---* param mapInfo A map info.<br>
---* return If initializes successfully, it will return true.
---@param tilesetInfo cc.TMXTilesetInfo
---@param layerInfo cc.TMXLayerInfo
---@param mapInfo cc.TMXMapInfo
---@return boolean
function TMXLayer:initWithTilesetInfo (tilesetInfo,layerInfo,mapInfo) end
---*  Creates the tiles. 
---@return self
function TMXLayer:setupTiles () end
---@overload fun(unsigned_int:unsigned_int,vec2_table:vec2_table,int:int):self
---@overload fun(unsigned_int:unsigned_int,vec2_table:vec2_table):self
---@param gid unsigned_int
---@param tileCoordinate vec2_table
---@param flags int
---@return self
function TMXLayer:setTileGID (gid,tileCoordinate,flags) end
---*  Size of the map's tile (could be different from the tile's size).<br>
---* return The size of the map's tile.
---@return size_table
function TMXLayer:getMapTileSize () end
---*  Return the value for the specific property name.<br>
---* param propertyName The specific property name.<br>
---* return Return the value for the specific property name.
---@param propertyName string
---@return cc.Value
function TMXLayer:getProperty (propertyName) end
---*  Set size of the layer in tiles.<br>
---* param size Size of the layer in tiles.
---@param size size_table
---@return self
function TMXLayer:setLayerSize (size) end
---*  Get the layer name. <br>
---* return The layer name.
---@return string
function TMXLayer:getLayerName () end
---*  Set tileset information for the layer.<br>
---* param info The tileset information for the layer.<br>
---* js NA
---@param info cc.TMXTilesetInfo
---@return self
function TMXLayer:setTileSet (info) end
---*  Tileset information for the layer. <br>
---* return Tileset information for the layer.
---@return cc.TMXTilesetInfo
function TMXLayer:getTileSet () end
---@overload fun():self
---@overload fun():self
---@return map_table
function TMXLayer:getProperties () end
---*  Returns the tile (Sprite) at a given a tile coordinate.<br>
---* The returned Sprite will be already added to the TMXLayer. Don't add it again.<br>
---* The Sprite can be treated like any other Sprite: rotated, scaled, translated, opacity, color, etc.<br>
---* You can remove either by calling:<br>
---* - layer->removeChild(sprite, cleanup);<br>
---* - or layer->removeTileAt(Vec2(x,y));<br>
---* param tileCoordinate A tile coordinate.<br>
---* return Returns the tile (Sprite) at a given a tile coordinate.
---@param tileCoordinate vec2_table
---@return cc.Sprite
function TMXLayer:getTileAt (tileCoordinate) end
---*  Creates a TMXLayer with an tileset info, a layer info and a map info.<br>
---* param tilesetInfo An tileset info.<br>
---* param layerInfo A layer info.<br>
---* param mapInfo A map info.<br>
---* return An autorelease object.
---@param tilesetInfo cc.TMXTilesetInfo
---@param layerInfo cc.TMXLayerInfo
---@param mapInfo cc.TMXMapInfo
---@return self
function TMXLayer:create (tilesetInfo,layerInfo,mapInfo) end
---* 
---@param child cc.Node
---@param zOrder int
---@param tag int
---@return self
function TMXLayer:addChild (child,zOrder,tag) end
---* js NA
---@return string
function TMXLayer:getDescription () end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function TMXLayer:removeChild (child,cleanup) end
---* js ctor
---@return self
function TMXLayer:TMXLayer () end