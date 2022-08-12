---@meta

---@class cc.MoveTo :cc.MoveBy
local MoveTo={ }
cc.MoveTo=MoveTo




---@overload fun(float:float,vec2_table1:vec3_table):self
---@overload fun(float:float,vec2_table:vec2_table):self
---@param duration float
---@param position vec2_table
---@return boolean
function MoveTo:initWithDuration (duration,position) end
---@overload fun(float:float,vec2_table1:vec3_table):self
---@overload fun(float:float,vec2_table:vec2_table):self
---@param duration float
---@param position vec2_table
---@return self
function MoveTo:create (duration,position) end
---* 
---@param target cc.Node
---@return self
function MoveTo:startWithTarget (target) end
---* 
---@return self
function MoveTo:clone () end
---* 
---@return self
function MoveTo:reverse () end
---* 
---@return self
function MoveTo:MoveTo () end