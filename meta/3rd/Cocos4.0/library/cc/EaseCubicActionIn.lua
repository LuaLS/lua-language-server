---@meta

---@class cc.EaseCubicActionIn :cc.ActionEase
local EaseCubicActionIn={ }
cc.EaseCubicActionIn=EaseCubicActionIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseCubicActionIn:create (action) end
---* 
---@return self
function EaseCubicActionIn:clone () end
---* 
---@param time float
---@return self
function EaseCubicActionIn:update (time) end
---* 
---@return cc.ActionEase
function EaseCubicActionIn:reverse () end
---* 
---@return self
function EaseCubicActionIn:EaseCubicActionIn () end