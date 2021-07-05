---@meta

---@class cc.SkewTo :cc.ActionInterval
local SkewTo={ }
cc.SkewTo=SkewTo




---* param t In seconds.
---@param t float
---@param sx float
---@param sy float
---@return boolean
function SkewTo:initWithDuration (t,sx,sy) end
---* Creates the action.<br>
---* param t Duration time, in seconds.<br>
---* param sx Skew x angle.<br>
---* param sy Skew y angle.<br>
---* return An autoreleased SkewTo object.
---@param t float
---@param sx float
---@param sy float
---@return self
function SkewTo:create (t,sx,sy) end
---* 
---@param target cc.Node
---@return self
function SkewTo:startWithTarget (target) end
---* 
---@return self
function SkewTo:clone () end
---* 
---@return self
function SkewTo:reverse () end
---* param time In seconds.
---@param time float
---@return self
function SkewTo:update (time) end
---* 
---@return self
function SkewTo:SkewTo () end