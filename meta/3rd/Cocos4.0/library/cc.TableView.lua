---@meta

---@class cc.TableView :ccui.ScrollView@all parent class: ScrollView,ScrollViewDelegate
local TableView={ }
cc.TableView=TableView




---* Updates the content of the cell at a given index.<br>
---* param idx index to find a cell
---@param idx int
---@return self
function TableView:updateCellAtIndex (idx) end
---* determines how cell is ordered and filled in the view.
---@param order int
---@return self
function TableView:setVerticalFillOrder (order) end
---* 
---@return self
function TableView:_updateContentSize () end
---* 
---@return int
function TableView:getVerticalFillOrder () end
---* Removes a cell at a given index<br>
---* param idx index to find a cell
---@param idx int
---@return self
function TableView:removeCellAtIndex (idx) end
---* 
---@param size size_table
---@param container cc.Node
---@return boolean
function TableView:initWithViewSize (size,container) end
---* 
---@param view cc.ScrollView
---@return self
function TableView:scrollViewDidScroll (view) end
---* reloads data from data source.  the view will be refreshed.
---@return self
function TableView:reloadData () end
---* 
---@param view cc.ScrollView
---@return self
function TableView:scrollViewDidZoom (view) end
---* Inserts a new cell at a given index<br>
---* param idx location to insert
---@param idx int
---@return self
function TableView:insertCellAtIndex (idx) end
---* Returns an existing cell at a given index. Returns nil if a cell is nonexistent at the moment of query.<br>
---* param idx index<br>
---* return a cell at a given index
---@param idx int
---@return cc.TableViewCell
function TableView:cellAtIndex (idx) end
---* Dequeues a free cell if available. nil if not.<br>
---* return free cell
---@return cc.TableViewCell
function TableView:dequeueCell () end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function TableView:onTouchMoved (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function TableView:onTouchEnded (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function TableView:onTouchCancelled (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return boolean
function TableView:onTouchBegan (pTouch,pEvent) end
---* js ctor<br>
---* lua new
---@return self
function TableView:TableView () end