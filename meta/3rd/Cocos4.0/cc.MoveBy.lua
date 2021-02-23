---@meta

---@class cc.MoveBy :cc.ActionInterval
local MoveBy={ }
cc.MoveBy=MoveBy




---@overload fun(float:float,vec2_table1:vec3_table):self
---@overload fun(float:float,vec2_table:vec2_table):self
---@param duration float
---@param deltaPosition vec2_table
---@return boolean
function MoveBy:initWithDuration (duration,deltaPosition) end
---@overload fun(float:float,vec2_table1:vec3_table):self
---@overload fun(float:float,vec2_table:vec2_table):self
---@param duration float
---@param deltaPosition vec2_table
---@return self
function MoveBy:create (duration,deltaPosition) end
---* 
---@param target cc.Node
---@return self
function MoveBy:startWithTarget (target) end
---* 
---@return self
function MoveBy:clone () end
---* 
---@return self
function MoveBy:reverse () end
---* param time in seconds
---@param time float
---@return self
function MoveBy:update (time) end
---* 
---@return self
function MoveBy:MoveBy () end