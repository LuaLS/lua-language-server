---@meta

---@class cc.FastTMXLayer :cc.Node
local FastTMXLayer={ }
cc.FastTMXLayer=FastTMXLayer




---*  Returns the position in points of a given tile coordinate.<br>
---* param tileCoordinate The tile Coordinate.<br>
---* return The position in points of a given tile coordinate.
---@param tileCoordinate vec2_table
---@return vec2_table
function FastTMXLayer:getPositionAt (tileCoordinate) end
---*  Set Layer orientation, which is the same as the map orientation. <br>
---* param orientation Layer orientation, which is the same as the map orientation.
---@param orientation int
---@return self
function FastTMXLayer:setLayerOrientation (orientation) end
---*  Size of the layer in tiles.<br>
---* return Size of the layer in tiles.
---@return size_table
function FastTMXLayer:getLayerSize () end
---*  Set the size of the map's tile. <br>
---* param size The new size of the map's tile.
---@param size size_table
---@return self
function FastTMXLayer:setMapTileSize (size) end
---*  Layer orientation, which is the same as the map orientation.<br>
---* return Layer orientation, which is the same as the map orientation.
---@return int
function FastTMXLayer:getLayerOrientation () end
---*  Set the properties to the layer.<br>
---* param properties The properties to the layer.
---@param properties map_table
---@return self
function FastTMXLayer:setProperties (properties) end
---*  Set the tile layer name.<br>
---* param layerName The new layer name.
---@param layerName string
---@return self
function FastTMXLayer:setLayerName (layerName) end
---*  Removes a tile at given tile coordinate.<br>
---* param tileCoordinate The tile Coordinate.
---@param tileCoordinate vec2_table
---@return self
function FastTMXLayer:removeTileAt (tileCoordinate) end
---@overload fun():self
---@overload fun():self
---@return map_table
function FastTMXLayer:getProperties () end
---*  Creates the tiles. 
---@return self
function FastTMXLayer:setupTiles () end
---*  Set an sprite to the tile,with the tile coordinate and gid.<br>
---* param sprite A Sprite.<br>
---* param pos The tile coordinate.<br>
---* param gid The tile gid.
---@param sprite cc.Sprite
---@param pos vec2_table
---@param gid unsigned_int
---@return self
function FastTMXLayer:setupTileSprite (sprite,pos,gid) end
---@overload fun(int:int,vec2_table:vec2_table,int:int):self
---@overload fun(int:int,vec2_table:vec2_table):self
---@param gid int
---@param tileCoordinate vec2_table
---@param flags int
---@return self
function FastTMXLayer:setTileGID (gid,tileCoordinate,flags) end
---*  Size of the map's tile (could be different from the tile's size).<br>
---* return Size of the map's tile (could be different from the tile's size).
---@return size_table
function FastTMXLayer:getMapTileSize () end
---*  Return the value for the specific property name.<br>
---* param propertyName The value for the specific property name.<br>
---* return The value for the specific property name.
---@param propertyName string
---@return cc.Value
function FastTMXLayer:getProperty (propertyName) end
---*  Set the size of the layer in tiles. <br>
---* param size The new size of the layer in tiles.
---@param size size_table
---@return self
function FastTMXLayer:setLayerSize (size) end
---*  Get the tile layer name.<br>
---* return The tile layer name.
---@return string
function FastTMXLayer:getLayerName () end
---*  Set the tileset information for the layer. <br>
---* param info The new tileset information for the layer.
---@param info cc.TMXTilesetInfo
---@return self
function FastTMXLayer:setTileSet (info) end
---*  Tileset information for the layer.<br>
---* return Tileset information for the layer.
---@return cc.TMXTilesetInfo
function FastTMXLayer:getTileSet () end
---*  Returns the tile (Sprite) at a given a tile coordinate.<br>
---* The returned Sprite will be already added to the TMXLayer. Don't add it again.<br>
---* The Sprite can be treated like any other Sprite: rotated, scaled, translated, opacity, color, etc.<br>
---* You can remove either by calling:<br>
---* - layer->removeChild(sprite, cleanup);<br>
---* return Returns the tile (Sprite) at a given a tile coordinate.
---@param tileCoordinate vec2_table
---@return cc.Sprite
function FastTMXLayer:getTileAt (tileCoordinate) end
---*  Creates a FastTMXLayer with an tileset info, a layer info and a map info.<br>
---* param tilesetInfo An tileset info.<br>
---* param layerInfo A layer info.<br>
---* param mapInfo A map info.<br>
---* return Return an autorelease object.
---@param tilesetInfo cc.TMXTilesetInfo
---@param layerInfo cc.TMXLayerInfo
---@param mapInfo cc.TMXMapInfo
---@return self
function FastTMXLayer:create (tilesetInfo,layerInfo,mapInfo) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function FastTMXLayer:removeChild (child,cleanup) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function FastTMXLayer:draw (renderer,transform,flags) end
---* 
---@return string
function FastTMXLayer:getDescription () end
---* js ctor
---@return self
function FastTMXLayer:FastTMXLayer () end