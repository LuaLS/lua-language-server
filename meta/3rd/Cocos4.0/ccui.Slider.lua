---@meta

---@class ccui.Slider :ccui.Widget
local Slider={ }
ccui.Slider=Slider




---* Changes the progress direction of slider.<br>
---* param percent  Percent value from 1 to 100.
---@param percent int
---@return self
function Slider:setPercent (percent) end
---* Query the maximum percent of Slider. The default value is 100.<br>
---* since v3.7<br>
---* return The maximum percent of the Slider.
---@return int
function Slider:getMaxPercent () end
---* Load normal state texture for slider ball.<br>
---* param normal    Normal state texture.<br>
---* param resType    @see TextureResType .
---@param normal string
---@param resType int
---@return self
function Slider:loadSlidBallTextureNormal (normal,resType) end
---* Load dark state texture for slider progress bar.<br>
---* param fileName   File path of texture.<br>
---* param resType    @see TextureResType .
---@param fileName string
---@param resType int
---@return self
function Slider:loadProgressBarTexture (fileName,resType) end
---* 
---@return cc.ResourceData
function Slider:getBallNormalFile () end
---* 
---@return cc.Sprite
function Slider:getSlidBallDisabledRenderer () end
---* Sets if slider is using scale9 renderer.<br>
---* param able True that using scale9 renderer, false otherwise.
---@param able boolean
---@return self
function Slider:setScale9Enabled (able) end
---* 
---@return cc.ResourceData
function Slider:getBallPressedFile () end
---* brief Return a zoom scale<br>
---* since v3.3
---@return float
function Slider:getZoomScale () end
---* Sets capinsets for progress bar slider, if slider is using scale9 renderer.<br>
---* param capInsets Capinsets for progress bar slider.<br>
---* js NA
---@param capInsets rect_table
---@return self
function Slider:setCapInsetProgressBarRenderer (capInsets) end
---* Load textures for slider ball.<br>
---* param normal     Normal state texture.<br>
---* param pressed    Pressed state texture.<br>
---* param disabled    Disabled state texture.<br>
---* param texType    @see TextureResType .
---@param normal string
---@param pressed string
---@param disabled string
---@param texType int
---@return self
function Slider:loadSlidBallTextures (normal,pressed,disabled,texType) end
---* 
---@return cc.Node
function Slider:getSlidBallRenderer () end
---* Add call back function called when slider's percent has changed to slider.<br>
---* param callback An given call back function called when slider's percent has changed to slider.
---@param callback function
---@return self
function Slider:addEventListener (callback) end
---* Set a large value could give more control to the precision.<br>
---* since v3.7<br>
---* param percent The max percent of Slider.
---@param percent int
---@return self
function Slider:setMaxPercent (percent) end
---* Load texture for slider bar.<br>
---* param fileName   File name of texture.<br>
---* param resType    @see TextureResType .
---@param fileName string
---@param resType int
---@return self
function Slider:loadBarTexture (fileName,resType) end
---* 
---@return cc.ResourceData
function Slider:getProgressBarFile () end
---* Gets capinsets for bar slider, if slider is using scale9 renderer.<br>
---* return capInsets Capinsets for bar slider.
---@return rect_table
function Slider:getCapInsetsBarRenderer () end
---* Updates the visual elements of the slider.
---@return self
function Slider:updateVisualSlider () end
---* Gets capinsets for progress bar slider, if slider is using scale9 renderer.<br>
---* return Capinsets for progress bar slider.<br>
---* js NA
---@return rect_table
function Slider:getCapInsetsProgressBarRenderer () end
---* 
---@return cc.Sprite
function Slider:getSlidBallPressedRenderer () end
---* Load pressed state texture for slider ball.<br>
---* param pressed    Pressed state texture.<br>
---* param resType    @see TextureResType .
---@param pressed string
---@param resType int
---@return self
function Slider:loadSlidBallTexturePressed (pressed,resType) end
---* 
---@return cc.ResourceData
function Slider:getBackFile () end
---* Gets If slider is using scale9 renderer.<br>
---* return True that using scale9 renderer, false otherwise.
---@return boolean
function Slider:isScale9Enabled () end
---* 
---@return cc.ResourceData
function Slider:getBallDisabledFile () end
---* Sets capinsets for bar slider, if slider is using scale9 renderer.<br>
---* param capInsets Capinsets for bar slider.
---@param capInsets rect_table
---@return self
function Slider:setCapInsetsBarRenderer (capInsets) end
---* Gets the progress direction of slider.<br>
---* return percent Percent value from 1 to 100.
---@return int
function Slider:getPercent () end
---* Sets capinsets for slider, if slider is using scale9 renderer.<br>
---* param capInsets Capinsets for slider.
---@param capInsets rect_table
---@return self
function Slider:setCapInsets (capInsets) end
---* Load disabled state texture for slider ball.<br>
---* param disabled   Disabled state texture.<br>
---* param resType    @see TextureResType .
---@param disabled string
---@param resType int
---@return self
function Slider:loadSlidBallTextureDisabled (disabled,resType) end
---* 
---@return cc.Sprite
function Slider:getSlidBallNormalRenderer () end
---*  When user pressed the button, the button will zoom to a scale.<br>
---* The final scale of the button  equals (button original scale + _zoomScale)<br>
---* since v3.3
---@param scale float
---@return self
function Slider:setZoomScale (scale) end
---@overload fun(string:string,string:string,int:int):self
---@overload fun():self
---@param barTextureName string
---@param normalBallTextureName string
---@param resType int
---@return self
function Slider:create (barTextureName,normalBallTextureName,resType) end
---* 
---@return cc.Ref
function Slider:createInstance () end
---* 
---@return cc.Node
function Slider:getVirtualRenderer () end
---* 
---@param ignore boolean
---@return self
function Slider:ignoreContentAdaptWithSize (ignore) end
---* Returns the "class name" of widget.
---@return string
function Slider:getDescription () end
---* 
---@param pt vec2_table
---@param camera cc.Camera
---@param p vec3_table
---@return boolean
function Slider:hitTest (pt,camera,p) end
---* 
---@return boolean
function Slider:init () end
---* 
---@return size_table
function Slider:getVirtualRendererSize () end
---* Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function Slider:Slider () end