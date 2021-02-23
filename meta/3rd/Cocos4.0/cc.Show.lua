---@meta

---@class cc.Show :cc.ActionInstant
local Show={ }
cc.Show=Show




---*  Allocates and initializes the action.<br>
---* return  An autoreleased Show object.
---@return self
function Show:create () end
---* 
---@return self
function Show:clone () end
---* param time In seconds.
---@param time float
---@return self
function Show:update (time) end
---* 
---@return cc.ActionInstant
function Show:reverse () end
---* 
---@return self
function Show:Show () end