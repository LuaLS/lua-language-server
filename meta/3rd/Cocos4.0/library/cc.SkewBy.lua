---@meta

---@class cc.SkewBy :cc.SkewTo
local SkewBy={ }
cc.SkewBy=SkewBy




---* param t In seconds.
---@param t float
---@param sx float
---@param sy float
---@return boolean
function SkewBy:initWithDuration (t,sx,sy) end
---* Creates the action.<br>
---* param t Duration time, in seconds.<br>
---* param deltaSkewX Skew x delta angle.<br>
---* param deltaSkewY Skew y delta angle.<br>
---* return An autoreleased SkewBy object.
---@param t float
---@param deltaSkewX float
---@param deltaSkewY float
---@return self
function SkewBy:create (t,deltaSkewX,deltaSkewY) end
---* 
---@param target cc.Node
---@return self
function SkewBy:startWithTarget (target) end
---* 
---@return self
function SkewBy:clone () end
---* 
---@return self
function SkewBy:reverse () end
---* 
---@return self
function SkewBy:SkewBy () end