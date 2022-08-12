---@meta

---@class cc.EaseQuarticActionInOut :cc.ActionEase
local EaseQuarticActionInOut={ }
cc.EaseQuarticActionInOut=EaseQuarticActionInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuarticActionInOut:create (action) end
---* 
---@return self
function EaseQuarticActionInOut:clone () end
---* 
---@param time float
---@return self
function EaseQuarticActionInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseQuarticActionInOut:reverse () end
---* 
---@return self
function EaseQuarticActionInOut:EaseQuarticActionInOut () end