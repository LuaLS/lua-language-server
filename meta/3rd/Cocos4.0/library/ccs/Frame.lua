---@meta

---@class ccs.Frame :cc.Ref
local Frame={ }
ccs.Frame=Frame




---* 
---@return self
function Frame:clone () end
---* 
---@param tweenType int
---@return self
function Frame:setTweenType (tweenType) end
---* 
---@param node cc.Node
---@return self
function Frame:setNode (node) end
---* 
---@param timeline ccs.Timeline
---@return self
function Frame:setTimeline (timeline) end
---* 
---@return boolean
function Frame:isEnterWhenPassed () end
---* 
---@return int
function Frame:getTweenType () end
---* 
---@return array_table
function Frame:getEasingParams () end
---* 
---@param easingParams array_table
---@return self
function Frame:setEasingParams (easingParams) end
---* 
---@return unsigned_int
function Frame:getFrameIndex () end
---* 
---@param percent float
---@return self
function Frame:apply (percent) end
---* 
---@return boolean
function Frame:isTween () end
---* 
---@param frameIndex unsigned_int
---@return self
function Frame:setFrameIndex (frameIndex) end
---* 
---@param tween boolean
---@return self
function Frame:setTween (tween) end
---* 
---@return ccs.Timeline
function Frame:getTimeline () end
---* 
---@return cc.Node
function Frame:getNode () end