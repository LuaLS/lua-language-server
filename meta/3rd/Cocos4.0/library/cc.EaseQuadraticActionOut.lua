---@meta

---@class cc.EaseQuadraticActionOut :cc.ActionEase
local EaseQuadraticActionOut={ }
cc.EaseQuadraticActionOut=EaseQuadraticActionOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuadraticActionOut:create (action) end
---* 
---@return self
function EaseQuadraticActionOut:clone () end
---* 
---@param time float
---@return self
function EaseQuadraticActionOut:update (time) end
---* 
---@return cc.ActionEase
function EaseQuadraticActionOut:reverse () end
---* 
---@return self
function EaseQuadraticActionOut:EaseQuadraticActionOut () end