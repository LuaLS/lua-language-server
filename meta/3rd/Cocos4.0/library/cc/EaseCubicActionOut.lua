---@meta

---@class cc.EaseCubicActionOut :cc.ActionEase
local EaseCubicActionOut={ }
cc.EaseCubicActionOut=EaseCubicActionOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseCubicActionOut:create (action) end
---* 
---@return self
function EaseCubicActionOut:clone () end
---* 
---@param time float
---@return self
function EaseCubicActionOut:update (time) end
---* 
---@return cc.ActionEase
function EaseCubicActionOut:reverse () end
---* 
---@return self
function EaseCubicActionOut:EaseCubicActionOut () end