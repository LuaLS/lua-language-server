---@meta

---@class cc.ScaleTo :cc.ActionInterval
local ScaleTo={ }
cc.ScaleTo=ScaleTo




---@overload fun(float:float,float:float,float:float):self
---@overload fun(float:float,float:float):self
---@overload fun(float:float,float:float,float:float,float:float):self
---@param duration float
---@param sx float
---@param sy float
---@param sz float
---@return boolean
function ScaleTo:initWithDuration (duration,sx,sy,sz) end
---@overload fun(float:float,float:float,float:float):self
---@overload fun(float:float,float:float):self
---@overload fun(float:float,float:float,float:float,float:float):self
---@param duration float
---@param sx float
---@param sy float
---@param sz float
---@return self
function ScaleTo:create (duration,sx,sy,sz) end
---* 
---@param target cc.Node
---@return self
function ScaleTo:startWithTarget (target) end
---* 
---@return self
function ScaleTo:clone () end
---* 
---@return self
function ScaleTo:reverse () end
---* param time In seconds.
---@param time float
---@return self
function ScaleTo:update (time) end
---* 
---@return self
function ScaleTo:ScaleTo () end