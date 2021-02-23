---@meta

---@class ccui.Layout :ccui.Widget@all parent class: Widget,LayoutProtocol
local Layout={ }
ccui.Layout=Layout




---* Sets background color vector for layout.<br>
---* This setting only take effect when layout's color type is BackGroundColorType::GRADIENT<br>
---* param vector The color vector in `Vec2`.
---@param vector vec2_table
---@return self
function Layout:setBackGroundColorVector (vector) end
---* Change the clipping type of layout.<br>
---* On default, the clipping type is `ClippingType::STENCIL`.<br>
---* see `ClippingType`<br>
---* param type The clipping type of layout.
---@param type int
---@return self
function Layout:setClippingType (type) end
---* Sets Color Type for layout's background<br>
---* param type   @see `BackGroundColorType`
---@param type int
---@return self
function Layout:setBackGroundColorType (type) end
---* If a layout is loop focused which means that the focus movement will be inside the layout<br>
---* param loop  pass true to let the focus movement loop inside the layout
---@param loop boolean
---@return self
function Layout:setLoopFocus (loop) end
---* Set layout's background image color.<br>
---* param color Background color value in `Color3B`.
---@param color color3b_table
---@return self
function Layout:setBackGroundImageColor (color) end
---* Get the layout's background color vector.<br>
---* return Background color vector.
---@return vec2_table
function Layout:getBackGroundColorVector () end
---* see `setClippingType(ClippingType)`
---@return int
function Layout:getClippingType () end
---* 
---@return cc.ResourceData
function Layout:getRenderFile () end
---* return If focus loop is enabled, then it will return true, otherwise it returns false. The default value is false.
---@return boolean
function Layout:isLoopFocus () end
---* Remove the background image of layout.
---@return self
function Layout:removeBackGroundImage () end
---* Get the layout's background color opacity.<br>
---* return Background color opacity value.
---@return unsigned_char
function Layout:getBackGroundColorOpacity () end
---* Gets if layout is clipping enabled.<br>
---* return if layout is clipping enabled.
---@return boolean
function Layout:isClippingEnabled () end
---* Set opacity of background image.<br>
---* param opacity Background image opacity in GLubyte.
---@param opacity unsigned_char
---@return self
function Layout:setBackGroundImageOpacity (opacity) end
---* Sets a background image for layout.<br>
---* param fileName image file path.<br>
---* param texType @see TextureResType. 
---@param fileName string
---@param texType int
---@return self
function Layout:setBackGroundImage (fileName,texType) end
---@overload fun(color3b_table:color3b_table,color3b_table:color3b_table):self
---@overload fun(color3b_table:color3b_table):self
---@param startColor color3b_table
---@param endColor color3b_table
---@return self
function Layout:setBackGroundColor (startColor,endColor) end
---* request to refresh widget layout
---@return self
function Layout:requestDoLayout () end
---* Query background image's capInsets size.<br>
---* return The background image capInsets.
---@return rect_table
function Layout:getBackGroundImageCapInsets () end
---* Query the layout's background color.<br>
---* return Background color in Color3B.
---@return color3b_table
function Layout:getBackGroundColor () end
---* Toggle layout clipping.<br>
---* If you do need clipping, you pass true to this function.<br>
---* param enabled Pass true to enable clipping, false otherwise.
---@param enabled boolean
---@return self
function Layout:setClippingEnabled (enabled) end
---* Get color of layout's background image.<br>
---* return Layout's background image color.
---@return color3b_table
function Layout:getBackGroundImageColor () end
---* Query background image scale9 enable status.<br>
---* return Whether background image is scale9 enabled or not.
---@return boolean
function Layout:isBackGroundImageScale9Enabled () end
---* Query the layout's background color type.<br>
---* return The layout's background color type.
---@return int
function Layout:getBackGroundColorType () end
---* Get the gradient background end color.<br>
---* return Gradient background end color value.
---@return color3b_table
function Layout:getBackGroundEndColor () end
---* Sets background color opacity of layout.<br>
---* param opacity The opacity in `GLubyte`.
---@param opacity unsigned_char
---@return self
function Layout:setBackGroundColorOpacity (opacity) end
---* Get the opacity of layout's background image.<br>
---* return The opacity of layout's background image.
---@return unsigned_char
function Layout:getBackGroundImageOpacity () end
---* return To query whether the layout will pass the focus to its children or not. The default value is true
---@return boolean
function Layout:isPassFocusToChild () end
---* Sets a background image capinsets for layout, it only affects the scale9 enabled background image<br>
---* param capInsets  The capInsets in Rect.
---@param capInsets rect_table
---@return self
function Layout:setBackGroundImageCapInsets (capInsets) end
---* Gets background image texture size.<br>
---* return background image texture size.
---@return size_table
function Layout:getBackGroundImageTextureSize () end
---* force refresh widget layout
---@return self
function Layout:forceDoLayout () end
---* Query layout type.<br>
---* return Get the layout type.
---@return int
function Layout:getLayoutType () end
---* param pass To specify whether the layout pass its focus to its child
---@param pass boolean
---@return self
function Layout:setPassFocusToChild (pass) end
---* Get the gradient background start color.<br>
---* return  Gradient background start color value.
---@return color3b_table
function Layout:getBackGroundStartColor () end
---* Enable background image scale9 rendering.<br>
---* param enabled  True means enable scale9 rendering for background image, false otherwise.
---@param enabled boolean
---@return self
function Layout:setBackGroundImageScale9Enabled (enabled) end
---* Change the layout type.<br>
---* param type Layout type.
---@param type int
---@return self
function Layout:setLayoutType (type) end
---* Create a empty layout.
---@return self
function Layout:create () end
---* 
---@return cc.Ref
function Layout:createInstance () end
---@overload fun(cc.Node:cc.Node,int:int):self
---@overload fun(cc.Node:cc.Node):self
---@overload fun(cc.Node:cc.Node,int:int,string2:int):self
---@overload fun(cc.Node:cc.Node,int:int,string:string):self
---@param child cc.Node
---@param localZOrder int
---@param name string
---@return self
function Layout:addChild (child,localZOrder,name) end
---* Returns the "class name" of widget.
---@return string
function Layout:getDescription () end
---* Removes all children from the container, and do a cleanup to all running actions depending on the cleanup parameter.<br>
---* param cleanup   true if all running actions on all children nodes should be cleanup, false otherwise.<br>
---* js removeAllChildren<br>
---* lua removeAllChildren
---@param cleanup boolean
---@return self
function Layout:removeAllChildrenWithCleanup (cleanup) end
---* Removes all children from the container with a cleanup.<br>
---* see `removeAllChildrenWithCleanup(bool)`
---@return self
function Layout:removeAllChildren () end
---* When a widget is in a layout, you could call this method to get the next focused widget within a specified direction.<br>
---* If the widget is not in a layout, it will return itself<br>
---* param direction the direction to look for the next focused widget in a layout<br>
---* param current  the current focused widget<br>
---* return the next focused widget in a layout
---@param direction int
---@param current ccui.Widget
---@return ccui.Widget
function Layout:findNextFocusedWidget (direction,current) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function Layout:removeChild (child,cleanup) end
---* 
---@return boolean
function Layout:init () end
---* Override function. Set camera mask, the node is visible by the camera whose camera flag & node's camera mask is true. <br>
---* param mask Mask being set<br>
---* param applyChildren If true call this function recursively from this node to its children.
---@param mask unsigned short
---@param applyChildren boolean
---@return self
function Layout:setCameraMask (mask,applyChildren) end
---* 
---@param globalZOrder float
---@return self
function Layout:setGlobalZOrder (globalZOrder) end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function Layout:Layout () end