---@meta

---@class ccs.ActionTimelineData :cc.Ref
local ActionTimelineData={ }
ccs.ActionTimelineData=ActionTimelineData




---* 
---@param actionTag int
---@return self
function ActionTimelineData:setActionTag (actionTag) end
---* 
---@param actionTag int
---@return boolean
function ActionTimelineData:init (actionTag) end
---* 
---@return int
function ActionTimelineData:getActionTag () end
---* 
---@param actionTag int
---@return self
function ActionTimelineData:create (actionTag) end
---* 
---@return self
function ActionTimelineData:ActionTimelineData () end