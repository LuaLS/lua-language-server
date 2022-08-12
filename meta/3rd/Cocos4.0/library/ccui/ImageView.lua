---@meta

---@class ccui.ImageView :ccui.Widget@all parent class: Widget,BlendProtocol
local ImageView={ }
ccui.ImageView=ImageView




---* Returns the blending function that is currently being used.<br>
---* return A BlendFunc structure with source and destination factor which specified pixel arithmetic.<br>
---* js NA<br>
---* lua NA
---@return cc.BlendFunc
function ImageView:getBlendFunc () end
---* Load texture for imageview.<br>
---* param fileName   file name of texture.<br>
---* param texType    @see `Widget::TextureResType`
---@param fileName string
---@param texType int
---@return self
function ImageView:loadTexture (fileName,texType) end
---* Sets the source blending function.<br>
---* param blendFunc A structure with source and destination factor to specify pixel arithmetic. e.g. {BlendFactor::ONE, BlendFactor::ONE}, {BlendFactor::SRC_ALPHA, BlendFactor::ONE_MINUS_SRC_ALPHA}.<br>
---* js NA<br>
---* lua NA
---@param blendFunc cc.BlendFunc
---@return self
function ImageView:setBlendFunc (blendFunc) end
---* 
---@param imageFileName string
---@param texType int
---@return boolean
function ImageView:init (imageFileName,texType) end
---* Enable scale9 renderer.<br>
---* param enabled Set to true will use scale9 renderer, false otherwise.
---@param enabled boolean
---@return self
function ImageView:setScale9Enabled (enabled) end
---* Updates the texture rect of the ImageView in points.<br>
---* It will call setTextureRect:rotated:untrimmedSize with rotated = NO, and utrimmedSize = rect.size.
---@param rect rect_table
---@return self
function ImageView:setTextureRect (rect) end
---* Sets capInsets for imageview.<br>
---* The capInsets affects the ImageView's renderer only if `setScale9Enabled(true)` is called.<br>
---* param capInsets    capinsets for imageview
---@param capInsets rect_table
---@return self
function ImageView:setCapInsets (capInsets) end
---* 
---@return cc.ResourceData
function ImageView:getRenderFile () end
---* Get ImageView's capInsets size.<br>
---* return Query capInsets size in Rect<br>
---* see `setCapInsets(const Rect&)`
---@return rect_table
function ImageView:getCapInsets () end
---* Query whether button is using scale9 renderer or not.<br>
---* return whether button use scale9 renderer or not.
---@return boolean
function ImageView:isScale9Enabled () end
---@overload fun(string:string,int:int):self
---@overload fun():self
---@param imageFileName string
---@param texType int
---@return self
function ImageView:create (imageFileName,texType) end
---* 
---@return cc.Ref
function ImageView:createInstance () end
---* 
---@return cc.Node
function ImageView:getVirtualRenderer () end
---* 
---@return boolean
function ImageView:init () end
---* 
---@return string
function ImageView:getDescription () end
---* 
---@return size_table
function ImageView:getVirtualRendererSize () end
---* 
---@param ignore boolean
---@return self
function ImageView:ignoreContentAdaptWithSize (ignore) end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function ImageView:ImageView () end