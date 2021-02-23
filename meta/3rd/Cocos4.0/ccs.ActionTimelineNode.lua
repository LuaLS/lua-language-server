---@meta

---@class ccs.ActionTimelineNode :cc.Node
local ActionTimelineNode={ }
ccs.ActionTimelineNode=ActionTimelineNode




---* 
---@return cc.Node
function ActionTimelineNode:getRoot () end
---* 
---@return ccs.ActionTimeline
function ActionTimelineNode:getActionTimeline () end
---* 
---@param action ccs.ActionTimeline
---@return self
function ActionTimelineNode:setActionTimeline (action) end
---* 
---@param root cc.Node
---@param action ccs.ActionTimeline
---@return boolean
function ActionTimelineNode:init (root,action) end
---* 
---@param root cc.Node
---@return self
function ActionTimelineNode:setRoot (root) end
---* 
---@param root cc.Node
---@param action ccs.ActionTimeline
---@return self
function ActionTimelineNode:create (root,action) end
---* 
---@return boolean
function ActionTimelineNode:init () end
---* 
---@return self
function ActionTimelineNode:ActionTimelineNode () end