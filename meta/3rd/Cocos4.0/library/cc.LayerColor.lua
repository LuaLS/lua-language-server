---@meta

---@class cc.LayerColor :cc.Layer@all parent class: Layer,BlendProtocol
local LayerColor={ }
cc.LayerColor=LayerColor




---*  Change width and height in Points.<br>
---* param w The width of layer.<br>
---* param h The Height of layer.<br>
---* since v0.8
---@param w float
---@param h float
---@return self
function LayerColor:changeWidthAndHeight (w,h) end
---*  BlendFunction. Conforms to BlendProtocol protocol <br>
---* lua NA
---@return cc.BlendFunc
function LayerColor:getBlendFunc () end
---* code<br>
---* When this function bound into js or lua,the parameter will be changed<br>
---* In js: var setBlendFunc(var src, var dst)<br>
---* In lua: local setBlendFunc(local src, local dst)<br>
---* endcode
---@param blendFunc cc.BlendFunc
---@return self
function LayerColor:setBlendFunc (blendFunc) end
---*  Change width in Points.<br>
---* param w The width of layer.
---@param w float
---@return self
function LayerColor:changeWidth (w) end
---@overload fun(color4b_table:color4b_table):self
---@overload fun(color4b_table:color4b_table,float:float,float:float):self
---@param color color4b_table
---@param width float
---@param height float
---@return boolean
function LayerColor:initWithColor (color,width,height) end
---*  Change height in Points.<br>
---* param h The height of layer.
---@param h float
---@return self
function LayerColor:changeHeight (h) end
---@overload fun(color4b_table:color4b_table,float:float,float:float):self
---@overload fun():self
---@overload fun(color4b_table:color4b_table):self
---@param color color4b_table
---@param width float
---@param height float
---@return self
function LayerColor:create (color,width,height) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function LayerColor:draw (renderer,transform,flags) end
---* 
---@return boolean
function LayerColor:init () end
---* 
---@param var size_table
---@return self
function LayerColor:setContentSize (var) end
---* 
---@return self
function LayerColor:LayerColor () end