---@meta

---@class ccui.VBox :ccui.Layout
local VBox={ }
ccui.VBox=VBox




---* 
---@param size size_table
---@return boolean
function VBox:initWithSize (size) end
---@overload fun(size_table:size_table):self
---@overload fun():self
---@param size size_table
---@return self
function VBox:create (size) end
---* 
---@return boolean
function VBox:init () end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function VBox:VBox () end