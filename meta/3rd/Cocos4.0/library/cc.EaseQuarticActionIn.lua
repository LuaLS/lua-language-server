---@meta

---@class cc.EaseQuarticActionIn :cc.ActionEase
local EaseQuarticActionIn={ }
cc.EaseQuarticActionIn=EaseQuarticActionIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseQuarticActionIn:create (action) end
---* 
---@return self
function EaseQuarticActionIn:clone () end
---* 
---@param time float
---@return self
function EaseQuarticActionIn:update (time) end
---* 
---@return cc.ActionEase
function EaseQuarticActionIn:reverse () end
---* 
---@return self
function EaseQuarticActionIn:EaseQuarticActionIn () end