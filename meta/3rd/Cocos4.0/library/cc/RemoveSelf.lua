---@meta

---@class cc.RemoveSelf :cc.ActionInstant
local RemoveSelf={ }
cc.RemoveSelf=RemoveSelf




---*  init the action 
---@param isNeedCleanUp boolean
---@return boolean
function RemoveSelf:init (isNeedCleanUp) end
---*  Create the action.<br>
---* param isNeedCleanUp Is need to clean up, the default value is true.<br>
---* return An autoreleased RemoveSelf object.
---@return self
function RemoveSelf:create () end
---* 
---@return self
function RemoveSelf:clone () end
---* param time In seconds.
---@param time float
---@return self
function RemoveSelf:update (time) end
---* 
---@return self
function RemoveSelf:reverse () end
---* 
---@return self
function RemoveSelf:RemoveSelf () end