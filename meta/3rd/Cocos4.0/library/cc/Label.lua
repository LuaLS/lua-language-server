---@meta

---@class cc.Label :cc.Node@all parent class: Node,LabelProtocol,BlendProtocol
local Label={ }
cc.Label=Label




---* 
---@return boolean
function Label:isClipMarginEnabled () end
---* Enable shadow effect to Label.<br>
---* todo Support blur for shadow effect.
---@return self
function Label:enableShadow () end
---*  Sets the untransformed size of the Label in a more efficient way. 
---@param width float
---@param height float
---@return self
function Label:setDimensions (width,height) end
---* 
---@return float
function Label:getWidth () end
---*  Return the text the Label is currently displaying.
---@return string
function Label:getString () end
---* 
---@return float
function Label:getHeight () end
---@overload fun(int:int):self
---@overload fun():self
---@param effect int
---@return self
function Label:disableEffect (effect) end
---* Sets a new TTF configuration to Label.<br>
---* see `TTFConfig`
---@param ttfConfig cc._ttfConfig
---@return boolean
function Label:setTTFConfig (ttfConfig) end
---* Returns type of label<br>
---* warning Not support system font.<br>
---* return the type of label<br>
---* since v3.18.0
---@return int
function Label:getLabelType () end
---*  Returns the text color of the Label.
---@return color4b_table
function Label:getTextColor () end
---* 
---@return cc.BlendFunc
function Label:getBlendFunc () end
---* Toggle wrap option of the label.<br>
---* Note: System font doesn't support manually toggle wrap.<br>
---* param enable Set true to enable wrap and false to disable wrap.
---@param enable boolean
---@return self
function Label:enableWrap (enable) end
---* Makes the Label exactly this untransformed width.<br>
---* The Label's width be used for text align if the value not equal zero.
---@param width float
---@return self
function Label:setWidth (width) end
---* Returns the additional kerning of the Label.<br>
---* warning Not support system font.<br>
---* since v3.2.0
---@return float
function Label:getAdditionalKerning () end
---* Return the user define BMFont size.<br>
---* return The BMFont size in float value.
---@return float
function Label:getBMFontSize () end
---* 
---@return float
function Label:getMaxLineWidth () end
---*  Returns the Label's text horizontal alignment.
---@return int
function Label:getHorizontalAlignment () end
---* Return shadow effect offset value.
---@return size_table
function Label:getShadowOffset () end
---* 
---@return float
function Label:getLineSpacing () end
---*  Clips upper and lower margin to reduce height of Label.
---@param clipEnabled boolean
---@return self
function Label:setClipMarginEnabled (clipEnabled) end
---*  Sets the text that this Label is to display.
---@param text string
---@return self
function Label:setString (text) end
---* Sets a new system font to Label.<br>
---* param font A font file or a font family name.<br>
---* warning
---@param font string
---@return self
function Label:setSystemFontName (font) end
---* Query the wrap is enabled or not.<br>
---* Note: System font will always return true.
---@return boolean
function Label:isWrapEnabled () end
---* Return the outline effect size value.
---@return float
function Label:getOutlineSize () end
---*  Sets a new bitmap font to Label 
---@param bmfontFilePath string
---@param imageOffset vec2_table
---@param fontSize float
---@return boolean
function Label:setBMFontFilePath (bmfontFilePath,imageOffset,fontSize) end
---@overload fun(string0:cc._ttfConfig,string:string,float2:int,size_table3:int):self
---@overload fun(string:string,string:string,float:float,size_table:size_table,int:int,int:int):self
---@param text string
---@param fontFilePath string
---@param fontSize float
---@param dimensions size_table
---@param hAlignment int
---@param vAlignment int
---@return boolean
function Label:initWithTTF (text,fontFilePath,fontSize,dimensions,hAlignment,vAlignment) end
---* 
---@return cc.FontAtlas
function Label:getFontAtlas () end
---*  Sets the line height of the Label.<br>
---* warning Not support system font.<br>
---* since v3.2.0
---@param height float
---@return self
function Label:setLineHeight (height) end
---* 
---@param fontSize float
---@return self
function Label:setSystemFontSize (fontSize) end
---* Change the label's Overflow type, currently only TTF and BMFont support all the valid Overflow type.<br>
---* Char Map font supports all the Overflow type except for SHRINK, because we can't measure it's font size.<br>
---* System font only support Overflow::Normal and Overflow::RESIZE_HEIGHT.<br>
---* param overflow   see `Overflow`
---@param overflow int
---@return self
function Label:setOverflow (overflow) end
---* Enables strikethrough.<br>
---* Underline and Strikethrough cannot be enabled at the same time.<br>
---* Strikethrough is like an underline but at the middle of the glyph
---@return self
function Label:enableStrikethrough () end
---*  Update content immediately.
---@return self
function Label:updateContent () end
---* Return length of string.
---@return int
function Label:getStringLength () end
---* Specify what happens when a line is too long for Label.<br>
---* param breakWithoutSpace Lines are automatically broken between words if this value is false.
---@param breakWithoutSpace boolean
---@return self
function Label:setLineBreakWithoutSpace (breakWithoutSpace) end
---* Return the number of lines of text.
---@return int
function Label:getStringNumLines () end
---* Enable outline effect to Label.<br>
---* warning Limiting use to only when the Label created with true type font or system font.
---@param outlineColor color4b_table
---@param outlineSize int
---@return self
function Label:enableOutline (outlineColor,outlineSize) end
---* Return the shadow effect blur radius.
---@return float
function Label:getShadowBlurRadius () end
---* Return current effect color value.
---@return color4f_table
function Label:getEffectColor () end
---* 
---@param cleanup boolean
---@return self
function Label:removeAllChildrenWithCleanup (cleanup) end
---@overload fun(string0:cc.Texture2D,int:int,int:int,int:int):self
---@overload fun(string:string,int:int,int:int,int:int):self
---@overload fun(string:string):self
---@param charMapFile string
---@param itemWidth int
---@param itemHeight int
---@param startCharMap int
---@return boolean
function Label:setCharMap (charMapFile,itemWidth,itemHeight,startCharMap) end
---* 
---@return size_table
function Label:getDimensions () end
---* Makes the Label at most this line untransformed width.<br>
---* The Label's max line width be used for force line breaks if the value not equal zero.
---@param maxLineWidth float
---@return self
function Label:setMaxLineWidth (maxLineWidth) end
---*  Returns the system font used by the Label.
---@return string
function Label:getSystemFontName () end
---*  Sets the Label's text vertical alignment.
---@param vAlignment int
---@return self
function Label:setVerticalAlignment (vAlignment) end
---* 
---@param height float
---@return self
function Label:setLineSpacing (height) end
---* Returns font size
---@return float
function Label:getRenderingFontSize () end
---* Returns the line height of this Label.<br>
---* warning Not support system font.<br>
---* since v3.2.0
---@return float
function Label:getLineHeight () end
---* Return the shadow effect color value.
---@return color4f_table
function Label:getShadowColor () end
---* Returns the TTF configuration object used by the Label.<br>
---* see `TTFConfig`
---@return cc._ttfConfig
function Label:getTTFConfig () end
---* Enable italics rendering
---@return self
function Label:enableItalics () end
---* Sets the text color of Label.<br>
---* The text color is different from the color of Node.<br>
---* warning Limiting use to only when the Label created with true type font or system font.
---@param color color4b_table
---@return self
function Label:setTextColor (color) end
---* Provides a way to treat each character like a Sprite.<br>
---* warning No support system font.
---@param lettetIndex int
---@return cc.Sprite
function Label:getLetter (lettetIndex) end
---* Makes the Label exactly this untransformed height.<br>
---* The Label's height be used for text align if the value not equal zero.<br>
---* The text will display incomplete if the size of Label is not large enough to display all text.
---@param height float
---@return self
function Label:setHeight (height) end
---* Return whether the shadow effect is enabled.
---@return boolean
function Label:isShadowEnabled () end
---* Enable glow effect to Label.<br>
---* warning Limiting use to only when the Label created with true type font.
---@param glowColor color4b_table
---@return self
function Label:enableGlow (glowColor) end
---* Query the label's Overflow type.<br>
---* return see `Overflow`
---@return int
function Label:getOverflow () end
---*  Returns the Label's text vertical alignment.
---@return int
function Label:getVerticalAlignment () end
---* Sets the additional kerning of the Label.<br>
---* warning Not support system font.<br>
---* since v3.2.0
---@param space float
---@return self
function Label:setAdditionalKerning (space) end
---*  Returns the bitmap font path used by the Label.
---@return float
function Label:getSystemFontSize () end
---* 
---@param blendFunc cc.BlendFunc
---@return self
function Label:setBlendFunc (blendFunc) end
---*  Returns the Label's text horizontal alignment.
---@return int
function Label:getTextAlignment () end
---*  Returns the bitmap font used by the Label.
---@return string
function Label:getBMFontFilePath () end
---*  Sets the Label's text horizontal alignment.
---@param hAlignment int
---@return self
function Label:setHorizontalAlignment (hAlignment) end
---* Enable bold rendering
---@return self
function Label:enableBold () end
---* Enable underline
---@return self
function Label:enableUnderline () end
---* Return current effect type.
---@return int
function Label:getLabelEffectType () end
---@overload fun(int:int,int:int):self
---@overload fun(int:int):self
---@param hAlignment int
---@param vAlignment int
---@return self
function Label:setAlignment (hAlignment,vAlignment) end
---* warning This method is not recommended for game developers.
---@return self
function Label:requestSystemFontRefresh () end
---* Change font size of label type BMFONT<br>
---* Note: This function only scale the BMFONT letter to mimic the font size change effect.<br>
---* param fontSize The desired font size in float.
---@param fontSize float
---@return self
function Label:setBMFontSize (fontSize) end
---* Allocates and initializes a Label, with a bitmap font file.<br>
---* param bmfontPath A bitmap font file, it's a FNT format.<br>
---* param text The initial text.<br>
---* param hAlignment Text horizontal alignment.<br>
---* param maxLineWidth The max line width.<br>
---* param imageOffset<br>
---* return An automatically released Label object.<br>
---* see setBMFontFilePath setMaxLineWidth
---@param bmfontPath string
---@param text string
---@param hAlignment int
---@param maxLineWidth int
---@param imageOffset vec2_table
---@return self
function Label:createWithBMFont (bmfontPath,text,hAlignment,maxLineWidth,imageOffset) end
---* Allocates and initializes a Label, with default settings.<br>
---* return An automatically released Label object.
---@return self
function Label:create () end
---@overload fun(string0:cc.Texture2D,int:int,int:int,int:int):self
---@overload fun(string:string,int:int,int:int,int:int):self
---@overload fun(string:string):self
---@param charMapFile string
---@param itemWidth int
---@param itemHeight int
---@param startCharMap int
---@return self
function Label:createWithCharMap (charMapFile,itemWidth,itemHeight,startCharMap) end
---* Allocates and initializes a Label, base on platform-dependent API.<br>
---* param text The initial text.<br>
---* param font A font file or a font family name.<br>
---* param fontSize The font size. This value must be > 0.<br>
---* param dimensions<br>
---* param hAlignment The text horizontal alignment.<br>
---* param vAlignment The text vertical alignment.<br>
---* warning It will generate texture by the platform-dependent code.<br>
---* return An automatically released Label object.
---@param text string
---@param font string
---@param fontSize float
---@param dimensions size_table
---@param hAlignment int
---@param vAlignment int
---@return self
function Label:createWithSystemFont (text,font,fontSize,dimensions,hAlignment,vAlignment) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function Label:draw (renderer,transform,flags) end
---* 
---@return boolean
function Label:isOpacityModifyRGB () end
---* 
---@param mask unsigned short
---@param applyChildren boolean
---@return self
function Label:setCameraMask (mask,applyChildren) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function Label:removeChild (child,cleanup) end
---* 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function Label:visit (renderer,parentTransform,parentFlags) end
---* 
---@return string
function Label:getDescription () end
---* 
---@param isOpacityModifyRGB boolean
---@return self
function Label:setOpacityModifyRGB (isOpacityModifyRGB) end
---* 
---@param parentOpacity unsigned_char
---@return self
function Label:updateDisplayedOpacity (parentOpacity) end
---* set ProgramState of current render command
---@param programState cc.backend.ProgramState
---@return self
function Label:setProgramState (programState) end
---* 
---@return size_table
function Label:getContentSize () end
---* 
---@return rect_table
function Label:getBoundingBox () end
---* 
---@param parentColor color3b_table
---@return self
function Label:updateDisplayedColor (parentColor) end
---* 
---@param globalZOrder float
---@return self
function Label:setGlobalZOrder (globalZOrder) end