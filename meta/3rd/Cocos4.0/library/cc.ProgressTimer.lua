---@meta

---@class cc.ProgressTimer :cc.Node
local ProgressTimer={ }
cc.ProgressTimer=ProgressTimer




---*  Initializes a progress timer with the sprite as the shape the timer goes through 
---@param sp cc.Sprite
---@return boolean
function ProgressTimer:initWithSprite (sp) end
---*  Return the Reverse direction.<br>
---* return If the direction is Anti-clockwise,it will return true.
---@return boolean
function ProgressTimer:isReverseDirection () end
---* This allows the bar type to move the component at a specific rate.<br>
---* Set the component to 0 to make sure it stays at 100%.<br>
---* For example you want a left to right bar but not have the height stay 100%.<br>
---* Set the rate to be Vec2(0,1); and set the midpoint to = Vec2(0,.5f).<br>
---* param barChangeRate A Vec2.
---@param barChangeRate vec2_table
---@return self
function ProgressTimer:setBarChangeRate (barChangeRate) end
---*  Percentages are from 0 to 100.<br>
---* return Percentages.
---@return float
function ProgressTimer:getPercentage () end
---*  Set the sprite as the shape. <br>
---* param sprite The sprite as the shape.
---@param sprite cc.Sprite
---@return self
function ProgressTimer:setSprite (sprite) end
---*  Change the percentage to change progress. <br>
---* return A Type
---@return int
function ProgressTimer:getType () end
---*  The image to show the progress percentage, retain. <br>
---* return A sprite.
---@return cc.Sprite
function ProgressTimer:getSprite () end
---* Midpoint is used to modify the progress start position.<br>
---* If you're using radials type then the midpoint changes the center point.<br>
---* If you're using bar type then the midpoint changes the bar growth.<br>
---* it expands from the center but clamps to the sprites edge so:<br>
---* you want a left to right then set the midpoint all the way to Vec2(0,y).<br>
---* you want a right to left then set the midpoint all the way to Vec2(1,y).<br>
---* you want a bottom to top then set the midpoint all the way to Vec2(x,0).<br>
---* you want a top to bottom then set the midpoint all the way to Vec2(x,1).<br>
---* param point A Vec2 point.
---@param point vec2_table
---@return self
function ProgressTimer:setMidpoint (point) end
---*  Returns the BarChangeRate.<br>
---* return A barChangeRate.
---@return vec2_table
function ProgressTimer:getBarChangeRate () end
---*  Set the Reverse direction.<br>
---* param value If value is false it will clockwise,if is true it will Anti-clockwise.
---@param value boolean
---@return self
function ProgressTimer:setReverseDirection (value) end
---*  Returns the Midpoint. <br>
---* return A Vec2.
---@return vec2_table
function ProgressTimer:getMidpoint () end
---*  Set the initial percentage values. <br>
---* param percentage The initial percentage values.
---@param percentage float
---@return self
function ProgressTimer:setPercentage (percentage) end
---*  Set the ProgressTimer type. <br>
---* param type Is an Type.
---@param type int
---@return self
function ProgressTimer:setType (type) end
---*  Creates a progress timer with the sprite as the shape the timer goes through.<br>
---* param sp The sprite as the shape the timer goes through.<br>
---* return A ProgressTimer.
---@param sp cc.Sprite
---@return self
function ProgressTimer:create (sp) end
---* 
---@param anchorPoint vec2_table
---@return self
function ProgressTimer:setAnchorPoint (anchorPoint) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function ProgressTimer:draw (renderer,transform,flags) end
---* 
---@param color color3b_table
---@return self
function ProgressTimer:setColor (color) end
---* 
---@return color3b_table
function ProgressTimer:getColor () end
---* 
---@param opacity unsigned_char
---@return self
function ProgressTimer:setOpacity (opacity) end
---* 
---@return unsigned_char
function ProgressTimer:getOpacity () end
---* js ctor
---@return self
function ProgressTimer:ProgressTimer () end