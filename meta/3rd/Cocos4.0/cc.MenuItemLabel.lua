---@meta

---@class cc.MenuItemLabel :cc.MenuItem
local MenuItemLabel={ }
cc.MenuItemLabel=MenuItemLabel




---*  Sets the label that is rendered. 
---@param node cc.Node
---@return self
function MenuItemLabel:setLabel (node) end
---*  Get the inner string of the inner label. 
---@return string
function MenuItemLabel:getString () end
---*  Gets the color that will be used when the item is disabled. 
---@return color3b_table
function MenuItemLabel:getDisabledColor () end
---*  Sets a new string to the inner label. 
---@param label string
---@return self
function MenuItemLabel:setString (label) end
---*  Initializes a MenuItemLabel with a Label, target and selector. 
---@param label cc.Node
---@param callback function
---@return boolean
function MenuItemLabel:initWithLabel (label,callback) end
---*  Sets the color that will be used when the item is disabled. 
---@param color color3b_table
---@return self
function MenuItemLabel:setDisabledColor (color) end
---*  Gets the label that is rendered. 
---@return cc.Node
function MenuItemLabel:getLabel () end
---* 
---@param enabled boolean
---@return self
function MenuItemLabel:setEnabled (enabled) end
---* 
---@return self
function MenuItemLabel:activate () end
---* 
---@return self
function MenuItemLabel:unselected () end
---* 
---@return self
function MenuItemLabel:selected () end
---* js ctor
---@return self
function MenuItemLabel:MenuItemLabel () end