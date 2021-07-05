---@meta

---@class ccui.Button :ccui.Widget
local Button={ }
ccui.Button=Button




---* 
---@return size_table
function Button:getNormalTextureSize () end
---* Query the button title content.<br>
---* return Get the button's title content.
---@return string
function Button:getTitleText () end
---*  replaces the current Label node with a new one 
---@param label cc.Label
---@return self
function Button:setTitleLabel (label) end
---* Change the font size of button's title<br>
---* param size Title font size in float.
---@param size float
---@return self
function Button:setTitleFontSize (size) end
---* 
---@return self
function Button:resetPressedRender () end
---* Enable scale9 renderer.<br>
---* param enable Set to true will use scale9 renderer, false otherwise.
---@param enable boolean
---@return self
function Button:setScale9Enabled (enable) end
---* 
---@return self
function Button:resetDisabledRender () end
---* Return the inner title renderer of Button.<br>
---* return The button title.<br>
---* since v3.3
---@return cc.Label
function Button:getTitleRenderer () end
---* brief Return the nine-patch sprite of clicked state<br>
---* return the nine-patch sprite of clicked state<br>
---* since v3.9
---@return ccui.Scale9Sprite
function Button:getRendererClicked () end
---* 
---@return cc.ResourceData
function Button:getDisabledFile () end
---* brief Return a zoom scale<br>
---* return the zoom scale in float<br>
---* since v3.3
---@return float
function Button:getZoomScale () end
---* Return the capInsets of disabled state scale9sprite.<br>
---* return The disabled scale9 renderer capInsets.
---@return rect_table
function Button:getCapInsetsDisabledRenderer () end
---* Change the color of button's title.<br>
---* param color The title color in Color3B.
---@param color color3b_table
---@return self
function Button:setTitleColor (color) end
---* 
---@return cc.ResourceData
function Button:getNormalFile () end
---* 
---@return self
function Button:resetNormalRender () end
---* brief Return the nine-patch sprite of disabled state<br>
---* return the nine-patch sprite of disabled state<br>
---* since v3.9
---@return ccui.Scale9Sprite
function Button:getRendererDisabled () end
---* Sets capInsets for button, only the disabled state scale9 renderer will be affected.<br>
---* param capInsets  capInsets in Rect.
---@param capInsets rect_table
---@return self
function Button:setCapInsetsDisabledRenderer (capInsets) end
---* Sets capInsets for button.<br>
---* The capInset affects  all button scale9 renderer only if `setScale9Enabled(true)` is called<br>
---* param capInsets    capInset in Rect.
---@param capInsets rect_table
---@return self
function Button:setCapInsets (capInsets) end
---* Load disabled state texture for button.<br>
---* param disabled    dark state texture.<br>
---* param texType    @see `TextureResType`
---@param disabled string
---@param texType int
---@return self
function Button:loadTextureDisabled (disabled,texType) end
---* 
---@param normalImage string
---@param selectedImage string
---@param disableImage string
---@param texType int
---@return boolean
function Button:init (normalImage,selectedImage,disableImage,texType) end
---* Change the content of button's title.<br>
---* param text The title in std::string.
---@param text string
---@return self
function Button:setTitleText (text) end
---* Sets capInsets for button, only the normal state scale9 renderer will be affected.<br>
---* param capInsets    capInsets in Rect.
---@param capInsets rect_table
---@return self
function Button:setCapInsetsNormalRenderer (capInsets) end
---* Load selected state texture for button.<br>
---* param selected    selected state texture.<br>
---* param texType    @see `TextureResType`
---@param selected string
---@param texType int
---@return self
function Button:loadTexturePressed (selected,texType) end
---* Change the font name of button's title<br>
---* param fontName a font name string.
---@param fontName string
---@return self
function Button:setTitleFontName (fontName) end
---* Return the capInsets of normal state scale9sprite.<br>
---* return The normal scale9 renderer capInsets.
---@return rect_table
function Button:getCapInsetsNormalRenderer () end
---@overload fun(int:int,int:int):self
---@overload fun(int:int):self
---@param hAlignment int
---@param vAlignment int
---@return self
function Button:setTitleAlignment (hAlignment,vAlignment) end
---* Return the capInsets of pressed state scale9sprite.<br>
---* return The pressed scale9 renderer capInsets.
---@return rect_table
function Button:getCapInsetsPressedRenderer () end
---* Load textures for button.<br>
---* param normal    normal state texture name.<br>
---* param selected    selected state texture name.<br>
---* param disabled    disabled state texture name.<br>
---* param texType    @see `TextureResType`
---@param normal string
---@param selected string
---@param disabled string
---@param texType int
---@return self
function Button:loadTextures (normal,selected,disabled,texType) end
---* Query whether button is using scale9 renderer or not.<br>
---* return whether button use scale9 renderer or not.
---@return boolean
function Button:isScale9Enabled () end
---* Load normal state texture for button.<br>
---* param normal    normal state texture.<br>
---* param texType    @see `TextureResType`
---@param normal string
---@param texType int
---@return self
function Button:loadTextureNormal (normal,texType) end
---* Sets capInsets for button, only the pressed state scale9 renderer will be affected.<br>
---* param capInsets    capInsets in Rect
---@param capInsets rect_table
---@return self
function Button:setCapInsetsPressedRenderer (capInsets) end
---* 
---@return cc.ResourceData
function Button:getPressedFile () end
---*  returns the current Label being used 
---@return cc.Label
function Button:getTitleLabel () end
---* Query the font size of button title<br>
---* return font size in float.
---@return float
function Button:getTitleFontSize () end
---* brief Return the nine-patch sprite of normal state<br>
---* return the nine-patch sprite of normal state<br>
---* since v3.9
---@return ccui.Scale9Sprite
function Button:getRendererNormal () end
---* Query the font name of button's title<br>
---* return font name in std::string
---@return string
function Button:getTitleFontName () end
---* Query the button title color.<br>
---* return Color3B of button title.
---@return color3b_table
function Button:getTitleColor () end
---* Enable zooming action when button is pressed.<br>
---* param enabled Set to true will enable zoom effect, false otherwise.
---@param enabled boolean
---@return self
function Button:setPressedActionEnabled (enabled) end
---*  @brief When user pressed the button, the button will zoom to a scale.<br>
---* The final scale of the button  equals (button original scale + _zoomScale)<br>
---* since v3.3
---@param scale float
---@return self
function Button:setZoomScale (scale) end
---@overload fun(string:string,string:string,string:string,int:int):self
---@overload fun():self
---@param normalImage string
---@param selectedImage string
---@param disableImage string
---@param texType int
---@return self
function Button:create (normalImage,selectedImage,disableImage,texType) end
---* 
---@return cc.Ref
function Button:createInstance () end
---* 
---@return cc.Node
function Button:getVirtualRenderer () end
---* 
---@return boolean
function Button:init () end
---* 
---@return string
function Button:getDescription () end
---* 
---@return size_table
function Button:getVirtualRendererSize () end
---* 
---@param ignore boolean
---@return self
function Button:ignoreContentAdaptWithSize (ignore) end
---* Default constructor.
---@return self
function Button:Button () end