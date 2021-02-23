---@meta

---@class cc.ActionFloat :cc.ActionInterval
local ActionFloat={ }
cc.ActionFloat=ActionFloat




---* 
---@param duration float
---@param from float
---@param to float
---@param callback function
---@return boolean
function ActionFloat:initWithDuration (duration,from,to,callback) end
---* Creates FloatAction with specified duration, from value, to value and callback to report back<br>
---* results<br>
---* param duration of the action<br>
---* param from value to start from<br>
---* param to value to be at the end of the action<br>
---* param callback to report back result<br>
---* return An autoreleased ActionFloat object
---@param duration float
---@param from float
---@param to float
---@param callback function
---@return self
function ActionFloat:create (duration,from,to,callback) end
---* Overridden ActionInterval methods
---@param target cc.Node
---@return self
function ActionFloat:startWithTarget (target) end
---* 
---@return self
function ActionFloat:clone () end
---* 
---@param delta float
---@return self
function ActionFloat:update (delta) end
---* 
---@return self
function ActionFloat:reverse () end
---* 
---@return self
function ActionFloat:ActionFloat () end