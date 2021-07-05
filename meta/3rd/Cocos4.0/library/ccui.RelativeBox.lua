---@meta

---@class ccui.RelativeBox :ccui.Layout
local RelativeBox={ }
ccui.RelativeBox=RelativeBox




---* 
---@param size size_table
---@return boolean
function RelativeBox:initWithSize (size) end
---@overload fun(size_table:size_table):self
---@overload fun():self
---@param size size_table
---@return self
function RelativeBox:create (size) end
---* 
---@return boolean
function RelativeBox:init () end
---* Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function RelativeBox:RelativeBox () end