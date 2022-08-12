---@meta

---@class cc.FlipX :cc.ActionInstant
local FlipX={ }
cc.FlipX=FlipX




---*  init the action 
---@param x boolean
---@return boolean
function FlipX:initWithFlipX (x) end
---*  Create the action.<br>
---* param x Flips the sprite horizontally if true.<br>
---* return  An autoreleased FlipX object.
---@param x boolean
---@return self
function FlipX:create (x) end
---* 
---@return self
function FlipX:clone () end
---* param time In seconds.
---@param time float
---@return self
function FlipX:update (time) end
---* 
---@return self
function FlipX:reverse () end
---* 
---@return self
function FlipX:FlipX () end