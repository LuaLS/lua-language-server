---@meta

---@class cc.RotateBy :cc.ActionInterval
local RotateBy={ }
cc.RotateBy=RotateBy




---@overload fun(float:float,float:float,float:float):self
---@overload fun(float:float,float:float):self
---@overload fun(float:float,float1:vec3_table):self
---@param duration float
---@param deltaAngleZ_X float
---@param deltaAngleZ_Y float
---@return boolean
function RotateBy:initWithDuration (duration,deltaAngleZ_X,deltaAngleZ_Y) end
---@overload fun(float:float,float:float,float:float):self
---@overload fun(float:float,float:float):self
---@overload fun(float:float,float1:vec3_table):self
---@param duration float
---@param deltaAngleZ_X float
---@param deltaAngleZ_Y float
---@return self
function RotateBy:create (duration,deltaAngleZ_X,deltaAngleZ_Y) end
---* 
---@param target cc.Node
---@return self
function RotateBy:startWithTarget (target) end
---* 
---@return self
function RotateBy:clone () end
---* 
---@return self
function RotateBy:reverse () end
---* param time In seconds.
---@param time float
---@return self
function RotateBy:update (time) end
---* 
---@return self
function RotateBy:RotateBy () end