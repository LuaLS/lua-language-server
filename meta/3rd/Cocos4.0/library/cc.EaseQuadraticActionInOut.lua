---@meta

---@class cc.EaseQuadraticActionInOut :cc.ActionEase
local EaseQuadraticActionInOut={ }
cc.EaseQuadraticActionInOut=EaseQuadraticActionInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuadraticActionInOut:create (action) end
---* 
---@return self
function EaseQuadraticActionInOut:clone () end
---* 
---@param time float
---@return self
function EaseQuadraticActionInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseQuadraticActionInOut:reverse () end
---* 
---@return self
function EaseQuadraticActionInOut:EaseQuadraticActionInOut () end