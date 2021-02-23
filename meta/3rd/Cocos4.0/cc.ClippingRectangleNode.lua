---@meta

---@class cc.ClippingRectangleNode :cc.Node
local ClippingRectangleNode={ }
cc.ClippingRectangleNode=ClippingRectangleNode




---* brief Get whether the clipping is enabled or not.<br>
---* return Whether the clipping is enabled or not. Default is true.
---@return boolean
function ClippingRectangleNode:isClippingEnabled () end
---* brief Enable/Disable the clipping.<br>
---* param enabled Pass true to enable clipping. Pass false to disable clipping.
---@param enabled boolean
---@return self
function ClippingRectangleNode:setClippingEnabled (enabled) end
---* brief Get the clipping rectangle.<br>
---* return The clipping rectangle.
---@return rect_table
function ClippingRectangleNode:getClippingRegion () end
---* brief Set the clipping rectangle.<br>
---* param clippingRegion Specify the clipping rectangle.
---@param clippingRegion rect_table
---@return self
function ClippingRectangleNode:setClippingRegion (clippingRegion) end
---@overload fun():self
---@overload fun(rect_table:rect_table):self
---@param clippingRegion rect_table
---@return self
function ClippingRectangleNode:create (clippingRegion) end
---* 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function ClippingRectangleNode:visit (renderer,parentTransform,parentFlags) end