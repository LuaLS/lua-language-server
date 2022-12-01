---@meta

---@class ccui.ListView :ccui.ScrollView
local ListView={ }
ccui.ListView=ListView




---* Set the gravity of ListView.<br>
---* see `ListViewGravity`
---@param gravity int
---@return self
function ListView:setGravity (gravity) end
---* Removes the last item of ListView.
---@return self
function ListView:removeLastItem () end
---* Get the left padding in ListView<br>
---* return Left padding in float
---@return float
function ListView:getLeftPadding () end
---* brief Query the center item<br>
---* return An item instance.
---@return ccui.Widget
function ListView:getCenterItemInCurrentView () end
---* brief Query current selected widget's index.<br>
---* return An index of a selected item.
---@return int
function ListView:getCurSelectedIndex () end
---* Get the time in seconds to scroll between items.<br>
---* return The time in seconds to scroll between items<br>
---* see setScrollDuration(float)
---@return float
function ListView:getScrollDuration () end
---* Query whether the magnetic out of boundary is allowed.
---@return boolean
function ListView:getMagneticAllowedOutOfBoundary () end
---* brief Query margin between each item in ListView.<br>
---* return A margin in float.
---@return float
function ListView:getItemsMargin () end
---@overload fun(int:int,vec2_table:vec2_table,vec2_table:vec2_table,float:float):self
---@overload fun(int:int,vec2_table:vec2_table,vec2_table:vec2_table):self
---@param itemIndex int
---@param positionRatioInView vec2_table
---@param itemAnchorPoint vec2_table
---@param timeInSec float
---@return self
function ListView:scrollToItem (itemIndex,positionRatioInView,itemAnchorPoint,timeInSec) end
---* brief Jump to specific item<br>
---* param itemIndex Specifies the item's index<br>
---* param positionRatioInView Specifies the position with ratio in list view's content size.<br>
---* param itemAnchorPoint Specifies an anchor point of each item for position to calculate distance.
---@param itemIndex int
---@param positionRatioInView vec2_table
---@param itemAnchorPoint vec2_table
---@return self
function ListView:jumpToItem (itemIndex,positionRatioInView,itemAnchorPoint) end
---* Change padding with top padding<br>
---* param t Top padding in float
---@param t float
---@return self
function ListView:setTopPadding (t) end
---* Return the index of specified widget.<br>
---* param item  A widget pointer.<br>
---* return The index of a given widget in ListView.
---@param item ccui.Widget
---@return int
function ListView:getIndex (item) end
---* Insert a  custom item into the end of ListView.<br>
---* param item An item in `Widget*`.
---@param item ccui.Widget
---@return self
function ListView:pushBackCustomItem (item) end
---* brief Set current selected widget's index and call TouchEventType::ENDED event.<br>
---* param itemIndex A index of a selected item.
---@param itemIndex int
---@return self
function ListView:setCurSelectedIndex (itemIndex) end
---* Insert a default item(create by cloning model) into listview at a give index.<br>
---* param index  An index in ssize_t.
---@param index int
---@return self
function ListView:insertDefaultItem (index) end
---* Set magnetic type of ListView.<br>
---* see `MagneticType`
---@param magneticType int
---@return self
function ListView:setMagneticType (magneticType) end
---* Set magnetic allowed out of boundary.
---@param magneticAllowedOutOfBoundary boolean
---@return self
function ListView:setMagneticAllowedOutOfBoundary (magneticAllowedOutOfBoundary) end
---* Add an event click callback to ListView, then one item of Listview is clicked, the callback will be called.<br>
---* param callback A callback function with type of `ccListViewCallback`.
---@param callback function
---@return self
function ListView:addEventListener (callback) end
---* 
---@return self
function ListView:doLayout () end
---* brief Query the topmost item in horizontal list<br>
---* return An item instance.
---@return ccui.Widget
function ListView:getTopmostItemInCurrentView () end
---* Change padding with left, top, right, and bottom padding.<br>
---* param l Left padding in float.<br>
---* param t Top margin in float.<br>
---* param r Right margin in float.<br>
---* param b Bottom margin in float.
---@param l float
---@param t float
---@param r float
---@param b float
---@return self
function ListView:setPadding (l,t,r,b) end
---* brief Remove all items in current ListView.
---@return self
function ListView:removeAllItems () end
---* Get the right padding in ListView<br>
---* return Right padding in float
---@return float
function ListView:getRightPadding () end
---* brief Query the bottommost item in horizontal list<br>
---* return An item instance.
---@return ccui.Widget
function ListView:getBottommostItemInCurrentView () end
---* Return all items in a ListView.<br>
---* returns A vector of widget pointers.
---@return array_table
function ListView:getItems () end
---* brief Query the leftmost item in horizontal list<br>
---* return An item instance.
---@return ccui.Widget
function ListView:getLeftmostItemInCurrentView () end
---* Set the margin between each item in ListView.<br>
---* param margin A margin in float.
---@param margin float
---@return self
function ListView:setItemsMargin (margin) end
---* Get magnetic type of ListView.
---@return int
function ListView:getMagneticType () end
---* Return an item at a given index.<br>
---* param index A given index in ssize_t.<br>
---* return A widget instance.
---@param index int
---@return ccui.Widget
function ListView:getItem (index) end
---* Remove an item at given index.<br>
---* param index A given index in ssize_t.
---@param index int
---@return self
function ListView:removeItem (index) end
---* Get the top padding in ListView<br>
---* return Top padding in float
---@return float
function ListView:getTopPadding () end
---* Insert a default item(create by a cloned model) at the end of the listview.
---@return self
function ListView:pushBackDefaultItem () end
---* Change padding with left padding<br>
---* param l Left padding in float.
---@param l float
---@return self
function ListView:setLeftPadding (l) end
---* brief Query the closest item to a specific position in inner container.<br>
---* param targetPosition Specifies the target position in inner container's coordinates.<br>
---* param itemAnchorPoint Specifies an anchor point of each item for position to calculate distance.<br>
---* return An item instance if list view is not empty. Otherwise, returns null.
---@param targetPosition vec2_table
---@param itemAnchorPoint vec2_table
---@return ccui.Widget
function ListView:getClosestItemToPosition (targetPosition,itemAnchorPoint) end
---* Change padding with bottom padding<br>
---* param b Bottom padding in float
---@param b float
---@return self
function ListView:setBottomPadding (b) end
---* Set the time in seconds to scroll between items.<br>
---* Subsequent calls of function 'scrollToItem', will take 'time' seconds for scrolling.<br>
---* param time The seconds needed to scroll between two items. 'time' must be >= 0<br>
---* see scrollToItem(ssize_t, const Vec2&, const Vec2&)
---@param time float
---@return self
function ListView:setScrollDuration (time) end
---* brief Query the closest item to a specific position in current view.<br>
---* For instance, to find the item in the center of view, call 'getClosestItemToPositionInCurrentView(Vec2::ANCHOR_MIDDLE, Vec2::ANCHOR_MIDDLE)'.<br>
---* param positionRatioInView Specifies the target position with ratio in list view's content size.<br>
---* param itemAnchorPoint Specifies an anchor point of each item for position to calculate distance.<br>
---* return An item instance if list view is not empty. Otherwise, returns null.
---@param positionRatioInView vec2_table
---@param itemAnchorPoint vec2_table
---@return ccui.Widget
function ListView:getClosestItemToPositionInCurrentView (positionRatioInView,itemAnchorPoint) end
---* brief Query the rightmost item in horizontal list<br>
---* return An item instance.
---@return ccui.Widget
function ListView:getRightmostItemInCurrentView () end
---* Change padding with right padding<br>
---* param r Right padding in float
---@param r float
---@return self
function ListView:setRightPadding (r) end
---* Set an item model for listview.<br>
---* When calling `pushBackDefaultItem`, the model will be used as a blueprint and new model copy will be inserted into ListView.<br>
---* param model  Model in `Widget*`.
---@param model ccui.Widget
---@return self
function ListView:setItemModel (model) end
---* Get the bottom padding in ListView<br>
---* return Bottom padding in float
---@return float
function ListView:getBottomPadding () end
---* brief Insert a custom widget into ListView at a given index.<br>
---* param item A widget pointer to be inserted.<br>
---* param index A given index in ssize_t.
---@param item ccui.Widget
---@param index int
---@return self
function ListView:insertCustomItem (item,index) end
---* Create an empty ListView.<br>
---* return A ListView instance.
---@return self
function ListView:create () end
---* 
---@return cc.Ref
function ListView:createInstance () end
---@overload fun(cc.Node:cc.Node,int:int):self
---@overload fun(cc.Node:cc.Node):self
---@overload fun(cc.Node:cc.Node,int:int,string2:int):self
---@overload fun(cc.Node:cc.Node,int:int,string:string):self
---@param child cc.Node
---@param zOrder int
---@param name string
---@return self
function ListView:addChild (child,zOrder,name) end
---* Override functions
---@return self
function ListView:jumpToBottom () end
---* 
---@return boolean
function ListView:init () end
---* Changes scroll direction of scrollview.<br>
---* Direction Direction::VERTICAL means vertical scroll, Direction::HORIZONTAL means horizontal scroll.<br>
---* param dir Set the list view's scroll direction.
---@param dir int
---@return self
function ListView:setDirection (dir) end
---* 
---@return self
function ListView:jumpToTopRight () end
---* 
---@return self
function ListView:jumpToLeft () end
---* 
---@param cleanup boolean
---@return self
function ListView:removeAllChildrenWithCleanup (cleanup) end
---* 
---@return self
function ListView:requestDoLayout () end
---* 
---@return self
function ListView:removeAllChildren () end
---* 
---@return self
function ListView:jumpToTopLeft () end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function ListView:removeChild (child,cleanup) end
---* 
---@return self
function ListView:jumpToBottomRight () end
---* 
---@return self
function ListView:jumpToTop () end
---* 
---@return self
function ListView:jumpToBottomLeft () end
---* 
---@param percent vec2_table
---@return self
function ListView:jumpToPercentBothDirection (percent) end
---* 
---@param percent float
---@return self
function ListView:jumpToPercentHorizontal (percent) end
---* 
---@return self
function ListView:jumpToRight () end
---* 
---@return string
function ListView:getDescription () end
---* 
---@param percent float
---@return self
function ListView:jumpToPercentVertical (percent) end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function ListView:ListView () end