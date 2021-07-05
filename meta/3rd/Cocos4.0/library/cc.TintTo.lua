---@meta

---@class cc.TintTo :cc.ActionInterval
local TintTo={ }
cc.TintTo=TintTo




---*  initializes the action with duration and color 
---@param duration float
---@param red unsigned_char
---@param green unsigned_char
---@param blue unsigned_char
---@return boolean
function TintTo:initWithDuration (duration,red,green,blue) end
---@overload fun(float:float,unsigned_char1:color3b_table):self
---@overload fun(float:float,unsigned_char:unsigned_char,unsigned_char:unsigned_char,unsigned_char:unsigned_char):self
---@param duration float
---@param red unsigned_char
---@param green unsigned_char
---@param blue unsigned_char
---@return self
function TintTo:create (duration,red,green,blue) end
---* 
---@param target cc.Node
---@return self
function TintTo:startWithTarget (target) end
---* 
---@return self
function TintTo:clone () end
---* 
---@return self
function TintTo:reverse () end
---* param time In seconds.
---@param time float
---@return self
function TintTo:update (time) end
---* 
---@return self
function TintTo:TintTo () end