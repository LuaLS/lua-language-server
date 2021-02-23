---@meta

---@class cc.ScaleBy :cc.ScaleTo
local ScaleBy={ }
cc.ScaleBy=ScaleBy




---@overload fun(float:float,float:float,float:float):self
---@overload fun(float:float,float:float):self
---@overload fun(float:float,float:float,float:float,float:float):self
---@param duration float
---@param sx float
---@param sy float
---@param sz float
---@return self
function ScaleBy:create (duration,sx,sy,sz) end
---* 
---@param target cc.Node
---@return self
function ScaleBy:startWithTarget (target) end
---* 
---@return self
function ScaleBy:clone () end
---* 
---@return self
function ScaleBy:reverse () end
---* 
---@return self
function ScaleBy:ScaleBy () end