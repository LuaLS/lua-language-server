---@meta

---@class cc.EaseQuarticActionOut :cc.ActionEase
local EaseQuarticActionOut={ }
cc.EaseQuarticActionOut=EaseQuarticActionOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuarticActionOut:create (action) end
---* 
---@return self
function EaseQuarticActionOut:clone () end
---* 
---@param time float
---@return self
function EaseQuarticActionOut:update (time) end
---* 
---@return cc.ActionEase
function EaseQuarticActionOut:reverse () end
---* 
---@return self
function EaseQuarticActionOut:EaseQuarticActionOut () end