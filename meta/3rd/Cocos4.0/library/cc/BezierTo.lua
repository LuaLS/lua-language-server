---@meta

---@class cc.BezierTo :cc.BezierBy
local BezierTo={ }
cc.BezierTo=BezierTo




---* param t In seconds.
---@param t float
---@param c cc._ccBezierConfig
---@return boolean
function BezierTo:initWithDuration (t,c) end
---* 
---@param target cc.Node
---@return self
function BezierTo:startWithTarget (target) end
---* 
---@return self
function BezierTo:clone () end
---* 
---@return self
function BezierTo:reverse () end
---* 
---@return self
function BezierTo:BezierTo () end