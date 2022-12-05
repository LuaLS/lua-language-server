---@meta

---@class cc.ClippingNode :cc.Node
local ClippingNode={ }
cc.ClippingNode=ClippingNode




---*  If stencil has no children it will not be drawn.<br>
---* If you have custom stencil-based node with stencil drawing mechanics other then children-based,<br>
---* then this method should return true every time you wish stencil to be visited.<br>
---* By default returns true if has any children attached.<br>
---* return If you have custom stencil-based node with stencil drawing mechanics other then children-based,<br>
---* then this method should return true every time you wish stencil to be visited.<br>
---* By default returns true if has any children attached.<br>
---* js NA
---@return boolean
function ClippingNode:hasContent () end
---*  Set the ClippingNode whether or not invert.<br>
---* param inverted A bool Type,to set the ClippingNode whether or not invert.
---@param inverted boolean
---@return self
function ClippingNode:setInverted (inverted) end
---*  Set the Node to use as a stencil to do the clipping.<br>
---* param stencil The Node to use as a stencil to do the clipping.
---@param stencil cc.Node
---@return self
function ClippingNode:setStencil (stencil) end
---*  The alpha threshold.<br>
---* The content is drawn only where the stencil have pixel with alpha greater than the alphaThreshold.<br>
---* Should be a float between 0 and 1.<br>
---* This default to 1 (so alpha test is disabled).<br>
---* return The alpha threshold value,Should be a float between 0 and 1.
---@return float
function ClippingNode:getAlphaThreshold () end
---*  Initializes a clipping node with an other node as its stencil.<br>
---* The stencil node will be retained, and its parent will be set to this clipping node.
---@param stencil cc.Node
---@return boolean
function ClippingNode:init (stencil) end
---*  The Node to use as a stencil to do the clipping.<br>
---* The stencil node will be retained.<br>
---* This default to nil.<br>
---* return The stencil node.
---@return cc.Node
function ClippingNode:getStencil () end
---*  Set the alpha threshold. <br>
---* param alphaThreshold The alpha threshold.
---@param alphaThreshold float
---@return self
function ClippingNode:setAlphaThreshold (alphaThreshold) end
---*  Inverted. If this is set to true,<br>
---* the stencil is inverted, so the content is drawn where the stencil is NOT drawn.<br>
---* This default to false.<br>
---* return If the clippingNode is Inverted, it will be return true.
---@return boolean
function ClippingNode:isInverted () end
---@overload fun(cc.Node:cc.Node):self
---@overload fun():self
---@param stencil cc.Node
---@return self
function ClippingNode:create (stencil) end
---* 
---@param mask unsigned short
---@param applyChildren boolean
---@return self
function ClippingNode:setCameraMask (mask,applyChildren) end
---* 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function ClippingNode:visit (renderer,parentTransform,parentFlags) end
---*  Initializes a clipping node without a stencil.
---@return boolean
function ClippingNode:init () end