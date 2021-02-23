---@meta

---@class ccs.BoneData :ccs.BaseData
local BoneData={ }
ccs.BoneData=BoneData




---* 
---@param index int
---@return ccs.DisplayData
function BoneData:getDisplayData (index) end
---* 
---@return boolean
function BoneData:init () end
---* 
---@param displayData ccs.DisplayData
---@return self
function BoneData:addDisplayData (displayData) end
---* 
---@return self
function BoneData:create () end
---* js ctor
---@return self
function BoneData:BoneData () end