---@meta

---@class cc.EaseBounceIn :cc.ActionEase
local EaseBounceIn={ }
cc.EaseBounceIn=EaseBounceIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseBounceIn:create (action) end
---* 
---@return self
function EaseBounceIn:clone () end
---* 
---@param time float
---@return self
function EaseBounceIn:update (time) end
---* 
---@return cc.ActionEase
function EaseBounceIn:reverse () end
---* 
---@return self
function EaseBounceIn:EaseBounceIn () end