---@meta

---@class cc.Hide :cc.ActionInstant
local Hide={ }
cc.Hide=Hide




---*  Allocates and initializes the action.<br>
---* return An autoreleased Hide object.
---@return self
function Hide:create () end
---* 
---@return self
function Hide:clone () end
---* param time In seconds.
---@param time float
---@return self
function Hide:update (time) end
---* 
---@return cc.ActionInstant
function Hide:reverse () end
---* 
---@return self
function Hide:Hide () end