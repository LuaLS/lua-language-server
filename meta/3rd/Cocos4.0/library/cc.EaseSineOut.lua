---@meta

---@class cc.EaseSineOut :cc.ActionEase
local EaseSineOut={ }
cc.EaseSineOut=EaseSineOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseSineOut:create (action) end
---* 
---@return self
function EaseSineOut:clone () end
---* 
---@param time float
---@return self
function EaseSineOut:update (time) end
---* 
---@return cc.ActionEase
function EaseSineOut:reverse () end
---* 
---@return self
function EaseSineOut:EaseSineOut () end