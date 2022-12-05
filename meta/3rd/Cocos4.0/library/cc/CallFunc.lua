---@meta

---@class cc.CallFunc :cc.ActionInstant
local CallFunc={ }
cc.CallFunc=CallFunc




---*  Executes the callback.
---@return self
function CallFunc:execute () end
---* 
---@return self
function CallFunc:clone () end
---* param time In seconds.
---@param time float
---@return self
function CallFunc:update (time) end
---* 
---@return self
function CallFunc:reverse () end
---* 
---@return self
function CallFunc:CallFunc () end