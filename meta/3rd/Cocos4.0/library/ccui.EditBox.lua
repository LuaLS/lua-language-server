---@meta

---@class ccui.EditBox :ccui.Widget@all parent class: Widget,IMEDelegate
local EditBox={ }
ccui.EditBox=EditBox




---* Get the font size.<br>
---* return The font size.
---@return int
function EditBox:getFontSize () end
---* js NA<br>
---* lua NA
---@param info cc.IMEKeyboardNotificationInfo
---@return self
function EditBox:keyboardDidShow (info) end
---* Sets the maximum input length of the edit box.<br>
---* Setting this value enables multiline input mode by default.<br>
---* Available on Android, iOS and Windows Phone.<br>
---* param maxLength The maximum length.
---@param maxLength int
---@return self
function EditBox:setMaxLength (maxLength) end
---* 
---@return self
function EditBox:openKeyboard () end
---* Set the font size.<br>
---* param fontSize The font size.
---@param fontSize int
---@return self
function EditBox:setFontSize (fontSize) end
---* Get the text entered in the edit box.<br>
---* return The text entered in the edit box.
---@return char
function EditBox:getText () end
---* Get the input mode of the edit box.<br>
---* return One of the EditBox::InputMode constants.
---@return int
function EditBox:getInputMode () end
---@overload fun(size_table:size_table,ccui.Scale9Sprite:ccui.Scale9Sprite):self
---@overload fun(size_table:size_table,ccui.Scale9Sprite1:string,ccui.Scale9Sprite2:int):self
---@overload fun(size_table:size_table,ccui.Scale9Sprite:ccui.Scale9Sprite,ccui.Scale9Sprite:ccui.Scale9Sprite,ccui.Scale9Sprite:ccui.Scale9Sprite):self
---@param size size_table
---@param normalSprite ccui.Scale9Sprite
---@param pressedSprite ccui.Scale9Sprite
---@param disabledSprite ccui.Scale9Sprite
---@return boolean
function EditBox:initWithSizeAndBackgroundSprite (size,normalSprite,pressedSprite,disabledSprite) end
---* Get the placeholder's font name. only system font is allowed.<br>
---* return The font name.
---@return char
function EditBox:getPlaceholderFontName () end
---* js NA<br>
---* lua NA
---@param info cc.IMEKeyboardNotificationInfo
---@return self
function EditBox:keyboardDidHide (info) end
---* Set the placeholder's font name. only system font is allowed.<br>
---* param pFontName The font name.
---@param pFontName char
---@return self
function EditBox:setPlaceholderFontName (pFontName) end
---* Get the placeholder's font size.<br>
---* return The font size.
---@return int
function EditBox:getPlaceholderFontSize () end
---* Return the capInsets of disabled state scale9sprite.<br>
---* return The disabled scale9 renderer capInsets.
---@return rect_table
function EditBox:getCapInsetsDisabledRenderer () end
---* Get a text in the edit box that acts as a placeholder when an<br>
---* edit box is empty.
---@return char
function EditBox:getPlaceHolder () end
---* Set the font name. Only system font is allowed.<br>
---* param pFontName The font name.
---@param pFontName char
---@return self
function EditBox:setFontName (pFontName) end
---* Registers a script function that will be called for EditBox events.<br>
---* This handler will be removed automatically after onExit() called.<br>
---* code<br>
---* -- lua sample<br>
---* local function editboxEventHandler(eventType)<br>
---* if eventType == "began" then<br>
---* -- triggered when an edit box gains focus after keyboard is shown<br>
---* elseif eventType == "ended" then<br>
---* -- triggered when an edit box loses focus after keyboard is hidden.<br>
---* elseif eventType == "changed" then<br>
---* -- triggered when the edit box text was changed.<br>
---* elseif eventType == "return" then<br>
---* -- triggered when the return button was pressed or the outside area of keyboard was touched.<br>
---* end<br>
---* end<br>
---* local editbox = EditBox:create(Size(...), Scale9Sprite:create(...))<br>
---* editbox = registerScriptEditBoxHandler(editboxEventHandler)<br>
---* endcode<br>
---* param handler A number that indicates a lua function.<br>
---* js NA<br>
---* lua NA
---@param handler int
---@return self
function EditBox:registerScriptEditBoxHandler (handler) end
---* Sets capInsets for edit box, only the disabled state scale9 renderer will be affected.<br>
---* param capInsets  capInsets in Rect.
---@param capInsets rect_table
---@return self
function EditBox:setCapInsetsDisabledRenderer (capInsets) end
---* Set the placeholder's font size.<br>
---* param fontSize The font size.
---@param fontSize int
---@return self
function EditBox:setPlaceholderFontSize (fontSize) end
---* Load disabled state texture for edit box.<br>
---* param disabled    dark state texture.<br>
---* param texType    @see `TextureResType`
---@param disabled string
---@param texType int
---@return self
function EditBox:loadTextureDisabled (disabled,texType) end
---* Set the input mode of the edit box.<br>
---* param inputMode One of the EditBox::InputMode constants.
---@param inputMode int
---@return self
function EditBox:setInputMode (inputMode) end
---* Unregisters a script function that will be called for EditBox events.<br>
---* js NA<br>
---* lua NA
---@return self
function EditBox:unregisterScriptEditBoxHandler () end
---* js NA<br>
---* lua NA
---@param info cc.IMEKeyboardNotificationInfo
---@return self
function EditBox:keyboardWillShow (info) end
---@overload fun(color3b_table0:color4b_table):self
---@overload fun(color3b_table:color3b_table):self
---@param color color3b_table
---@return self
function EditBox:setPlaceholderFontColor (color) end
---* Get the return type that are to be applied to the edit box.<br>
---* return One of the EditBox::KeyboardReturnType constants.
---@return int
function EditBox:getReturnType () end
---@overload fun(color3b_table0:color4b_table):self
---@overload fun(color3b_table:color3b_table):self
---@param color color3b_table
---@return self
function EditBox:setFontColor (color) end
---* Get the font name.<br>
---* return The font name.
---@return char
function EditBox:getFontName () end
---* js NA<br>
---* lua NA
---@param info cc.IMEKeyboardNotificationInfo
---@return self
function EditBox:keyboardWillHide (info) end
---* Sets capInsets for edit box, only the normal state scale9 renderer will be affected.<br>
---* param capInsets    capInsets in Rect.
---@param capInsets rect_table
---@return self
function EditBox:setCapInsetsNormalRenderer (capInsets) end
---* Load pressed state texture for edit box.<br>
---* param pressed    pressed state texture.<br>
---* param texType    @see `TextureResType`
---@param pressed string
---@param texType int
---@return self
function EditBox:loadTexturePressed (pressed,texType) end
---* Get the font color of the widget's text.
---@return color4b_table
function EditBox:getFontColor () end
---* Get the input flags that are to be applied to the edit box.<br>
---* return One of the EditBox::InputFlag constants.
---@return int
function EditBox:getInputFlag () end
---* Init edit box with specified size. This method should be invoked right after constructor.<br>
---* param size The size of edit box.<br>
---* param normalImage  normal state texture name.<br>
---* param pressedImage  pressed state texture name.<br>
---* param disabledImage  disabled state texture name.<br>
---* return Whether initialization is successfully or not.
---@param size size_table
---@param normalImage string
---@param pressedImage string
---@param disabledImage string
---@param texType int
---@return boolean
function EditBox:initWithSizeAndTexture (size,normalImage,pressedImage,disabledImage,texType) end
---* Get the text horizontal alignment.
---@return int
function EditBox:getTextHorizontalAlignment () end
---* Return the capInsets of normal state scale9sprite.<br>
---* return The normal scale9 renderer capInsets.
---@return rect_table
function EditBox:getCapInsetsNormalRenderer () end
---* Return the capInsets of pressed state scale9sprite.<br>
---* return The pressed scale9 renderer capInsets.
---@return rect_table
function EditBox:getCapInsetsPressedRenderer () end
---* get a script Handler<br>
---* js NA<br>
---* lua NA
---@return int
function EditBox:getScriptEditBoxHandler () end
---* Load textures for edit box.<br>
---* param normal    normal state texture name.<br>
---* param pressed    pressed state texture name.<br>
---* param disabled    disabled state texture name.<br>
---* param texType    @see `TextureResType`
---@param normal string
---@param pressed string
---@param disabled string
---@param texType int
---@return self
function EditBox:loadTextures (normal,pressed,disabled,texType) end
---* Set a text in the edit box that acts as a placeholder when an<br>
---* edit box is empty.<br>
---* param pText The given text.
---@param pText char
---@return self
function EditBox:setPlaceHolder (pText) end
---* Set the input flags that are to be applied to the edit box.<br>
---* param inputFlag One of the EditBox::InputFlag constants.
---@param inputFlag int
---@return self
function EditBox:setInputFlag (inputFlag) end
---* Set the return type that are to be applied to the edit box.<br>
---* param returnType One of the EditBox::KeyboardReturnType constants.
---@param returnType int
---@return self
function EditBox:setReturnType (returnType) end
---* Load normal state texture for edit box.<br>
---* param normal    normal state texture.<br>
---* param texType    @see `TextureResType`
---@param normal string
---@param texType int
---@return self
function EditBox:loadTextureNormal (normal,texType) end
---* Gets the maximum input length of the edit box.<br>
---* return Maximum input length.
---@return int
function EditBox:getMaxLength () end
---* Sets capInsets for edit box, only the pressed state scale9 renderer will be affected.<br>
---* param capInsets    capInsets in Rect
---@param capInsets rect_table
---@return self
function EditBox:setCapInsetsPressedRenderer (capInsets) end
---* Set the text entered in the edit box.<br>
---* param pText The given text.
---@param pText char
---@return self
function EditBox:setText (pText) end
---* Set the placeholder's font. Only system font is allowed.<br>
---* param pFontName The font name.<br>
---* param fontSize The font size.
---@param pFontName char
---@param fontSize int
---@return self
function EditBox:setPlaceholderFont (pFontName,fontSize) end
---* Get the font color of the placeholder text when the edit box is empty.
---@return color4b_table
function EditBox:getPlaceholderFontColor () end
---* Sets capInsets for edit box.<br>
---* param capInsets    capInset in Rect.
---@param capInsets rect_table
---@return self
function EditBox:setCapInsets (capInsets) end
---* Set the font. Only system font is allowed.<br>
---* param pFontName The font name.<br>
---* param fontSize The font size.
---@param pFontName char
---@param fontSize int
---@return self
function EditBox:setFont (pFontName,fontSize) end
---* Set the text horizontal alignment.
---@param alignment int
---@return self
function EditBox:setTextHorizontalAlignment (alignment) end
---@overload fun(size_table:size_table,string:string,string2:int):self
---@overload fun(size_table:size_table,string1:ccui.Scale9Sprite,string2:ccui.Scale9Sprite,string3:ccui.Scale9Sprite):self
---@overload fun(size_table:size_table,string:string,string:string,string:string,int:int):self
---@param size size_table
---@param normalImage string
---@param pressedImage string
---@param disabledImage string
---@param texType int
---@return self
function EditBox:create (size,normalImage,pressedImage,disabledImage,texType) end
---* 
---@param anchorPoint vec2_table
---@return self
function EditBox:setAnchorPoint (anchorPoint) end
---* js NA<br>
---* lua NA
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function EditBox:draw (renderer,parentTransform,parentFlags) end
---* Returns the "class name" of widget.
---@return string
function EditBox:getDescription () end
---* 
---@param pos vec2_table
---@return self
function EditBox:setPosition (pos) end
---* 
---@param visible boolean
---@return self
function EditBox:setVisible (visible) end
---* 
---@param size size_table
---@return self
function EditBox:setContentSize (size) end
---* Constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function EditBox:EditBox () end