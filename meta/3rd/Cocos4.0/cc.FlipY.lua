---@meta

---@class cc.FlipY :cc.ActionInstant
local FlipY={ }
cc.FlipY=FlipY




---*  init the action 
---@param y boolean
---@return boolean
function FlipY:initWithFlipY (y) end
---*  Create the action.<br>
---* param y Flips the sprite vertically if true.<br>
---* return An autoreleased FlipY object.
---@param y boolean
---@return self
function FlipY:create (y) end
---* 
---@return self
function FlipY:clone () end
---* param time In seconds.
---@param time float
---@return self
function FlipY:update (time) end
---* 
---@return self
function FlipY:reverse () end
---* 
---@return self
function FlipY:FlipY () end