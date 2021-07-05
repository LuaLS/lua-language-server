---@meta

---@class ccui.Text :ccui.Widget@all parent class: Widget,BlendProtocol
local Text={ }
ccui.Text=Text




---* Enable shadow for the label.<br>
---* todo support blur for shadow effect<br>
---* param shadowColor The color of shadow effect.<br>
---* param offset The offset of shadow effect.<br>
---* param blurRadius The blur radius of shadow effect.
---@return self
function Text:enableShadow () end
---* Gets the font size of label.<br>
---* return The font size.
---@return float
function Text:getFontSize () end
---* Gets the string value of label.<br>
---* return String value.
---@return string
function Text:getString () end
---@overload fun(int:int):self
---@overload fun():self
---@param effect int
---@return self
function Text:disableEffect (effect) end
---* Return current effect type.
---@return int
function Text:getLabelEffectType () end
---*  Gets text color.<br>
---* return Text color.
---@return color4b_table
function Text:getTextColor () end
---* Returns the blending function that is currently being used.<br>
---* return A BlendFunc structure with source and destination factor which specified pixel arithmetic.<br>
---* js NA<br>
---* lua NA
---@return cc.BlendFunc
function Text:getBlendFunc () end
---*  Sets text vertical alignment.<br>
---* param alignment vertical text alignment type
---@param alignment int
---@return self
function Text:setTextVerticalAlignment (alignment) end
---* Sets the font name of label.<br>
---* If you are trying to use a system font, you could just pass a font name<br>
---* If you are trying to use a TTF, you should pass a file path to the TTF file<br>
---* Usage:<br>
---* code<br>
---* create a system font UIText<br>
---* Text *text = Text::create("Hello", "Arial", 20);<br>
---* it will change the font to system font no matter the previous font type is TTF or system font<br>
---* text->setFontName("Marfelt");<br>
---* it will change the font to TTF font no matter the previous font type is TTF or system font<br>
---* text->setFontName("xxxx/xxx.ttf");<br>
---* endcode<br>
---* param name Font name.
---@param name string
---@return self
function Text:setFontName (name) end
---* Sets the touch scale enabled of label.<br>
---* param enabled Touch scale enabled of label.
---@param enabled boolean
---@return self
function Text:setTouchScaleChangeEnabled (enabled) end
---* Return shadow effect offset value.
---@return size_table
function Text:getShadowOffset () end
---* Changes the string value of label.<br>
---* param text  String value.
---@param text string
---@return self
function Text:setString (text) end
---* Return the outline effect size value.
---@return int
function Text:getOutlineSize () end
---* 
---@param textContent string
---@param fontName string
---@param fontSize float
---@return boolean
function Text:init (textContent,fontName,fontSize) end
---* Return the shadow effect blur radius.
---@return float
function Text:getShadowBlurRadius () end
---* Gets the touch scale enabled of label.<br>
---* return  Touch scale enabled of label.
---@return boolean
function Text:isTouchScaleChangeEnabled () end
---*  Gets the font name.<br>
---* return Font name.
---@return string
function Text:getFontName () end
---* Sets the rendering size of the text, you should call this method<br>
---* along with calling `ignoreContentAdaptWithSize(false)`, otherwise the text area<br>
---* size is calculated by the real size of the text content.<br>
---* param size The text rendering area size.
---@param size size_table
---@return self
function Text:setTextAreaSize (size) end
---* Gets the string length of the label.<br>
---* Note: This length will be larger than the raw string length,<br>
---* if you want to get the raw string length,<br>
---* you should call this->getString().size() instead.<br>
---* return  String length.
---@return int
function Text:getStringLength () end
---*  Gets the render size in auto mode.<br>
---* return The size of render size in auto mode.
---@return size_table
function Text:getAutoRenderSize () end
---* Enable outline for the label.<br>
---* It only works on IOS and Android when you use System fonts.<br>
---* param outlineColor The color of outline.<br>
---* param outlineSize The size of outline.
---@param outlineColor color4b_table
---@param outlineSize int
---@return self
function Text:enableOutline (outlineColor,outlineSize) end
---* Return current effect color value.
---@return color4b_table
function Text:getEffectColor () end
---*  Gets the font type.<br>
---* return The font type.
---@return int
function Text:getType () end
---*  Gets text horizontal alignment.<br>
---* return Horizontal text alignment type
---@return int
function Text:getTextHorizontalAlignment () end
---* Return whether the shadow effect is enabled.
---@return boolean
function Text:isShadowEnabled () end
---* Sets the font size of label.<br>
---* param size The font size.
---@param size float
---@return self
function Text:setFontSize (size) end
---* Return the shadow effect color value.
---@return color4b_table
function Text:getShadowColor () end
---*  Sets text color.<br>
---* param color Text color.
---@param color color4b_table
---@return self
function Text:setTextColor (color) end
---*  Only support for TTF.<br>
---* param glowColor The color of glow.
---@param glowColor color4b_table
---@return self
function Text:enableGlow (glowColor) end
---* Provides a way to treat each character like a Sprite.<br>
---* warning No support system font.
---@param lettetIndex int
---@return cc.Sprite
function Text:getLetter (lettetIndex) end
---* Sets the source blending function.<br>
---* param blendFunc A structure with source and destination factor to specify pixel arithmetic. e.g. {BlendFactor::ONE, BlendFactor::ONE}, {BlendFactor::SRC_ALPHA, BlendFactor::ONE_MINUS_SRC_ALPHA}.<br>
---* js NA<br>
---* lua NA
---@param blendFunc cc.BlendFunc
---@return self
function Text:setBlendFunc (blendFunc) end
---*  Gets text vertical alignment.<br>
---* return Vertical text alignment type
---@return int
function Text:getTextVerticalAlignment () end
---*  Return the text rendering area size.<br>
---* return The text rendering area size.
---@return size_table
function Text:getTextAreaSize () end
---*  Sets text horizontal alignment.<br>
---* param alignment Horizontal text alignment type
---@param alignment int
---@return self
function Text:setTextHorizontalAlignment (alignment) end
---@overload fun(string:string,string:string,float:float):self
---@overload fun():self
---@param textContent string
---@param fontName string
---@param fontSize float
---@return self
function Text:create (textContent,fontName,fontSize) end
---* 
---@return cc.Ref
function Text:createInstance () end
---* 
---@return cc.Node
function Text:getVirtualRenderer () end
---* 
---@return boolean
function Text:init () end
---* Returns the "class name" of widget.
---@return string
function Text:getDescription () end
---* 
---@return size_table
function Text:getVirtualRendererSize () end
---* Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function Text:Text () end