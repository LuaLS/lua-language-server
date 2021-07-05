---@meta

---@class ccs.Timeline :cc.Ref
local Timeline={ }
ccs.Timeline=Timeline




---* 
---@return self
function Timeline:clone () end
---* 
---@param frameIndex int
---@return self
function Timeline:gotoFrame (frameIndex) end
---* 
---@param node cc.Node
---@return self
function Timeline:setNode (node) end
---* 
---@return ccs.ActionTimeline
function Timeline:getActionTimeline () end
---* 
---@param frame ccs.Frame
---@param index int
---@return self
function Timeline:insertFrame (frame,index) end
---* 
---@param tag int
---@return self
function Timeline:setActionTag (tag) end
---* 
---@param frame ccs.Frame
---@return self
function Timeline:addFrame (frame) end
---* 
---@return array_table
function Timeline:getFrames () end
---* 
---@return int
function Timeline:getActionTag () end
---* 
---@return cc.Node
function Timeline:getNode () end
---* 
---@param frame ccs.Frame
---@return self
function Timeline:removeFrame (frame) end
---* 
---@param action ccs.ActionTimeline
---@return self
function Timeline:setActionTimeline (action) end
---* 
---@param frameIndex int
---@return self
function Timeline:stepToFrame (frameIndex) end
---* 
---@return self
function Timeline:create () end
---* 
---@return self
function Timeline:Timeline () end