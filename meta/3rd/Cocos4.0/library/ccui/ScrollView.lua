---@meta

---@class ccui.ScrollView :ccui.Layout
local ScrollView={ }
ccui.ScrollView=ScrollView




---* Scroll inner container to top boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToTop (timeInSec,attenuated) end
---* Scroll inner container to horizontal percent position of scrollview.<br>
---* param percent A value between 0 and 100.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param percent float
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToPercentHorizontal (percent,timeInSec,attenuated) end
---* brief Set the scroll bar's opacity<br>
---* param the scroll bar's opacity
---@param opacity unsigned_char
---@return self
function ScrollView:setScrollBarOpacity (opacity) end
---* brief Toggle scroll bar enabled.<br>
---* param enabled True if enable scroll bar, false otherwise.
---@param enabled boolean
---@return self
function ScrollView:setScrollBarEnabled (enabled) end
---* brief Query inertia scroll state.<br>
---* return True if inertia is enabled, false otherwise.
---@return boolean
function ScrollView:isInertiaScrollEnabled () end
---* Scroll inner container to bottom boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToBottom (timeInSec,attenuated) end
---* return How far the scroll view is scrolled in both axes, combined as a Vec2
---@return vec2_table
function ScrollView:getScrolledPercentBothDirection () end
---* Query scroll direction of scrollview.<br>
---* see `Direction`      Direction::VERTICAL means vertical scroll, Direction::HORIZONTAL means horizontal scroll<br>
---* return Scrollview scroll direction.
---@return int
function ScrollView:getDirection () end
---* brief Set the scroll bar's color<br>
---* param the scroll bar's color
---@param color color3b_table
---@return self
function ScrollView:setScrollBarColor (color) end
---* Scroll inner container to bottom and left boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToBottomLeft (timeInSec,attenuated) end
---* Get inner container of scrollview.<br>
---* Inner container is a child of scrollview.<br>
---* return Inner container pointer.
---@return ccui.Layout
function ScrollView:getInnerContainer () end
---* Move inner container to bottom boundary of scrollview.
---@return self
function ScrollView:jumpToBottom () end
---* Set inner container position<br>
---* param pos Inner container position.
---@param pos vec2_table
---@return self
function ScrollView:setInnerContainerPosition (pos) end
---* Changes scroll direction of scrollview.<br>
---* see `Direction`<br>
---* param dir Scroll direction enum.
---@param dir int
---@return self
function ScrollView:setDirection (dir) end
---* Scroll inner container to top and left boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToTopLeft (timeInSec,attenuated) end
---* Move inner container to top and right boundary of scrollview.
---@return self
function ScrollView:jumpToTopRight () end
---* Scroll inner container to both direction percent position of scrollview.<br>
---* param percent A value between 0 and 100.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param percent vec2_table
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToPercentBothDirection (percent,timeInSec,attenuated) end
---* Change inner container size of scrollview.<br>
---* Inner container size must be larger than or equal scrollview's size.<br>
---* param size Inner container size.
---@param size size_table
---@return self
function ScrollView:setInnerContainerSize (size) end
---* Get inner container position<br>
---* return The inner container position.
---@return vec2_table
function ScrollView:getInnerContainerPosition () end
---* Move inner container to top boundary of scrollview.
---@return self
function ScrollView:jumpToTop () end
---* return How far the scroll view is scrolled in the vertical axis
---@return float
function ScrollView:getScrolledPercentVertical () end
---* brief Query bounce state.<br>
---* return True if bounce is enabled, false otherwise.
---@return boolean
function ScrollView:isBounceEnabled () end
---* Move inner container to vertical percent position of scrollview.<br>
---* param percent A value between 0 and 100.
---@param percent float
---@return self
function ScrollView:jumpToPercentVertical (percent) end
---* Add callback function which will be called  when scrollview event triggered.<br>
---* param callback A callback function with type of `ccScrollViewCallback`.
---@param callback function
---@return self
function ScrollView:addEventListener (callback) end
---* brief Set scroll bar auto hide time<br>
---* param scroll bar auto hide time
---@param autoHideTime float
---@return self
function ScrollView:setScrollBarAutoHideTime (autoHideTime) end
---* Immediately stops inner container scroll (auto scrolling is not affected).
---@return self
function ScrollView:stopScroll () end
---* brief Set the horizontal scroll bar position from left-bottom corner.<br>
---* param positionFromCorner The position from left-bottom corner
---@param positionFromCorner vec2_table
---@return self
function ScrollView:setScrollBarPositionFromCornerForHorizontal (positionFromCorner) end
---* brief Toggle whether enable scroll inertia while scrolling.<br>
---* param enabled True if enable inertia, false otherwise.
---@param enabled boolean
---@return self
function ScrollView:setInertiaScrollEnabled (enabled) end
---* brief Set scroll bar auto hide state<br>
---* param scroll bar auto hide state
---@param autoHideEnabled boolean
---@return self
function ScrollView:setScrollBarAutoHideEnabled (autoHideEnabled) end
---* brief Get the scroll bar's color<br>
---* return the scroll bar's color
---@return color3b_table
function ScrollView:getScrollBarColor () end
---* Move inner container to top and left boundary of scrollview.
---@return self
function ScrollView:jumpToTopLeft () end
---* brief Query scroll bar state.<br>
---* return True if scroll bar is enabled, false otherwise.
---@return boolean
function ScrollView:isScrollBarEnabled () end
---* return Whether the ScrollView is currently scrolling because of a bounceback or inertia slowdown.
---@return boolean
function ScrollView:isAutoScrolling () end
---* Move inner container to bottom and right boundary of scrollview.
---@return self
function ScrollView:jumpToBottomRight () end
---* brief Set the touch total time threshold<br>
---* param the touch total time threshold
---@param touchTotalTimeThreshold float
---@return self
function ScrollView:setTouchTotalTimeThreshold (touchTotalTimeThreshold) end
---* brief Get the touch total time threshold<br>
---* return the touch total time threshold
---@return float
function ScrollView:getTouchTotalTimeThreshold () end
---* brief Get the horizontal scroll bar's position from right-top corner.<br>
---* return positionFromCorner
---@return vec2_table
function ScrollView:getScrollBarPositionFromCornerForHorizontal () end
---* return How far the scroll view is scrolled in the horizontal axis
---@return float
function ScrollView:getScrolledPercentHorizontal () end
---* brief Toggle bounce enabled when scroll to the edge.<br>
---* param enabled True if enable bounce, false otherwise.
---@param enabled boolean
---@return self
function ScrollView:setBounceEnabled (enabled) end
---* Immediately stops inner container scroll initiated by any of the "scrollTo*" member functions
---@return self
function ScrollView:stopAutoScroll () end
---* Scroll inner container to top and right boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToTopRight (timeInSec,attenuated) end
---* return Whether the user is currently dragging the ScrollView to scroll it
---@return boolean
function ScrollView:isScrolling () end
---* Scroll inner container to left boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToLeft (timeInSec,attenuated) end
---* Move inner container to both direction percent position of scrollview.<br>
---* param percent   A value between 0 and 100.
---@param percent vec2_table
---@return self
function ScrollView:jumpToPercentBothDirection (percent) end
---* Immediately stops inner container scroll if any.
---@return self
function ScrollView:stopOverallScroll () end
---* Scroll inner container to vertical percent position of scrollview.<br>
---* param percent A value between 0 and 100.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param percent float
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToPercentVertical (percent,timeInSec,attenuated) end
---* brief Set the scroll bar's width<br>
---* param width The scroll bar's width
---@param width float
---@return self
function ScrollView:setScrollBarWidth (width) end
---* brief Get the scroll bar's opacity<br>
---* return the scroll bar's opacity
---@return unsigned_char
function ScrollView:getScrollBarOpacity () end
---* Scroll inner container to bottom and right boundary of scrollview.<br>
---* param timeInSec Time in seconds<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToBottomRight (timeInSec,attenuated) end
---* brief Set the scroll bar positions from the left-bottom corner (horizontal) and right-top corner (vertical).<br>
---* param positionFromCorner The position from the left-bottom corner (horizontal) and right-top corner (vertical).
---@param positionFromCorner vec2_table
---@return self
function ScrollView:setScrollBarPositionFromCorner (positionFromCorner) end
---* brief Set the vertical scroll bar position from right-top corner.<br>
---* param positionFromCorner The position from right-top corner
---@param positionFromCorner vec2_table
---@return self
function ScrollView:setScrollBarPositionFromCornerForVertical (positionFromCorner) end
---* brief Get the scroll bar's auto hide time<br>
---* return the scroll bar's auto hide time
---@return float
function ScrollView:getScrollBarAutoHideTime () end
---* Move inner container to left boundary of scrollview.
---@return self
function ScrollView:jumpToLeft () end
---* Scroll inner container to right boundary of scrollview.<br>
---* param timeInSec Time in seconds.<br>
---* param attenuated Whether scroll speed attenuate or not.
---@param timeInSec float
---@param attenuated boolean
---@return self
function ScrollView:scrollToRight (timeInSec,attenuated) end
---* brief Get the vertical scroll bar's position from right-top corner.<br>
---* return positionFromCorner
---@return vec2_table
function ScrollView:getScrollBarPositionFromCornerForVertical () end
---* brief Get the scroll bar's width<br>
---* return the scroll bar's width
---@return float
function ScrollView:getScrollBarWidth () end
---* brief Query scroll bar auto hide state<br>
---* return True if scroll bar auto hide is enabled, false otherwise.
---@return boolean
function ScrollView:isScrollBarAutoHideEnabled () end
---* Move inner container to bottom and left boundary of scrollview.
---@return self
function ScrollView:jumpToBottomLeft () end
---* Move inner container to right boundary of scrollview.
---@return self
function ScrollView:jumpToRight () end
---* Get inner container size of scrollview.<br>
---* Inner container size must be larger than or equal scrollview's size.<br>
---* return The inner container size.
---@return size_table
function ScrollView:getInnerContainerSize () end
---* Move inner container to horizontal percent position of scrollview.<br>
---* param percent   A value between 0 and 100.
---@param percent float
---@return self
function ScrollView:jumpToPercentHorizontal (percent) end
---* Create an empty ScrollView.<br>
---* return A ScrollView instance.
---@return self
function ScrollView:create () end
---* 
---@return cc.Ref
function ScrollView:createInstance () end
---@overload fun(cc.Node:cc.Node,int:int):self
---@overload fun(cc.Node:cc.Node):self
---@overload fun(cc.Node:cc.Node,int:int,string2:int):self
---@overload fun(cc.Node:cc.Node,int:int,string:string):self
---@param child cc.Node
---@param localZOrder int
---@param name string
---@return self
function ScrollView:addChild (child,localZOrder,name) end
---* 
---@return boolean
function ScrollView:init () end
---* 
---@param name string
---@return cc.Node
function ScrollView:getChildByName (name) end
---* Return the "class name" of widget.
---@return string
function ScrollView:getDescription () end
---* 
---@param dt float
---@return self
function ScrollView:update (dt) end
---* Get the layout type for scrollview.<br>
---* see `Layout::Type`<br>
---* return LayoutType
---@return int
function ScrollView:getLayoutType () end
---* 
---@param cleanup boolean
---@return self
function ScrollView:removeAllChildrenWithCleanup (cleanup) end
---* 
---@return self
function ScrollView:removeAllChildren () end
---* When a widget is in a layout, you could call this method to get the next focused widget within a specified direction.<br>
---* If the widget is not in a layout, it will return itself<br>
---* param direction the direction to look for the next focused widget in a layout<br>
---* param current  the current focused widget<br>
---* return the next focused widget in a layout
---@param direction int
---@param current ccui.Widget
---@return ccui.Widget
function ScrollView:findNextFocusedWidget (direction,current) end
---* 
---@param child cc.Node
---@param cleanup boolean
---@return self
function ScrollView:removeChild (child,cleanup) end
---@overload fun():self
---@overload fun():self
---@return array_table
function ScrollView:getChildren () end
---* 
---@param tag int
---@return cc.Node
function ScrollView:getChildByTag (tag) end
---* 
---@return int
function ScrollView:getChildrenCount () end
---* Set layout type for scrollview.<br>
---* see `Layout::Type`<br>
---* param type  Layout type enum.
---@param type int
---@return self
function ScrollView:setLayoutType (type) end
---* Default constructor<br>
---* js ctor<br>
---* lua new
---@return self
function ScrollView:ScrollView () end