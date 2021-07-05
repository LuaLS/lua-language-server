---@meta

---@class ccs.MovementBoneData :cc.Ref
local MovementBoneData={ }
ccs.MovementBoneData=MovementBoneData




---* 
---@return boolean
function MovementBoneData:init () end
---* 
---@param index int
---@return ccs.FrameData
function MovementBoneData:getFrameData (index) end
---* 
---@param frameData ccs.FrameData
---@return self
function MovementBoneData:addFrameData (frameData) end
---* 
---@return self
function MovementBoneData:create () end
---* js ctor
---@return self
function MovementBoneData:MovementBoneData () end