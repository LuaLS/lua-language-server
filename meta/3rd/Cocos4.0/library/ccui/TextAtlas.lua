---@meta

---@class ccui.TextAtlas :ccui.Widget
local TextAtlas={ }
ccui.TextAtlas=TextAtlas




---* Gets the string length of the label.<br>
---* Note: This length will be larger than the raw string length,<br>
---* if you want to get the raw string length, you should call this->getString().size() instead<br>
---* return  string length.
---@return int
function TextAtlas:getStringLength () end
---* Get string value for labelatlas.<br>
---* return The string value of TextAtlas.
---@return string
function TextAtlas:getString () end
---* Set string value for labelatlas.<br>
---* param value A given string needs to be displayed.
---@param value string
---@return self
function TextAtlas:setString (value) end
---* 
---@return cc.ResourceData
function TextAtlas:getRenderFile () end
---*  Initializes the LabelAtlas with a string, a char map file(the atlas), the width and height of each element and the starting char of the atlas.<br>
---* param stringValue A given string needs to be displayed.<br>
---* param charMapFile A given char map file name.<br>
---* param itemWidth The element width.<br>
---* param itemHeight The element height.<br>
---* param startCharMap The starting char of the atlas.
---@param stringValue string
---@param charMapFile string
---@param itemWidth int
---@param itemHeight int
---@param startCharMap string
---@return self
function TextAtlas:setProperty (stringValue,charMapFile,itemWidth,itemHeight,startCharMap) end
---* js NA
---@return self
function TextAtlas:adaptRenderers () end
---@overload fun(string:string,string:string,int:int,int:int,string:string):self
---@overload fun():self
---@param stringValue string
---@param charMapFile string
---@param itemWidth int
---@param itemHeight int
---@param startCharMap string
---@return self
function TextAtlas:create (stringValue,charMapFile,itemWidth,itemHeight,startCharMap) end
---* 
---@return cc.Ref
function TextAtlas:createInstance () end
---* 
---@return cc.Node
function TextAtlas:getVirtualRenderer () end
---* Returns the "class name" of widget.
---@return string
function TextAtlas:getDescription () end
---* 
---@return size_table
function TextAtlas:getVirtualRendererSize () end
---* Default constructor.<br>
---* lua new
---@return self
function TextAtlas:TextAtlas () end