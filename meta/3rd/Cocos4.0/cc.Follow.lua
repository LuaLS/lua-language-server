---@meta

---@class cc.Follow :cc.Action
local Follow={ }
cc.Follow=Follow




---*  Alter behavior - turn on/off boundary. <br>
---* param value Turn on/off boundary.
---@param value boolean
---@return self
function Follow:setBoundarySet (value) end
---* Initializes the action with a set boundary or with no boundary.<br>
---* param followedNode  The node to be followed.<br>
---* param rect  The boundary. If \p rect is equal to Rect::ZERO, it'll work<br>
---* with no boundary.
---@param followedNode cc.Node
---@param rect rect_table
---@return boolean
function Follow:initWithTarget (followedNode,rect) end
---* Initializes the action with a set boundary or with no boundary with offsets.<br>
---* param followedNode  The node to be followed.<br>
---* param rect  The boundary. If \p rect is equal to Rect::ZERO, it'll work<br>
---* with no boundary.<br>
---* param xOffset The horizontal offset from the center of the screen from which the<br>
---* node  is to be followed.It can be positive,negative or zero.If<br>
---* set to zero the node will be horizontally centered followed.<br>
---* param yOffset The vertical offset from the center of the screen from which the<br>
---* node is to be followed.It can be positive,negative or zero.<br>
---* If set to zero the node will be vertically centered followed.<br>
---* If both xOffset and yOffset are set to zero,then the node will be horizontally and vertically centered followed.
---@param followedNode cc.Node
---@param xOffset float
---@param yOffset float
---@param rect rect_table
---@return boolean
function Follow:initWithTargetAndOffset (followedNode,xOffset,yOffset,rect) end
---*  Return boundarySet.<br>
---* return Return boundarySet.
---@return boolean
function Follow:isBoundarySet () end
---* Creates the action with a set boundary or with no boundary.<br>
---* param followedNode  The node to be followed.<br>
---* param rect  The boundary. If \p rect is equal to Rect::ZERO, it'll work<br>
---* with no boundary.
---@param followedNode cc.Node
---@param rect rect_table
---@return self
function Follow:create (followedNode,rect) end
---* Creates the action with a set boundary or with no boundary with offsets.<br>
---* param followedNode  The node to be followed.<br>
---* param rect  The boundary. If \p rect is equal to Rect::ZERO, it'll work<br>
---* with no boundary.<br>
---* param xOffset The horizontal offset from the center of the screen from which the<br>
---* node  is to be followed.It can be positive,negative or zero.If<br>
---* set to zero the node will be horizontally centered followed.<br>
---* param yOffset The vertical offset from the center of the screen from which the<br>
---* node is to be followed.It can be positive,negative or zero.<br>
---* If set to zero the node will be vertically centered followed.<br>
---* If both xOffset and yOffset are set to zero,then the node will be horizontally and vertically centered followed.
---@param followedNode cc.Node
---@param xOffset float
---@param yOffset float
---@param rect rect_table
---@return self
function Follow:createWithOffset (followedNode,xOffset,yOffset,rect) end
---* param dt in seconds.<br>
---* js NA
---@param dt float
---@return self
function Follow:step (dt) end
---* 
---@return self
function Follow:clone () end
---* 
---@return self
function Follow:stop () end
---* 
---@return self
function Follow:reverse () end
---* 
---@return boolean
function Follow:isDone () end
---* js ctor
---@return self
function Follow:Follow () end