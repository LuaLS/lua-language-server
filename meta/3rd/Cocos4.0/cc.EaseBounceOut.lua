---@meta

---@class cc.EaseBounceOut :cc.ActionEase
local EaseBounceOut={ }
cc.EaseBounceOut=EaseBounceOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseBounceOut:create (action) end
---* 
---@return self
function EaseBounceOut:clone () end
---* 
---@param time float
---@return self
function EaseBounceOut:update (time) end
---* 
---@return cc.ActionEase
function EaseBounceOut:reverse () end
---* 
---@return self
function EaseBounceOut:EaseBounceOut () end