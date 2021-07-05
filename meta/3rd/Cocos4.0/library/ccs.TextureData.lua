---@meta

---@class ccs.TextureData :cc.Ref
local TextureData={ }
ccs.TextureData=TextureData




---* 
---@param index int
---@return ccs.ContourData
function TextureData:getContourData (index) end
---* 
---@return boolean
function TextureData:init () end
---* 
---@param contourData ccs.ContourData
---@return self
function TextureData:addContourData (contourData) end
---* 
---@return self
function TextureData:create () end
---* js ctor
---@return self
function TextureData:TextureData () end