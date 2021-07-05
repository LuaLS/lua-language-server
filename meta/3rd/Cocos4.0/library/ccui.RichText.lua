---@meta

---@class ccui.RichText :ccui.Widget
local RichText={ }
ccui.RichText=RichText




---* brief Insert a RichElement at a given index.<br>
---* param element A RichElement type.<br>
---* param index A given index.
---@param element ccui.RichElement
---@param index int
---@return self
function RichText:insertElement (element,index) end
---*  @brief enable the outline of a-tag 
---@param enable boolean
---@param outlineColor color3b_table
---@param outlineSize int
---@return self
function RichText:setAnchorTextOutline (enable,outlineColor,outlineSize) end
---* 
---@return float
function RichText:getFontSize () end
---* brief Add a RichElement at the end of RichText.<br>
---* param element A RichElement instance.
---@param element ccui.RichElement
---@return self
function RichText:pushBackElement (element) end
---* 
---@param enable boolean
---@return self
function RichText:setAnchorTextBold (enable) end
---* 
---@return string
function RichText:getAnchorFontColor () end
---* 
---@return int
function RichText:getAnchorTextShadowBlurRadius () end
---*  @brief enable the shadow of a-tag 
---@param enable boolean
---@param shadowColor color3b_table
---@param offset size_table
---@param blurRadius int
---@return self
function RichText:setAnchorTextShadow (enable,shadowColor,offset,blurRadius) end
---* 
---@return boolean
function RichText:isAnchorTextItalicEnabled () end
---* 
---@param color string
---@return self
function RichText:setAnchorFontColor (color) end
---* 
---@param face string
---@return self
function RichText:setFontFace (face) end
---* 
---@param enable boolean
---@param glowColor color3b_table
---@return self
function RichText:setAnchorTextGlow (enable,glowColor) end
---* 
---@return int
function RichText:getHorizontalAlignment () end
---* 
---@param a int
---@return self
function RichText:setHorizontalAlignment (a) end
---* 
---@param enable boolean
---@return self
function RichText:setAnchorTextDel (enable) end
---* 
---@return color3b_table
function RichText:getAnchorTextOutlineColor3B () end
---* 
---@param color4b color4b_table
---@return string
function RichText:stringWithColor4B (color4b) end
---* 
---@param xml string
---@param defaults map_table
---@param handleOpenUrl function
---@return boolean
function RichText:initWithXML (xml,defaults,handleOpenUrl) end
---* 
---@return color3b_table
function RichText:getAnchorFontColor3B () end
---* brief Rearrange all RichElement in the RichText.<br>
---* It's usually called internally.
---@return self
function RichText:formatText () end
---* 
---@return color3b_table
function RichText:getAnchorTextGlowColor3B () end
---* 
---@param url string
---@return self
function RichText:openUrl (url) end
---* 
---@return string
function RichText:getFontFace () end
---* 
---@param color string
---@return self
function RichText:setFontColor (color) end
---* 
---@return boolean
function RichText:isAnchorTextGlowEnabled () end
---* 
---@return map_table
function RichText:getDefaults () end
---* 
---@return boolean
function RichText:isAnchorTextUnderlineEnabled () end
---* 
---@return string
function RichText:getFontColor () end
---* 
---@return boolean
function RichText:isAnchorTextShadowEnabled () end
---* 
---@return int
function RichText:getAnchorTextOutlineSize () end
---* brief Set vertical space between each RichElement.<br>
---* param space Point in float.
---@param space float
---@return self
function RichText:setVerticalSpace (space) end
---* 
---@return boolean
function RichText:isAnchorTextDelEnabled () end
---* 
---@param defaults map_table
---@return self
function RichText:setDefaults (defaults) end
---* 
---@param wrapMode int
---@return self
function RichText:setWrapMode (wrapMode) end
---* 
---@param size float
---@return self
function RichText:setFontSize (size) end
---@overload fun(int0:ccui.RichElement):self
---@overload fun(int:int):self
---@param index int
---@return self
function RichText:removeElement (index) end
---* 
---@param enable boolean
---@return self
function RichText:setAnchorTextItalic (enable) end
---* 
---@return size_table
function RichText:getAnchorTextShadowOffset () end
---* 
---@return boolean
function RichText:isAnchorTextBoldEnabled () end
---* 
---@return color3b_table
function RichText:getAnchorTextShadowColor3B () end
---* 
---@param color3b color3b_table
---@return string
function RichText:stringWithColor3B (color3b) end
---* 
---@return boolean
function RichText:isAnchorTextOutlineEnabled () end
---* 
---@return color3b_table
function RichText:getFontColor3B () end
---* 
---@return int
function RichText:getWrapMode () end
---* 
---@param enable boolean
---@return self
function RichText:setAnchorTextUnderline (enable) end
---* 
---@param color string
---@return color3b_table
function RichText:color3BWithString (color) end
---* brief Create a empty RichText.<br>
---* return RichText instance.
---@return self
function RichText:create () end
---* brief Create a RichText from an XML<br>
---* return RichText instance.
---@param xml string
---@param defaults map_table
---@param handleOpenUrl function
---@return self
function RichText:createWithXML (xml,defaults,handleOpenUrl) end
---* 
---@return boolean
function RichText:init () end
---* 
---@return string
function RichText:getDescription () end
---* 
---@param ignore boolean
---@return self
function RichText:ignoreContentAdaptWithSize (ignore) end
---* brief Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function RichText:RichText () end