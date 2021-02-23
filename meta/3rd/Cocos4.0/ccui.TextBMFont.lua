---@meta

---@class ccui.TextBMFont :ccui.Widget
local TextBMFont={ }
ccui.TextBMFont=TextBMFont




---* Gets the string length of the label.<br>
---* Note: This length will be larger than the raw string length,<br>
---* if you want to get the raw string length, you should call this->getString().size() instead<br>
---* return  string length.
---@return int
function TextBMFont:getStringLength () end
---*  get string value for labelbmfont
---@return string
function TextBMFont:getString () end
---*  set string value for labelbmfont
---@param value string
---@return self
function TextBMFont:setString (value) end
---* 
---@return cc.ResourceData
function TextBMFont:getRenderFile () end
---*  init a bitmap font atlas with an initial string and the FNT file 
---@param fileName string
---@return self
function TextBMFont:setFntFile (fileName) end
---* reset TextBMFont inner label
---@return self
function TextBMFont:resetRender () end
---@overload fun(string:string,string:string):self
---@overload fun():self
---@param text string
---@param filename string
---@return self
function TextBMFont:create (text,filename) end
---* 
---@return cc.Ref
function TextBMFont:createInstance () end
---* 
---@return cc.Node
function TextBMFont:getVirtualRenderer () end
---* Returns the "class name" of widget.
---@return string
function TextBMFont:getDescription () end
---* 
---@return size_table
function TextBMFont:getVirtualRendererSize () end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function TextBMFont:TextBMFont () end