---@meta

---@class cc.ActionCamera :cc.ActionInterval
local ActionCamera={ }
cc.ActionCamera=ActionCamera




---@overload fun(float:float,float:float,float:float):self
---@overload fun(float0:vec3_table):self
---@param x float
---@param y float
---@param z float
---@return self
function ActionCamera:setEye (x,y,z) end
---* 
---@return vec3_table
function ActionCamera:getEye () end
---* 
---@param up vec3_table
---@return self
function ActionCamera:setUp (up) end
---* 
---@return vec3_table
function ActionCamera:getCenter () end
---* 
---@param center vec3_table
---@return self
function ActionCamera:setCenter (center) end
---* 
---@return vec3_table
function ActionCamera:getUp () end
---* 
---@param target cc.Node
---@return self
function ActionCamera:startWithTarget (target) end
---* 
---@return self
function ActionCamera:clone () end
---* 
---@return self
function ActionCamera:reverse () end
---* js ctor<br>
---* lua new
---@return self
function ActionCamera:ActionCamera () end