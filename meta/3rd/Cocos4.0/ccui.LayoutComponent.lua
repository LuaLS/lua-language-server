---@meta

---@class ccui.LayoutComponent :cc.Component
local LayoutComponent={ }
ccui.LayoutComponent=LayoutComponent




---* Toggle enable stretch width.<br>
---* param isUsed True if enable stretch width, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setStretchWidthEnabled (isUsed) end
---* Change percent width of owner.<br>
---* param percentWidth Percent Width in float.
---@param percentWidth float
---@return self
function LayoutComponent:setPercentWidth (percentWidth) end
---* Query the anchor position.<br>
---* return Anchor position to it's parent
---@return vec2_table
function LayoutComponent:getAnchorPosition () end
---* Toggle position percentX enabled.<br>
---* param isUsed  True if enable position percentX, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setPositionPercentXEnabled (isUsed) end
---* Toggle enable stretch height.<br>
---* param isUsed True if stretch height is enabled, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setStretchHeightEnabled (isUsed) end
---* Toggle active enabled of LayoutComponent's owner.<br>
---* param enable True if active layout component, false otherwise.
---@param enable boolean
---@return self
function LayoutComponent:setActiveEnabled (enable) end
---* Query the right margin of owner relative to its parent.<br>
---* return Right margin in float.
---@return float
function LayoutComponent:getRightMargin () end
---* Query owner's content size.<br>
---* return Owner's content size.
---@return size_table
function LayoutComponent:getSize () end
---* Change the anchor position to it's parent.<br>
---* param point A value in (x,y) format.
---@param point vec2_table
---@return self
function LayoutComponent:setAnchorPosition (point) end
---* Refresh layout of the owner.
---@return self
function LayoutComponent:refreshLayout () end
---* Query whether percent width is enabled or not.<br>
---* return True if percent width is enabled, false, otherwise.
---@return boolean
function LayoutComponent:isPercentWidthEnabled () end
---* Change element's vertical dock type.<br>
---* param vEage Vertical dock type @see `VerticalEdge`.
---@param vEage int
---@return self
function LayoutComponent:setVerticalEdge (vEage) end
---* Query the top margin of owner relative to its parent.<br>
---* return Top margin in float.
---@return float
function LayoutComponent:getTopMargin () end
---* Change content size width of owner.<br>
---* param width Content size width in float.
---@param width float
---@return self
function LayoutComponent:setSizeWidth (width) end
---* Query the percent content size value.<br>
---* return Percent (x,y) in Vec2.
---@return vec2_table
function LayoutComponent:getPercentContentSize () end
---* Query element vertical dock type.<br>
---* return Vertical dock type.
---@return int
function LayoutComponent:getVerticalEdge () end
---* Toggle enable percent width.<br>
---* param isUsed True if percent width is enabled, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setPercentWidthEnabled (isUsed) end
---* Query whether stretch width is enabled or not.<br>
---* return True if stretch width is enabled, false otherwise.
---@return boolean
function LayoutComponent:isStretchWidthEnabled () end
---* Change left margin of owner relative to its parent.<br>
---* param margin Margin in float.
---@param margin float
---@return self
function LayoutComponent:setLeftMargin (margin) end
---* Query content size width of owner.<br>
---* return Content size width in float.
---@return float
function LayoutComponent:getSizeWidth () end
---* Toggle position percentY enabled.<br>
---* param isUsed True if position percentY is enabled, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setPositionPercentYEnabled (isUsed) end
---* Query size height of owner.<br>
---* return Size height in float.
---@return float
function LayoutComponent:getSizeHeight () end
---* Query the position percentY Y value.<br>
---* return Position percent Y value in float.
---@return float
function LayoutComponent:getPositionPercentY () end
---* Query the position percent X value.<br>
---* return Position percent X value in float.
---@return float
function LayoutComponent:getPositionPercentX () end
---* Change the top margin of owner relative to its parent.<br>
---* param margin Margin in float.
---@param margin float
---@return self
function LayoutComponent:setTopMargin (margin) end
---* Query percent height of owner.         <br>
---* return Percent height in float.
---@return float
function LayoutComponent:getPercentHeight () end
---* Query whether use percent content size or not.<br>
---* return True if using percent content size, false otherwise.
---@return boolean
function LayoutComponent:getUsingPercentContentSize () end
---* Change position percentY value.<br>
---* param percentMargin Margin in float.
---@param percentMargin float
---@return self
function LayoutComponent:setPositionPercentY (percentMargin) end
---* Change position percent X value.<br>
---* param percentMargin Margin in float.
---@param percentMargin float
---@return self
function LayoutComponent:setPositionPercentX (percentMargin) end
---* Change right margin of owner relative to its parent.<br>
---* param margin Margin in float.
---@param margin float
---@return self
function LayoutComponent:setRightMargin (margin) end
---* Whether position percentY is enabled or not.<br>
---* see `setPositionPercentYEnabled`<br>
---* return True if position percentY is enabled, false otherwise.
---@return boolean
function LayoutComponent:isPositionPercentYEnabled () end
---* Change percent height value of owner.<br>
---* param percentHeight Percent height in float.
---@param percentHeight float
---@return self
function LayoutComponent:setPercentHeight (percentHeight) end
---* Toggle enable percent only.<br>
---* param enable True if percent only is enabled, false otherwise.
---@param enable boolean
---@return self
function LayoutComponent:setPercentOnlyEnabled (enable) end
---* Change element's horizontal dock type.<br>
---* param hEage Horizontal dock type @see `HorizontalEdge`
---@param hEage int
---@return self
function LayoutComponent:setHorizontalEdge (hEage) end
---* Change the position of component owner.<br>
---* param position A position in (x,y)
---@param position vec2_table
---@return self
function LayoutComponent:setPosition (position) end
---* Percent content size is used to adapt node's content size based on parent's content size.<br>
---* If set to true then node's content size will be changed based on the value set by @see setPercentContentSize<br>
---* param isUsed True to enable percent content size, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setUsingPercentContentSize (isUsed) end
---* Query left margin of owner relative to its parent.<br>
---* return Left margin in float.
---@return float
function LayoutComponent:getLeftMargin () end
---* Query the owner's position.<br>
---* return The owner's position.
---@return vec2_table
function LayoutComponent:getPosition () end
---* Change size height of owner.<br>
---* param height Size height in float.
---@param height float
---@return self
function LayoutComponent:setSizeHeight (height) end
---* Whether position percentX is enabled or not. <br>
---* return True if position percentX is enable, false otherwise.
---@return boolean
function LayoutComponent:isPositionPercentXEnabled () end
---* Query the bottom margin of owner relative to its parent.<br>
---* return Bottom margin in float.
---@return float
function LayoutComponent:getBottomMargin () end
---* Toggle enable percent height.<br>
---* param isUsed True if percent height is enabled, false otherwise.
---@param isUsed boolean
---@return self
function LayoutComponent:setPercentHeightEnabled (isUsed) end
---* Set percent content size.<br>
---* The value should be [0-1], 0 means the child's content size will be 0<br>
---* and 1 means the child's content size is the same as its parents.<br>
---* param percent The percent (x,y) of the node in [0-1] scope.
---@param percent vec2_table
---@return self
function LayoutComponent:setPercentContentSize (percent) end
---* Query whether percent height is enabled or not.<br>
---* return True if percent height is enabled, false otherwise.
---@return boolean
function LayoutComponent:isPercentHeightEnabled () end
---* Query percent width of owner.<br>
---* return percent width in float.
---@return float
function LayoutComponent:getPercentWidth () end
---* Query element horizontal dock type.<br>
---* return Horizontal dock type.
---@return int
function LayoutComponent:getHorizontalEdge () end
---* Query whether stretch height is enabled or not.<br>
---* return True if stretch height is enabled, false otherwise.
---@return boolean
function LayoutComponent:isStretchHeightEnabled () end
---* Change the bottom margin of owner relative to its parent.<br>
---* param margin in float.
---@param margin float
---@return self
function LayoutComponent:setBottomMargin (margin) end
---* Change the content size of owner.<br>
---* param size Content size in @see `Size`.
---@param size size_table
---@return self
function LayoutComponent:setSize (size) end
---* 
---@return self
function LayoutComponent:create () end
---* Bind a LayoutComponent to a specified node.<br>
---* If the node has already binded a LayoutComponent named __LAYOUT_COMPONENT_NAME, just return the LayoutComponent.<br>
---* Otherwise, create a new LayoutComponent and bind the LayoutComponent to the node.<br>
---* param node A Node* instance pointer.<br>
---* return The binded LayoutComponent instance pointer.
---@param node cc.Node
---@return self
function LayoutComponent:bindLayoutComponent (node) end
---* 
---@return boolean
function LayoutComponent:init () end
---* Default constructor<br>
---* lua new
---@return self
function LayoutComponent:LayoutComponent () end