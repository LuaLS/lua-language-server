---@meta

---@class cc.MenuItemToggle :cc.MenuItem
local MenuItemToggle={ }
cc.MenuItemToggle=MenuItemToggle




---*  Sets the array that contains the subitems. 
---@param items array_table
---@return self
function MenuItemToggle:setSubItems (items) end
---*  Initializes a menu item with a item. 
---@param item cc.MenuItem
---@return boolean
function MenuItemToggle:initWithItem (item) end
---*  Gets the index of the selected item. 
---@return unsigned_int
function MenuItemToggle:getSelectedIndex () end
---*  Add more menu item. 
---@param item cc.MenuItem
---@return self
function MenuItemToggle:addSubItem (item) end
---*  Return the selected item. 
---@return cc.MenuItem
function MenuItemToggle:getSelectedItem () end
---*  Sets the index of the selected item. 
---@param index unsigned_int
---@return self
function MenuItemToggle:setSelectedIndex (index) end
---* 
---@param var boolean
---@return self
function MenuItemToggle:setEnabled (var) end
---* 
---@return self
function MenuItemToggle:cleanup () end
---* 
---@return self
function MenuItemToggle:activate () end
---* 
---@return self
function MenuItemToggle:unselected () end
---* 
---@return self
function MenuItemToggle:selected () end
---* js ctor
---@return self
function MenuItemToggle:MenuItemToggle () end