---@meta

---@class ccs.AnimationData :cc.Ref
local AnimationData={ }
ccs.AnimationData=AnimationData




---* 
---@param movementName string
---@return ccs.MovementData
function AnimationData:getMovement (movementName) end
---* 
---@return int
function AnimationData:getMovementCount () end
---* 
---@param movData ccs.MovementData
---@return self
function AnimationData:addMovement (movData) end
---* 
---@return self
function AnimationData:create () end
---* js ctor
---@return self
function AnimationData:AnimationData () end