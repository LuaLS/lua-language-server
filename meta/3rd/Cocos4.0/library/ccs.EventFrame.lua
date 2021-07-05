---@meta

---@class ccs.EventFrame :ccs.Frame
local EventFrame={ }
ccs.EventFrame=EventFrame




---* 
---@param event string
---@return self
function EventFrame:setEvent (event) end
---* 
---@return self
function EventFrame:init () end
---* 
---@return string
function EventFrame:getEvent () end
---* 
---@return self
function EventFrame:create () end
---* 
---@return ccs.Frame
function EventFrame:clone () end
---* 
---@param node cc.Node
---@return self
function EventFrame:setNode (node) end
---* 
---@return self
function EventFrame:EventFrame () end