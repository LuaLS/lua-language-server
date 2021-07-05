---@meta

---@class cc.EaseBackIn :cc.ActionEase
local EaseBackIn={ }
cc.EaseBackIn=EaseBackIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseBackIn:create (action) end
---* 
---@return self
function EaseBackIn:clone () end
---* 
---@param time float
---@return self
function EaseBackIn:update (time) end
---* 
---@return cc.ActionEase
function EaseBackIn:reverse () end
---* 
---@return self
function EaseBackIn:EaseBackIn () end