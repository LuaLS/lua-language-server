---@meta

---@class ccui.LoadingBar :ccui.Widget
local LoadingBar={ }
ccui.LoadingBar=LoadingBar




---* Changes the progress value of LoadingBar.<br>
---* param percent   Percent value from 1 to 100.
---@param percent float
---@return self
function LoadingBar:setPercent (percent) end
---* Load texture for LoadingBar.<br>
---* param texture   File name of texture.<br>
---* param texType   Texture resource type,@see TextureResType.
---@param texture string
---@param texType int
---@return self
function LoadingBar:loadTexture (texture,texType) end
---* Change the progress direction of LoadingBar.<br>
---* see Direction  `LEFT` means progress left to right, `RIGHT` otherwise.<br>
---* param direction Direction
---@param direction int
---@return self
function LoadingBar:setDirection (direction) end
---* 
---@return cc.ResourceData
function LoadingBar:getRenderFile () end
---* Enable scale9 renderer.<br>
---* param enabled Set to true will use scale9 renderer, false otherwise.
---@param enabled boolean
---@return self
function LoadingBar:setScale9Enabled (enabled) end
---* Set capInsets for LoadingBar.<br>
---* This setting only take effect when enable scale9 renderer.<br>
---* param capInsets CapInset in `Rect`.
---@param capInsets rect_table
---@return self
function LoadingBar:setCapInsets (capInsets) end
---* Get the progress direction of LoadingBar.<br>
---* see Direction  `LEFT` means progress left to right, `RIGHT` otherwise.<br>
---* return LoadingBar progress direction.
---@return int
function LoadingBar:getDirection () end
---* brief Query LoadingBar's capInsets.<br>
---* return CapInsets of LoadingBar.
---@return rect_table
function LoadingBar:getCapInsets () end
---* brief Query whether LoadingBar is using scale9 renderer or not.<br>
---* return Whether LoadingBar uses scale9 renderer or not.
---@return boolean
function LoadingBar:isScale9Enabled () end
---* Get the progress value of LoadingBar.<br>
---* return Progress value from 1 to 100.
---@return float
function LoadingBar:getPercent () end
---@overload fun(string:string,int1:float):self
---@overload fun():self
---@overload fun(string:string,int:int,float:float):self
---@param textureName string
---@param texType int
---@param percentage float
---@return self
function LoadingBar:create (textureName,texType,percentage) end
---* 
---@return cc.Ref
function LoadingBar:createInstance () end
---* 
---@return cc.Node
function LoadingBar:getVirtualRenderer () end
---* 
---@return string
function LoadingBar:getDescription () end
---* 
---@return size_table
function LoadingBar:getVirtualRendererSize () end
---* 
---@param ignore boolean
---@return self
function LoadingBar:ignoreContentAdaptWithSize (ignore) end
---* Default constructor.<br>
---* js ctor<br>
---* lua new
---@return self
function LoadingBar:LoadingBar () end