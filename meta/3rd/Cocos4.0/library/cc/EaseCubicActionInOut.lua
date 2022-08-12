---@meta

---@class cc.EaseCubicActionInOut :cc.ActionEase
local EaseCubicActionInOut={ }
cc.EaseCubicActionInOut=EaseCubicActionInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseCubicActionInOut:create (action) end
---* 
---@return self
function EaseCubicActionInOut:clone () end
---* 
---@param time float
---@return self
function EaseCubicActionInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseCubicActionInOut:reverse () end
---* 
---@return self
function EaseCubicActionInOut:EaseCubicActionInOut () end