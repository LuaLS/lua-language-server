---@meta

---@class cc.Animate :cc.ActionInterval
local Animate={ }
cc.Animate=Animate




---*  initializes the action with an Animation and will restore the original frame when the animation is over 
---@param animation cc.Animation
---@return boolean
function Animate:initWithAnimation (animation) end
---@overload fun():self
---@overload fun():self
---@return cc.Animation
function Animate:getAnimation () end
---* Gets the index of sprite frame currently displayed.<br>
---* return int  the index of sprite frame currently displayed.
---@return int
function Animate:getCurrentFrameIndex () end
---*  Sets the Animation object to be animated <br>
---* param animation certain animation.
---@param animation cc.Animation
---@return self
function Animate:setAnimation (animation) end
---*  Creates the action with an Animation and will restore the original frame when the animation is over.<br>
---* param animation A certain animation.<br>
---* return An autoreleased Animate object.
---@param animation cc.Animation
---@return self
function Animate:create (animation) end
---* 
---@param target cc.Node
---@return self
function Animate:startWithTarget (target) end
---* 
---@return self
function Animate:clone () end
---* 
---@return self
function Animate:stop () end
---* 
---@return self
function Animate:reverse () end
---* param t In seconds.
---@param t float
---@return self
function Animate:update (t) end
---* 
---@return self
function Animate:Animate () end