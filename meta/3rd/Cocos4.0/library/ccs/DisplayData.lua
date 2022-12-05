---@meta

---@class ccs.DisplayData :cc.Ref
local DisplayData={ }
ccs.DisplayData=DisplayData




---* 
---@param displayData ccs.DisplayData
---@return self
function DisplayData:copy (displayData) end
---* 
---@param displayName string
---@return string
function DisplayData:changeDisplayToTexture (displayName) end
---* 
---@return self
function DisplayData:create () end
---* js ctor
---@return self
function DisplayData:DisplayData () end