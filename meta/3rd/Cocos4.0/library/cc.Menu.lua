---@meta

---@class cc.Menu :cc.Layer
local Menu={ }
cc.Menu=Menu




---*  initializes a Menu with a NSArray of MenuItem objects 
---@param arrayOfItems array_table
---@return boolean
function Menu:initWithArray (arrayOfItems) end
---* Set whether the menu is enabled. If set to false, interacting with the menu<br>
---* will have no effect.<br>
---* The default value is true, a menu is enabled by default.<br>
---* param value true if menu is to be enabled, false if menu is to be disabled.
---@param value boolean
---@return self
function Menu:setEnabled (value) end
---*  Align items vertically. 
---@return self
function Menu:alignItemsVertically () end
---* Determines if the menu is enabled.<br>
---* see `setEnabled(bool)`.<br>
---* return whether the menu is enabled or not.
---@return boolean
function Menu:isEnabled () end
---*  Align items horizontally. 
---@return self
function Menu:alignItemsHorizontally () end
---*  Align items horizontally with padding.<br>
---* since v0.7.2
---@param padding float
---@return self
function Menu:alignItemsHorizontallyWithPadding (padding) end
---*  Align items vertically with padding.<br>
---* since v0.7.2
---@param padding float
---@return self
function Menu:alignItemsVerticallyWithPadding (padding) end
---@overload fun(cc.Node:cc.Node,int:int):self
---@overload fun(cc.Node:cc.Node):self
---@overload fun(cc.Node:cc.Node,int:int,string2:int):self
---@overload fun(cc.Node:cc.Node,int:int,string:string):self
---@param child cc.Node
---@param zOrder int
---@param name string
---@return self
function Menu:addChild (child,zOrder,name) end
---* 
---@return string
function Menu:getDescription () end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function Menu:removeChild (child,cleanup) end
---*  initializes an empty Menu 
---@return boolean
function Menu:init () end
---* 
---@param value boolean
---@return self
function Menu:setOpacityModifyRGB (value) end
---* 
---@return boolean
function Menu:isOpacityModifyRGB () end
---* js ctor
---@return self
function Menu:Menu () end