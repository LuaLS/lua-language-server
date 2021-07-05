---@meta

---@class cc.AtlasNode :cc.Node@all parent class: Node,TextureProtocol
local AtlasNode={ }
cc.AtlasNode=AtlasNode




---* lua NA
---@return cc.BlendFunc
function AtlasNode:getBlendFunc () end
---*  Initializes an AtlasNode  with an Atlas file the width and height of each item and the quantity of items to render
---@param tile string
---@param tileWidth int
---@param tileHeight int
---@param itemsToRender int
---@return boolean
function AtlasNode:initWithTileFile (tile,tileWidth,tileHeight,itemsToRender) end
---* code<br>
---* When this function bound into js or lua,the parameter will be changed<br>
---* In js: var setBlendFunc(var src, var dst)<br>
---* endcode<br>
---* lua NA
---@param blendFunc cc.BlendFunc
---@return self
function AtlasNode:setBlendFunc (blendFunc) end
---*  Set an buffer manager of the texture vertex. 
---@param textureAtlas cc.TextureAtlas
---@return self
function AtlasNode:setTextureAtlas (textureAtlas) end
---* 
---@return cc.Texture2D
function AtlasNode:getTexture () end
---*  Return the buffer manager of the texture vertex. <br>
---* return Return A TextureAtlas.
---@return cc.TextureAtlas
function AtlasNode:getTextureAtlas () end
---*  updates the Atlas (indexed vertex array).<br>
---* Shall be overridden in subclasses.
---@return self
function AtlasNode:updateAtlasValues () end
---* 
---@param texture cc.Texture2D
---@return self
function AtlasNode:setTexture (texture) end
---*  Initializes an AtlasNode  with a texture the width and height of each item measured in points and the quantity of items to render
---@param texture cc.Texture2D
---@param tileWidth int
---@param tileHeight int
---@param itemsToRender int
---@return boolean
function AtlasNode:initWithTexture (texture,tileWidth,tileHeight,itemsToRender) end
---* 
---@return unsigned_int
function AtlasNode:getQuadsToDraw () end
---* 
---@param quadsToDraw int
---@return self
function AtlasNode:setQuadsToDraw (quadsToDraw) end
---*  creates a AtlasNode  with an Atlas file the width and height of each item and the quantity of items to render.<br>
---* param filename The path of Atlas file.<br>
---* param tileWidth The width of the item.<br>
---* param tileHeight The height of the item.<br>
---* param itemsToRender The quantity of items to render.
---@param filename string
---@param tileWidth int
---@param tileHeight int
---@param itemsToRender int
---@return self
function AtlasNode:create (filename,tileWidth,tileHeight,itemsToRender) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function AtlasNode:draw (renderer,transform,flags) end
---* 
---@return boolean
function AtlasNode:isOpacityModifyRGB () end
---* 
---@param color color3b_table
---@return self
function AtlasNode:setColor (color) end
---* 
---@return color3b_table
function AtlasNode:getColor () end
---* 
---@param isOpacityModifyRGB boolean
---@return self
function AtlasNode:setOpacityModifyRGB (isOpacityModifyRGB) end
---* 
---@param opacity unsigned_char
---@return self
function AtlasNode:setOpacity (opacity) end
---* 
---@return self
function AtlasNode:AtlasNode () end