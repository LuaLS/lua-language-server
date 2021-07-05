---@meta

---@class cc.EaseBounceInOut :cc.ActionEase
local EaseBounceInOut={ }
cc.EaseBounceInOut=EaseBounceInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseBounceInOut:create (action) end
---* 
---@return self
function EaseBounceInOut:clone () end
---* 
---@param time float
---@return self
function EaseBounceInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseBounceInOut:reverse () end
---* 
---@return self
function EaseBounceInOut:EaseBounceInOut () end