---@meta

---@class ccui.Helper 
local Helper={ }
ccui.Helper=Helper




---* brief Get a UTF8 substring from a std::string with a given start position and length<br>
---* Sample:  std::string str = "中国中国中国";  substr = getSubStringOfUTF8String(str,0,2) will = "中国"<br>
---* param str The source string.<br>
---* param start The start position of the substring.<br>
---* param length The length of the substring in UTF8 count<br>
---* return a UTF8 substring<br>
---* js NA
---@param str string
---@param start unsigned_int
---@param length unsigned_int
---@return string
function Helper:getSubStringOfUTF8String (str,start,length) end
---* brief Convert a node's boundingBox rect into screen coordinates.<br>
---* param node Any node pointer.<br>
---* return A Rect in screen coordinates.
---@param node cc.Node
---@return rect_table
function Helper:convertBoundingBoxToScreen (node) end
---* Change the active property of Layout's @see `LayoutComponent`<br>
---* param active A boolean value.
---@param active boolean
---@return self
function Helper:changeLayoutSystemActiveState (active) end
---* Find a widget with a specific action tag from root widget<br>
---* This search will be recursive through all child widgets.<br>
---* param root The be searched root widget.<br>
---* param tag The widget action's tag.<br>
---* return Widget instance pointer.
---@param root ccui.Widget
---@param tag int
---@return ccui.Widget
function Helper:seekActionWidgetByActionTag (root,tag) end
---* Find a widget with a specific name from root widget.<br>
---* This search will be recursive through all child widgets.<br>
---* param root      The be searched root widget.<br>
---* param name      The widget name.<br>
---* return Widget instance pointer.
---@param root ccui.Widget
---@param name string
---@return ccui.Widget
function Helper:seekWidgetByName (root,name) end
---* Find a widget with a specific tag from root widget.<br>
---* This search will be recursive through all child widgets.<br>
---* param root      The be searched root widget.<br>
---* param tag       The widget tag.<br>
---* return Widget instance pointer.
---@param root ccui.Widget
---@param tag int
---@return ccui.Widget
function Helper:seekWidgetByTag (root,tag) end
---* brief  restrict capInsetSize, when the capInsets's width is larger than the textureSize, it will restrict to 0,<br>
---* the height goes the same way as width.<br>
---* param  capInsets A user defined capInsets.<br>
---* param  textureSize  The size of a scale9enabled texture<br>
---* return a restricted capInset.
---@param capInsets rect_table
---@param textureSize size_table
---@return rect_table
function Helper:restrictCapInsetRect (capInsets,textureSize) end
---* Refresh object and it's children layout state<br>
---* param rootNode   A Node* or Node* descendant instance pointer.
---@param rootNode cc.Node
---@return self
function Helper:doLayout (rootNode) end