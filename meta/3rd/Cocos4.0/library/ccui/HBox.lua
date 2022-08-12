---@meta

---@class ccui.HBox :ccui.Layout
local HBox={ }
ccui.HBox=HBox




---* 
---@param size size_table
---@return boolean
function HBox:initWithSize (size) end
---@overload fun(size_table:size_table):self
---@overload fun():self
---@param size size_table
---@return self
function HBox:create (size) end
---* 
---@return boolean
function HBox:init () end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function HBox:HBox () end