---@meta

---@class cc.Sprite :cc.Node@all parent class: Node,TextureProtocol
local Sprite={ }
cc.Sprite=Sprite




---@overload fun(string0:cc.SpriteFrame):self
---@overload fun(string:string):self
---@param spriteFrameName string
---@return self
function Sprite:setSpriteFrame (spriteFrameName) end
---@overload fun(string0:cc.Texture2D):self
---@overload fun(string:string):self
---@param filename string
---@return self
function Sprite:setTexture (filename) end
---*  Returns the Texture2D object used by the sprite. 
---@return cc.Texture2D
function Sprite:getTexture () end
---* Sets whether the sprite should be flipped vertically or not.<br>
---* param flippedY true if the sprite should be flipped vertically, false otherwise.
---@param flippedY boolean
---@return self
function Sprite:setFlippedY (flippedY) end
---* Sets whether the sprite should be flipped horizontally or not.<br>
---* param flippedX true if the sprite should be flipped horizontally, false otherwise.
---@param flippedX boolean
---@return self
function Sprite:setFlippedX (flippedX) end
---* / @}
---@return int
function Sprite:getResourceType () end
---* / @{/ @name Animation methods<br>
---* Changes the display frame with animation name and index.<br>
---* The animation name will be get from the AnimationCache.
---@param animationName string
---@param frameIndex unsigned_int
---@return self
function Sprite:setDisplayFrameWithAnimationName (animationName,frameIndex) end
---* Returns the batch node object if this sprite is rendered by SpriteBatchNode.<br>
---* return The SpriteBatchNode object if this sprite is rendered by SpriteBatchNode,<br>
---* nullptr if the sprite isn't used batch node.
---@return cc.SpriteBatchNode
function Sprite:getBatchNode () end
---* Gets the offset position of the sprite. Calculated automatically by editors like Zwoptex.
---@return vec2_table
function Sprite:getOffsetPosition () end
---* brief Returns the Cap Insets rect<br>
---* return Scale9Sprite's cap inset.
---@return rect_table
function Sprite:getCenterRect () end
---* setCenterRectNormalized<br>
---* Useful to implement "9 sliced" sprites.<br>
---* The default value is (0,0) - (1,1), which means that only one "slice" will be used: From top-left (0,0) to bottom-right (1,1).<br>
---* If the value is different than (0,0), (1,1), then the sprite will be sliced into a 3 x 3 grid. The four corners of this grid are applied without<br>
---* performing any scaling. The upper- and lower-middle parts are scaled horizontally, and the left- and right-middle parts are scaled vertically.<br>
---* The center is scaled in both directions.<br>
---* Important: The scaling is based the Sprite's trimmed size.<br>
---* Limitations: Does not work when the sprite is part of `SpriteBatchNode`.
---@param rect rect_table
---@return self
function Sprite:setCenterRectNormalized (rect) end
---*  returns whether or not contentSize stretches the sprite's texture 
---@return boolean
function Sprite:isStretchEnabled () end
---@overload fun(rect_table:rect_table,boolean:boolean,size_table:size_table):self
---@overload fun(rect_table:rect_table):self
---@param rect rect_table
---@param rotated boolean
---@param untrimmedSize size_table
---@return self
function Sprite:setTextureRect (rect,rotated,untrimmedSize) end
---* Initializes a sprite with an sprite frame name.<br>
---* A SpriteFrame will be fetched from the SpriteFrameCache by name.<br>
---* If the SpriteFrame doesn't exist it will raise an exception.<br>
---* param   spriteFrameName  A key string that can fetched a valid SpriteFrame from SpriteFrameCache.<br>
---* return  True if the sprite is initialized properly, false otherwise.
---@param spriteFrameName string
---@return boolean
function Sprite:initWithSpriteFrameName (spriteFrameName) end
---*  whether or not contentSize stretches the sprite's texture 
---@param enabled boolean
---@return self
function Sprite:setStretchEnabled (enabled) end
---* Returns whether or not a SpriteFrame is being displayed.
---@param frame cc.SpriteFrame
---@return boolean
function Sprite:isFrameDisplayed (frame) end
---* Returns the index used on the TextureAtlas.
---@return unsigned_int
function Sprite:getAtlasIndex () end
---* Sets the weak reference of the TextureAtlas when the sprite is rendered using via SpriteBatchNode.
---@param textureAtlas cc.TextureAtlas
---@return self
function Sprite:setTextureAtlas (textureAtlas) end
---* Sets the batch node to sprite.<br>
---* warning This method is not recommended for game developers. Sample code for using batch node<br>
---* code<br>
---* SpriteBatchNode *batch = SpriteBatchNode::create("Images/grossini_dance_atlas.png", 15);<br>
---* Sprite *sprite = Sprite::createWithTexture(batch->getTexture(), Rect(0, 0, 57, 57));<br>
---* batch->addChild(sprite);<br>
---* layer->addChild(batch);<br>
---* endcode
---@param spriteBatchNode cc.SpriteBatchNode
---@return self
function Sprite:setBatchNode (spriteBatchNode) end
---* js  NA<br>
---* lua NA
---@return cc.BlendFunc
function Sprite:getBlendFunc () end
---* 
---@param rect rect_table
---@return self
function Sprite:setCenterRect (rect) end
---* Returns the current displayed frame.
---@return cc.SpriteFrame
function Sprite:getSpriteFrame () end
---* 
---@return self
function Sprite:setVertexLayout () end
---* 
---@param cleanup boolean
---@return self
function Sprite:removeAllChildrenWithCleanup (cleanup) end
---* 
---@return string
function Sprite:getResourceName () end
---* Whether or not the Sprite needs to be updated in the Atlas.<br>
---* return True if the sprite needs to be updated in the Atlas, false otherwise.
---@return boolean
function Sprite:isDirty () end
---* getCenterRectNormalized<br>
---* Returns the CenterRect in normalized coordinates
---@return rect_table
function Sprite:getCenterRectNormalized () end
---* Sets the index used on the TextureAtlas.<br>
---* warning Don't modify this value unless you know what you are doing.
---@param atlasIndex unsigned_int
---@return self
function Sprite:setAtlasIndex (atlasIndex) end
---@overload fun(cc.Texture2D:cc.Texture2D,rect_table:rect_table):self
---@overload fun(cc.Texture2D:cc.Texture2D):self
---@overload fun(cc.Texture2D:cc.Texture2D,rect_table:rect_table,boolean:boolean):self
---@param texture cc.Texture2D
---@param rect rect_table
---@param rotated boolean
---@return boolean
function Sprite:initWithTexture (texture,rect,rotated) end
---* Makes the Sprite to be updated in the Atlas.
---@param dirty boolean
---@return self
function Sprite:setDirty (dirty) end
---* Returns whether or not the texture rectangle is rotated.
---@return boolean
function Sprite:isTextureRectRotated () end
---* Returns the rect of the Sprite in points.
---@return rect_table
function Sprite:getTextureRect () end
---@overload fun(string:string,rect_table:rect_table):self
---@overload fun(string:string):self
---@param filename string
---@param rect rect_table
---@return boolean
function Sprite:initWithFile (filename,rect) end
---* / @{/ @name Functions inherited from TextureProtocol.<br>
---* code<br>
---* When this function bound into js or lua,the parameter will be changed.<br>
---* In js: var setBlendFunc(var src, var dst).<br>
---* In lua: local setBlendFunc(local src, local dst).<br>
---* endcode
---@param blendFunc cc.BlendFunc
---@return self
function Sprite:setBlendFunc (blendFunc) end
---* 
---@param vert char
---@param frag char
---@return self
function Sprite:updateShaders (vert,frag) end
---* Gets the weak reference of the TextureAtlas when the sprite is rendered using via SpriteBatchNode.
---@return cc.TextureAtlas
function Sprite:getTextureAtlas () end
---* Initializes a sprite with an SpriteFrame. The texture and rect in SpriteFrame will be applied on this sprite.<br>
---* param   spriteFrame  A SpriteFrame object. It should includes a valid texture and a rect.<br>
---* return  True if the sprite is initialized properly, false otherwise.
---@param spriteFrame cc.SpriteFrame
---@return boolean
function Sprite:initWithSpriteFrame (spriteFrame) end
---* Returns the flag which indicates whether the sprite is flipped horizontally or not.<br>
---* It only flips the texture of the sprite, and not the texture of the sprite's children.<br>
---* Also, flipping the texture doesn't alter the anchorPoint.<br>
---* If you want to flip the anchorPoint too, and/or to flip the children too use:<br>
---* sprite->setScaleX(sprite->getScaleX() * -1);<br>
---* return true if the sprite is flipped horizontally, false otherwise.
---@return boolean
function Sprite:isFlippedX () end
---* Return the flag which indicates whether the sprite is flipped vertically or not.<br>
---* It only flips the texture of the sprite, and not the texture of the sprite's children.<br>
---* Also, flipping the texture doesn't alter the anchorPoint.<br>
---* If you want to flip the anchorPoint too, and/or to flip the children too use:<br>
---* sprite->setScaleY(sprite->getScaleY() * -1);<br>
---* return true if the sprite is flipped vertically, false otherwise.
---@return boolean
function Sprite:isFlippedY () end
---* Sets the vertex rect.<br>
---* It will be called internally by setTextureRect.<br>
---* Useful if you want to create 2x images from SD images in Retina Display.<br>
---* Do not call it manually. Use setTextureRect instead.
---@param rect rect_table
---@return self
function Sprite:setVertexRect (rect) end
---@overload fun(cc.Texture2D:cc.Texture2D,rect_table:rect_table,boolean:boolean):self
---@overload fun(cc.Texture2D:cc.Texture2D):self
---@param texture cc.Texture2D
---@param rect rect_table
---@param rotated boolean
---@return self
function Sprite:createWithTexture (texture,rect,rotated) end
---* Creates a sprite with an sprite frame name.<br>
---* A SpriteFrame will be fetched from the SpriteFrameCache by spriteFrameName param.<br>
---* If the SpriteFrame doesn't exist it will raise an exception.<br>
---* param   spriteFrameName The name of sprite frame.<br>
---* return  An autoreleased sprite object.
---@param spriteFrameName string
---@return self
function Sprite:createWithSpriteFrameName (spriteFrameName) end
---* Creates a sprite with an sprite frame.<br>
---* param   spriteFrame    A sprite frame which involves a texture and a rect.<br>
---* return  An autoreleased sprite object.
---@param spriteFrame cc.SpriteFrame
---@return self
function Sprite:createWithSpriteFrame (spriteFrame) end
---@overload fun(cc.Node:cc.Node,int:int,int2:string):self
---@overload fun(cc.Node:cc.Node,int:int,int:int):self
---@param child cc.Node
---@param zOrder int
---@param tag int
---@return self
function Sprite:addChild (child,zOrder,tag) end
---* 
---@param anchor vec2_table
---@return self
function Sprite:setAnchorPoint (anchor) end
---* 
---@param rotationX float
---@return self
function Sprite:setRotationSkewX (rotationX) end
---* 
---@param scaleY float
---@return self
function Sprite:setScaleY (scaleY) end
---@overload fun(float:float):self
---@overload fun(float:float,float:float):self
---@param scaleX float
---@param scaleY float
---@return self
function Sprite:setScale (scaleX,scaleY) end
---* Set ProgramState
---@param programState cc.backend.ProgramState
---@return self
function Sprite:setProgramState (programState) end
---* 
---@param size size_table
---@return self
function Sprite:setContentSize (size) end
---* 
---@return boolean
function Sprite:isOpacityModifyRGB () end
---* 
---@param modify boolean
---@return self
function Sprite:setOpacityModifyRGB (modify) end
---* 
---@return boolean
function Sprite:init () end
---* 
---@param rotation float
---@return self
function Sprite:setRotation (rotation) end
---* 
---@param value boolean
---@return self
function Sprite:setIgnoreAnchorPointForPosition (value) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Sprite:draw (renderer,transform,flags) end
---* / @{/ @name Functions inherited from Node.
---@param scaleX float
---@return self
function Sprite:setScaleX (scaleX) end
---* js NA
---@return string
function Sprite:getDescription () end
---* 
---@param rotationY float
---@return self
function Sprite:setRotationSkewY (rotationY) end
---* Get current ProgramState
---@return cc.backend.ProgramState
function Sprite:getProgramState () end
---* 
---@return self
function Sprite:sortAllChildren () end
---* 
---@param child cc.Node
---@param zOrder int
---@return self
function Sprite:reorderChild (child,zOrder) end
---* 
---@param positionZ float
---@return self
function Sprite:setPositionZ (positionZ) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function Sprite:removeChild (child,cleanup) end
---* Updates the quad according the rotation, position, scale values.
---@return self
function Sprite:updateTransform () end
---* 
---@param sx float
---@return self
function Sprite:setSkewX (sx) end
---* 
---@param sy float
---@return self
function Sprite:setSkewY (sy) end
---* 
---@param bVisible boolean
---@return self
function Sprite:setVisible (bVisible) end
---* js ctor
---@return self
function Sprite:Sprite () end