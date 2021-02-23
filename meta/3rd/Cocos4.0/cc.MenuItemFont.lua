---@meta

---@class cc.MenuItemFont :cc.MenuItemLabel
local MenuItemFont={ }
cc.MenuItemFont=MenuItemFont




---*  Returns the name of the Font.<br>
---* js getFontNameObj<br>
---* js NA
---@return string
function MenuItemFont:getFontNameObj () end
---* Set the font name .<br>
---* c++ can not overload static and non-static member functions with the same parameter types.<br>
---* so change the name to setFontNameObj.<br>
---* js setFontName<br>
---* js NA
---@param name string
---@return self
function MenuItemFont:setFontNameObj (name) end
---*  Initializes a menu item from a string with a target/selector. 
---@param value string
---@param callback function
---@return boolean
function MenuItemFont:initWithString (value,callback) end
---*  get font size .<br>
---* js getFontSize<br>
---* js NA
---@return int
function MenuItemFont:getFontSizeObj () end
---*  Set font size.<br>
---* c++ can not overload static and non-static member functions with the same parameter types.<br>
---* so change the name to setFontSizeObj.<br>
---* js setFontSize<br>
---* js NA
---@param size int
---@return self
function MenuItemFont:setFontSizeObj (size) end
---*  Set the default font name. 
---@param name string
---@return self
function MenuItemFont:setFontName (name) end
---*  Get default font size. 
---@return int
function MenuItemFont:getFontSize () end
---*  Get the default font name. 
---@return string
function MenuItemFont:getFontName () end
---*  Set default font size. 
---@param size int
---@return self
function MenuItemFont:setFontSize (size) end
---* js ctor
---@return self
function MenuItemFont:MenuItemFont () end