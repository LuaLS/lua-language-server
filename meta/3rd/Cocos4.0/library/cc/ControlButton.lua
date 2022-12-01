---@meta

---@class cc.ControlButton :cc.Control
local ControlButton={ }
cc.ControlButton=ControlButton




---* 
---@return boolean
function ControlButton:isPushed () end
---* Sets the title label to use for the specified state.<br>
---* If a property is not specified for a state, the default is to use<br>
---* the ButtonStateNormal value.<br>
---* param label The title label to use for the specified state.<br>
---* param state The state that uses the specified title. The values are described<br>
---* in "CCControlState".
---@param label cc.Node
---@param state int
---@return self
function ControlButton:setTitleLabelForState (label,state) end
---* 
---@param adjustBackgroundImage boolean
---@return self
function ControlButton:setAdjustBackgroundImage (adjustBackgroundImage) end
---* Sets the title string to use for the specified state.<br>
---* If a property is not specified for a state, the default is to use<br>
---* the ButtonStateNormal value.<br>
---* param title The title string to use for the specified state.<br>
---* param state The state that uses the specified title. The values are described<br>
---* in "CCControlState".
---@param title string
---@param state int
---@return self
function ControlButton:setTitleForState (title,state) end
---* 
---@param var vec2_table
---@return self
function ControlButton:setLabelAnchorPoint (var) end
---* 
---@return vec2_table
function ControlButton:getLabelAnchorPoint () end
---* 
---@param sprite ccui.Scale9Sprite
---@return boolean
function ControlButton:initWithBackgroundSprite (sprite) end
---* 
---@param state int
---@return float
function ControlButton:getTitleTTFSizeForState (state) end
---* 
---@param fntFile string
---@param state int
---@return self
function ControlButton:setTitleTTFForState (fntFile,state) end
---* 
---@param size float
---@param state int
---@return self
function ControlButton:setTitleTTFSizeForState (size,state) end
---* 
---@param var cc.Node
---@return self
function ControlButton:setTitleLabel (var) end
---* 
---@param var size_table
---@return self
function ControlButton:setPreferredSize (var) end
---* 
---@return color3b_table
function ControlButton:getCurrentTitleColor () end
---* 
---@param var boolean
---@return self
function ControlButton:setZoomOnTouchDown (var) end
---* 
---@param var ccui.Scale9Sprite
---@return self
function ControlButton:setBackgroundSprite (var) end
---* Returns the background sprite used for a state.<br>
---* param state The state that uses the background sprite. Possible values are<br>
---* described in "CCControlState".
---@param state int
---@return ccui.Scale9Sprite
function ControlButton:getBackgroundSpriteForState (state) end
---* 
---@return int
function ControlButton:getHorizontalOrigin () end
---* 
---@param title string
---@param fontName string
---@param fontSize float
---@return boolean
function ControlButton:initWithTitleAndFontNameAndFontSize (title,fontName,fontSize) end
---* Sets the font of the label, changes the label to a BMFont if necessary.<br>
---* param fntFile The name of the font to change to<br>
---* param state The state that uses the specified fntFile. The values are described<br>
---* in "CCControlState".
---@param fntFile string
---@param state int
---@return self
function ControlButton:setTitleBMFontForState (fntFile,state) end
---* 
---@return float
function ControlButton:getScaleRatio () end
---* 
---@param state int
---@return string
function ControlButton:getTitleTTFForState (state) end
---* 
---@return ccui.Scale9Sprite
function ControlButton:getBackgroundSprite () end
---* Returns the title color used for a state.<br>
---* param state The state that uses the specified color. The values are described<br>
---* in "CCControlState".<br>
---* return The color of the title for the specified state.
---@param state int
---@return color3b_table
function ControlButton:getTitleColorForState (state) end
---* Sets the color of the title to use for the specified state.<br>
---* param color The color of the title to use for the specified state.<br>
---* param state The state that uses the specified color. The values are described<br>
---* in "CCControlState".
---@param color color3b_table
---@param state int
---@return self
function ControlButton:setTitleColorForState (color,state) end
---*  Adjust the background image. YES by default. If the property is set to NO, the<br>
---* background will use the preferred size of the background image. 
---@return boolean
function ControlButton:doesAdjustBackgroundImage () end
---* Sets the background spriteFrame to use for the specified button state.<br>
---* param spriteFrame The background spriteFrame to use for the specified state.<br>
---* param state The state that uses the specified image. The values are described<br>
---* in "CCControlState".
---@param spriteFrame cc.SpriteFrame
---@param state int
---@return self
function ControlButton:setBackgroundSpriteFrameForState (spriteFrame,state) end
---* Sets the background sprite to use for the specified button state.<br>
---* param sprite The background sprite to use for the specified state.<br>
---* param state The state that uses the specified image. The values are described<br>
---* in "CCControlState".
---@param sprite ccui.Scale9Sprite
---@param state int
---@return self
function ControlButton:setBackgroundSpriteForState (sprite,state) end
---* 
---@param var float
---@return self
function ControlButton:setScaleRatio (var) end
---* 
---@param state int
---@return string
function ControlButton:getTitleBMFontForState (state) end
---* 
---@return cc.Node
function ControlButton:getTitleLabel () end
---* 
---@return size_table
function ControlButton:getPreferredSize () end
---* 
---@return int
function ControlButton:getVerticalMargin () end
---* Returns the title label used for a state.<br>
---* param state The state that uses the title label. Possible values are described<br>
---* in "CCControlState".
---@param state int
---@return cc.Node
function ControlButton:getTitleLabelForState (state) end
---* 
---@param marginH int
---@param marginV int
---@return self
function ControlButton:setMargins (marginH,marginV) end
---@overload fun():self
---@overload fun():self
---@return string
function ControlButton:getCurrentTitle () end
---* 
---@param label cc.Node
---@param backgroundSprite ccui.Scale9Sprite
---@param adjustBackGroundSize boolean
---@return boolean
function ControlButton:initWithLabelAndBackgroundSprite (label,backgroundSprite,adjustBackGroundSize) end
---* 
---@return boolean
function ControlButton:getZoomOnTouchDown () end
---* Returns the title used for a state.<br>
---* param state The state that uses the title. Possible values are described in<br>
---* "CCControlState".<br>
---* return The title for the specified state.
---@param state int
---@return string
function ControlButton:getTitleForState (state) end
---@overload fun(cc.Node0:ccui.Scale9Sprite):self
---@overload fun():self
---@overload fun(cc.Node:cc.Node,ccui.Scale9Sprite:ccui.Scale9Sprite):self
---@overload fun(cc.Node0:string,ccui.Scale9Sprite1:string,boolean2:float):self
---@overload fun(cc.Node:cc.Node,ccui.Scale9Sprite:ccui.Scale9Sprite,boolean:boolean):self
---@param label cc.Node
---@param backgroundSprite ccui.Scale9Sprite
---@param adjustBackGroundSize boolean
---@return self
function ControlButton:create (label,backgroundSprite,adjustBackGroundSize) end
---* 
---@param enabled boolean
---@return self
function ControlButton:setEnabled (enabled) end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return self
function ControlButton:onTouchEnded (touch,event) end
---* 
---@param e color3b_tabl
---@return self
function ControlButton:setColor (e) end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return self
function ControlButton:onTouchMoved (touch,event) end
---* 
---@param enabled boolean
---@return self
function ControlButton:setSelected (enabled) end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return self
function ControlButton:onTouchCancelled (touch,event) end
---* 
---@return self
function ControlButton:needsLayout () end
---* 
---@param touch cc.Touch
---@param event cc.Event
---@return boolean
function ControlButton:onTouchBegan (touch,event) end
---* 
---@param parentOpacity unsigned_char
---@return self
function ControlButton:updateDisplayedOpacity (parentOpacity) end
---* 
---@return boolean
function ControlButton:init () end
---* 
---@param enabled boolean
---@return self
function ControlButton:setHighlighted (enabled) end
---* 
---@param parentColor color3b_table
---@return self
function ControlButton:updateDisplayedColor (parentColor) end
---* 
---@param var unsigned_char
---@return self
function ControlButton:setOpacity (var) end
---* js ctor
---@return self
function ControlButton:ControlButton () end