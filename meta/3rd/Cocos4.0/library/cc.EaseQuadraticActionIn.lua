---@meta

---@class cc.EaseQuadraticActionIn :cc.ActionEase
local EaseQuadraticActionIn={ }
cc.EaseQuadraticActionIn=EaseQuadraticActionIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuadraticActionIn:create (action) end
---* 
---@return self
function EaseQuadraticActionIn:clone () end
---* 
---@param time float
---@return self
function EaseQuadraticActionIn:update (time) end
---* 
---@return cc.ActionEase
function EaseQuadraticActionIn:reverse () end
---* 
---@return self
function EaseQuadraticActionIn:EaseQuadraticActionIn () end