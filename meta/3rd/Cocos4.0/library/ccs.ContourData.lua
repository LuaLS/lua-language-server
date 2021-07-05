---@meta

---@class ccs.ContourData :cc.Ref
local ContourData={ }
ccs.ContourData=ContourData




---* 
---@return boolean
function ContourData:init () end
---* 
---@param vertex vec2_table
---@return self
function ContourData:addVertex (vertex) end
---* 
---@return self
function ContourData:create () end
---* js ctor
---@return self
function ContourData:ContourData () end