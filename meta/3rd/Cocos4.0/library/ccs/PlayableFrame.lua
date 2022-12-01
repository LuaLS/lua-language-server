---@meta

---@class ccs.PlayableFrame :ccs.Frame
local PlayableFrame={ }
ccs.PlayableFrame=PlayableFrame




---* 
---@param playact string
---@return self
function PlayableFrame:setPlayableAct (playact) end
---* 
---@return string
function PlayableFrame:getPlayableAct () end
---* 
---@return self
function PlayableFrame:create () end
---* 
---@return ccs.Frame
function PlayableFrame:clone () end
---* 
---@return self
function PlayableFrame:PlayableFrame () end