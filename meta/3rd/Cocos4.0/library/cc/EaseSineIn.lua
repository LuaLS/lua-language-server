---@meta

---@class cc.EaseSineIn :cc.ActionEase
local EaseSineIn={ }
cc.EaseSineIn=EaseSineIn




---* 
---@param action cc.ActionInterval
---@return self
function EaseSineIn:create (action) end
---* 
---@return self
function EaseSineIn:clone () end
---* 
---@param time float
---@return self
function EaseSineIn:update (time) end
---* 
---@return cc.ActionEase
function EaseSineIn:reverse () end
---* 
---@return self
function EaseSineIn:EaseSineIn () end