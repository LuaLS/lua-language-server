---@meta

---@class cc.RotateTo :cc.ActionInterval
local RotateTo={ }
cc.RotateTo=RotateTo




---@overload fun(float:float,float1:vec3_table):self
---@overload fun(float:float,float:float,float:float):self
---@param duration float
---@param dstAngleX float
---@param dstAngleY float
---@return boolean
function RotateTo:initWithDuration (duration,dstAngleX,dstAngleY) end
---@overload fun(float:float,float:float):self
---@overload fun(float:float,float:float,float:float):self
---@overload fun(float:float,float1:vec3_table):self
---@param duration float
---@param dstAngleX float
---@param dstAngleY float
---@return self
function RotateTo:create (duration,dstAngleX,dstAngleY) end
---* 
---@param target cc.Node
---@return self
function RotateTo:startWithTarget (target) end
---* 
---@return self
function RotateTo:clone () end
---* 
---@return self
function RotateTo:reverse () end
---* param time In seconds.
---@param time float
---@return self
function RotateTo:update (time) end
---* 
---@return self
function RotateTo:RotateTo () end