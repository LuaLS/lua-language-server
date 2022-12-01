---@meta

---@class ccs.InnerActionFrame :ccs.Frame
local InnerActionFrame={ }
ccs.InnerActionFrame=InnerActionFrame




---* 
---@return int
function InnerActionFrame:getEndFrameIndex () end
---* 
---@return int
function InnerActionFrame:getStartFrameIndex () end
---* 
---@return int
function InnerActionFrame:getInnerActionType () end
---* 
---@param frameIndex int
---@return self
function InnerActionFrame:setEndFrameIndex (frameIndex) end
---* 
---@param isEnterWithName boolean
---@return self
function InnerActionFrame:setEnterWithName (isEnterWithName) end
---* 
---@param frameIndex int
---@return self
function InnerActionFrame:setSingleFrameIndex (frameIndex) end
---* 
---@param frameIndex int
---@return self
function InnerActionFrame:setStartFrameIndex (frameIndex) end
---* 
---@return int
function InnerActionFrame:getSingleFrameIndex () end
---* 
---@param type int
---@return self
function InnerActionFrame:setInnerActionType (type) end
---* 
---@param animationNamed string
---@return self
function InnerActionFrame:setAnimationName (animationNamed) end
---* 
---@return self
function InnerActionFrame:create () end
---* 
---@return ccs.Frame
function InnerActionFrame:clone () end
---* 
---@return self
function InnerActionFrame:InnerActionFrame () end