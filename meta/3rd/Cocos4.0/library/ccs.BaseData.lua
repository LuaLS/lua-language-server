---@meta

---@class ccs.BaseData :cc.Ref
local BaseData={ }
ccs.BaseData=BaseData




---* 
---@return color4b_table
function BaseData:getColor () end
---* 
---@param color color4b_table
---@return self
function BaseData:setColor (color) end
---* 
---@return self
function BaseData:create () end
---* js ctor
---@return self
function BaseData:BaseData () end