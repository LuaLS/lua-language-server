---@meta

---@class ccs.MovementData :cc.Ref
local MovementData={ }
ccs.MovementData=MovementData




---* 
---@param boneName string
---@return ccs.MovementBoneData
function MovementData:getMovementBoneData (boneName) end
---* 
---@param movBoneData ccs.MovementBoneData
---@return self
function MovementData:addMovementBoneData (movBoneData) end
---* 
---@return self
function MovementData:create () end
---* js ctor
---@return self
function MovementData:MovementData () end