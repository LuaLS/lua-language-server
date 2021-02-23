---@meta

---@class cc.MenuItem :cc.Node
local MenuItem={ }
cc.MenuItem=MenuItem




---*  Enables or disables the item. 
---@param value boolean
---@return self
function MenuItem:setEnabled (value) end
---*  Activate the item. 
---@return self
function MenuItem:activate () end
---*  Returns whether or not the item is enabled. 
---@return boolean
function MenuItem:isEnabled () end
---*  The item was selected (not activated), similar to "mouse-over". 
---@return self
function MenuItem:selected () end
---*  Returns whether or not the item is selected. 
---@return boolean
function MenuItem:isSelected () end
---*  The item was unselected. 
---@return self
function MenuItem:unselected () end
---*  Returns the outside box. 
---@return rect_table
function MenuItem:rect () end
---* js NA
---@return string
function MenuItem:getDescription () end
---* js ctor
---@return self
function MenuItem:MenuItem () end