---@meta

---@class cc.EaseSineInOut :cc.ActionEase
local EaseSineInOut={ }
cc.EaseSineInOut=EaseSineInOut




---* 
---@param action cc.ActionInterval
---@return self
function EaseSineInOut:create (action) end
---* 
---@return self
function EaseSineInOut:clone () end
---* 
---@param time float
---@return self
function EaseSineInOut:update (time) end
---* 
---@return cc.ActionEase
function EaseSineInOut:reverse () end
---* 
---@return self
function EaseSineInOut:EaseSineInOut () end