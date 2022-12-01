---@meta

---@class ccui.Scale9Sprite :cc.Sprite
local Scale9Sprite={ }
ccui.Scale9Sprite=Scale9Sprite




---@overload fun(cc.Sprite:cc.Sprite,rect_table:rect_table,boolean:boolean,vec2_table:vec2_table,size_table:size_table,rect_table:rect_table):self
---@overload fun(cc.Sprite:cc.Sprite,rect_table:rect_table,boolean:boolean,vec2_table3:rect_table):self
---@param sprite cc.Sprite
---@param rect rect_table
---@param rotated boolean
---@param offset vec2_table
---@param originalSize size_table
---@param capInsets rect_table
---@return boolean
function Scale9Sprite:updateWithSprite (sprite,rect,rotated,offset,originalSize,capInsets) end
---* Creates and returns a new sprite object with the specified cap insets.<br>
---* You use this method to add cap insets to a sprite or to change the existing<br>
---* cap insets of a sprite. In both cases, you get back a new image and the<br>
---* original sprite remains untouched.<br>
---* param capInsets The values to use for the cap insets.<br>
---* return A Scale9Sprite instance.
---@param capInsets rect_table
---@return self
function Scale9Sprite:resizableSpriteWithCapInsets (capInsets) end
---* Returns the Cap Insets
---@return rect_table
function Scale9Sprite:getCapInsets () end
---* Change the state of 9-slice sprite.<br>
---* see `State`<br>
---* param state A enum value in State.<br>
---* since v3.4
---@param state int
---@return self
function Scale9Sprite:setState (state) end
---* brief Change the bottom sprite's cap inset.<br>
---* param bottomInset The values to use for the cap inset.
---@param bottomInset float
---@return self
function Scale9Sprite:setInsetBottom (bottomInset) end
---* Initializes a 9-slice sprite with an sprite frame name and with the specified<br>
---* cap insets.<br>
---* Once the sprite is created, you can then call its "setContentSize:" method<br>
---* to resize the sprite will all it's 9-slice goodness interact.<br>
---* It respects the anchorPoint too.<br>
---* param spriteFrameName The sprite frame name.<br>
---* param capInsets The values to use for the cap insets.<br>
---* return True if initializes success, false otherwise.
---@param spriteFrameName string
---@param capInsets rect_table
---@return boolean
function Scale9Sprite:initWithSpriteFrameName (spriteFrameName,capInsets) end
---* brief Get the original no 9-sliced sprite<br>
---* return A sprite instance.
---@return cc.Sprite
function Scale9Sprite:getSprite () end
---* brief Change the top sprite's cap inset.<br>
---* param topInset The values to use for the cap inset.
---@param topInset float
---@return self
function Scale9Sprite:setInsetTop (topInset) end
---* Set the slice sprite rendering type.<br>
---* When setting to SIMPLE, only 4 vertexes is used to rendering.<br>
---* otherwise 16 vertexes will be used to rendering.<br>
---* see RenderingType
---@param type int
---@return self
function Scale9Sprite:setRenderingType (type) end
---@overload fun(cc.Sprite:cc.Sprite,rect_table:rect_table,boolean2:rect_table):self
---@overload fun(cc.Sprite:cc.Sprite,rect_table:rect_table,boolean:boolean,vec2_table3:rect_table):self
---@overload fun(cc.Sprite:cc.Sprite,rect_table:rect_table,boolean:boolean,vec2_table:vec2_table,size_table:size_table,rect_table:rect_table):self
---@param sprite cc.Sprite
---@param rect rect_table
---@param rotated boolean
---@param offset vec2_table
---@param originalSize size_table
---@param capInsets rect_table
---@return boolean
function Scale9Sprite:init (sprite,rect,rotated,offset,originalSize,capInsets) end
---* brief Change the preferred size of Scale9Sprite.<br>
---* param size A delimitation zone.
---@param size size_table
---@return self
function Scale9Sprite:setPreferredSize (size) end
---* brief copies self to copy
---@param copy ccui.Scale9Sprite
---@return self
function Scale9Sprite:copyTo (copy) end
---* brief Change inner sprite's sprite frame.<br>
---* param spriteFrame A sprite frame pointer.<br>
---* param capInsets The values to use for the cap insets.
---@param spriteFrame cc.SpriteFrame
---@param capInsets rect_table
---@return self
function Scale9Sprite:setSpriteFrame (spriteFrame,capInsets) end
---* Query the current bright state.<br>
---* return @see `State`<br>
---* since v3.7
---@return int
function Scale9Sprite:getState () end
---* brief Query the bottom sprite's cap inset.<br>
---* return The bottom sprite's cap inset.
---@return float
function Scale9Sprite:getInsetBottom () end
---* brief Toggle 9-slice feature.<br>
---* If Scale9Sprite is 9-slice disabled, the Scale9Sprite will rendered as a normal sprite.<br>
---* warning: Don't use setScale9Enabled(false), use setRenderingType(RenderingType::SIMPLE) instead.<br>
---* The setScale9Enabled(false) is kept only for back back compatibility.<br>
---* param enabled True to enable 9-slice, false otherwise.<br>
---* js NA
---@param enabled boolean
---@return self
function Scale9Sprite:setScale9Enabled (enabled) end
---* brief Query whether the Scale9Sprite is enable 9-slice or not.<br>
---* return True if 9-slice is enabled, false otherwise.<br>
---* js NA
---@return boolean
function Scale9Sprite:isScale9Enabled () end
---* 
---@return self
function Scale9Sprite:resetRender () end
---* Return the slice sprite rendering type.
---@return int
function Scale9Sprite:getRenderingType () end
---* brief Query the right sprite's cap inset.<br>
---* return The right sprite's cap inset.
---@return float
function Scale9Sprite:getInsetRight () end
---* brief Query the sprite's original size.<br>
---* return Sprite size.
---@return size_table
function Scale9Sprite:getOriginalSize () end
---@overload fun(string0:rect_table,rect_table1:string):self
---@overload fun(string:string,rect_table:rect_table,rect_table:rect_table):self
---@param file string
---@param rect rect_table
---@param capInsets rect_table
---@return boolean
function Scale9Sprite:initWithFile (file,rect,capInsets) end
---* brief Query the top sprite's cap inset.<br>
---* return The top sprite's cap inset.
---@return float
function Scale9Sprite:getInsetTop () end
---* brief Change the left sprite's cap inset.<br>
---* param leftInset The values to use for the cap inset.
---@param leftInset float
---@return self
function Scale9Sprite:setInsetLeft (leftInset) end
---* Initializes a 9-slice sprite with an sprite frame and with the specified<br>
---* cap insets.<br>
---* Once the sprite is created, you can then call its "setContentSize:" method<br>
---* to resize the sprite will all it's 9-slice goodness interact.<br>
---* It respects the anchorPoint too.<br>
---* param spriteFrame The sprite frame object.<br>
---* param capInsets The values to use for the cap insets.<br>
---* return True if initializes success, false otherwise.
---@param spriteFrame cc.SpriteFrame
---@param capInsets rect_table
---@return boolean
function Scale9Sprite:initWithSpriteFrame (spriteFrame,capInsets) end
---* brief Query the Scale9Sprite's preferred size.<br>
---* return Scale9Sprite's preferred size.
---@return size_table
function Scale9Sprite:getPreferredSize () end
---* Set the Cap Insets in Points using the untrimmed size as reference
---@param insets rect_table
---@return self
function Scale9Sprite:setCapInsets (insets) end
---* brief Query the left sprite's cap inset.<br>
---* return The left sprite's cap inset.
---@return float
function Scale9Sprite:getInsetLeft () end
---* brief Change the right sprite's cap inset.<br>
---* param rightInset The values to use for the cap inset.
---@param rightInset float
---@return self
function Scale9Sprite:setInsetRight (rightInset) end
---@overload fun(string:string,rect_table:rect_table,rect_table:rect_table):self
---@overload fun():self
---@overload fun(string0:rect_table,rect_table1:string):self
---@overload fun(string:string,rect_table:rect_table):self
---@overload fun(string:string):self
---@param file string
---@param rect rect_table
---@param capInsets rect_table
---@return self
function Scale9Sprite:create (file,rect,capInsets) end
---@overload fun(string:string,rect_table:rect_table):self
---@overload fun(string:string):self
---@param spriteFrameName string
---@param capInsets rect_table
---@return self
function Scale9Sprite:createWithSpriteFrameName (spriteFrameName,capInsets) end
---@overload fun(cc.SpriteFrame:cc.SpriteFrame,rect_table:rect_table):self
---@overload fun(cc.SpriteFrame:cc.SpriteFrame):self
---@param spriteFrame cc.SpriteFrame
---@param capInsets rect_table
---@return self
function Scale9Sprite:createWithSpriteFrame (spriteFrame,capInsets) end
---* Initializes a 9-slice sprite with an sprite frame name.<br>
---* Once the sprite is created, you can then call its "setContentSize:" method<br>
---* to resize the sprite will all it's 9-slice goodness interact.<br>
---* It respects the anchorPoint too.<br>
---* param spriteFrameName The sprite frame name.<br>
---* return True if initializes success, false otherwise.
---@param spriteFrameName string
---@return boolean
function Scale9Sprite:initWithSpriteFrameName (spriteFrameName) end
---@overload fun(string:string):self
---@overload fun(string:string,rect_table:rect_table):self
---@param file string
---@param rect rect_table
---@return boolean
function Scale9Sprite:initWithFile (file,rect) end
---* 
---@return boolean
function Scale9Sprite:init () end
---* Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function Scale9Sprite:Scale9Sprite () end