---@meta

---@class ccs.ArmatureData :cc.Ref
local ArmatureData={ }
ccs.ArmatureData=ArmatureData




---* 
---@param boneData ccs.BoneData
---@return self
function ArmatureData:addBoneData (boneData) end
---* 
---@return boolean
function ArmatureData:init () end
---* 
---@param boneName string
---@return ccs.BoneData
function ArmatureData:getBoneData (boneName) end
---* 
---@return self
function ArmatureData:create () end
---* js ctor
---@return self
function ArmatureData:ArmatureData () end