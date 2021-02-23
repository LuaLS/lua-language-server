---@meta

---@class ccui.TabControl :ccui.Widget
local TabControl={ }
ccui.TabControl=TabControl




---* set header width, affect all tab<br>
---* param headerWidth each tab header's width
---@param headerWidth float
---@return self
function TabControl:setHeaderWidth (headerWidth) end
---* remove the tab from this TabControl<br>
---* param index The index of tab
---@param index int
---@return self
function TabControl:removeTab (index) end
---* get the count of tabs in this TabControl<br>
---* return the count of tabs
---@return unsigned_int
function TabControl:getTabCount () end
---* 
---@return int
function TabControl:getHeaderDockPlace () end
---* get current selected tab's index<br>
---* return the current selected tab index
---@return int
function TabControl:getSelectedTabIndex () end
---* insert tab, and init the position of header and container<br>
---* param index The index tab should be<br>
---* param header The header Button, will be a protected child in TabControl<br>
---* param container The container, will be a protected child in TabControl
---@param index int
---@param header ccui.TabHeader
---@param container ccui.Layout
---@return self
function TabControl:insertTab (index,header,container) end
---* ignore the textures' size in header, scale them with _headerWidth and _headerHeight<br>
---* param ignore is `true`, the header's texture scale with _headerWidth and _headerHeight<br>
---* ignore is `false`, use the texture's size, do not scale them
---@param ignore boolean
---@return self
function TabControl:ignoreHeadersTextureSize (ignore) end
---* get tab header's width<br>
---* return header's width
---@return float
function TabControl:getHeaderWidth () end
---* the header dock place of header in TabControl<br>
---* param dockPlace The strip place
---@param dockPlace int
---@return self
function TabControl:setHeaderDockPlace (dockPlace) end
---@overload fun(int0:ccui.TabHeader):self
---@overload fun(int:int):self
---@param index int
---@return self
function TabControl:setSelectTab (index) end
---* get TabHeader<br>
---* param index The index of tab
---@param index int
---@return ccui.TabHeader
function TabControl:getTabHeader (index) end
---* get whether ignore the textures' size in header, scale them with _headerWidth and _headerHeight<br>
---* return whether ignore the textures' size in header
---@return boolean
function TabControl:isIgnoreHeadersTextureSize () end
---* Add a callback function which would be called when selected tab changed<br>
---* param callback A std::function with type @see `ccTabControlCallback`
---@param callback function
---@return self
function TabControl:setTabChangedEventListener (callback) end
---* set the delta zoom of selected tab<br>
---* param zoom The delta zoom
---@param zoom float
---@return self
function TabControl:setHeaderSelectedZoom (zoom) end
---* set header height, affect all tab<br>
---* param headerHeight each tab header's height
---@param headerHeight float
---@return self
function TabControl:setHeaderHeight (headerHeight) end
---* get the index of tabCell in TabView, return -1 if not exists in.<br>
---* return the index of tabCell in TabView, `-1` means not exists in.
---@param tabCell ccui.TabHeader
---@return int
function TabControl:indexOfTabHeader (tabCell) end
---* get Container<br>
---* param index The index of tab
---@param index int
---@return ccui.Layout
function TabControl:getTabContainer (index) end
---* get the delta zoom of selected tab<br>
---* return zoom, the delta zoom
---@return float
function TabControl:getHeaderSelectedZoom () end
---* get tab header's height<br>
---* return header's height
---@return int
function TabControl:getHeaderHeight () end
---* 
---@return self
function TabControl:create () end