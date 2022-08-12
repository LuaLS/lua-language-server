---@meta

---@class cc.TableViewCell :cc.Node
local TableViewCell={ }
cc.TableViewCell=TableViewCell




---* Cleans up any resources linked to this cell and resets <code>idx</code> property.
---@return self
function TableViewCell:reset () end
---* The index used internally by SWTableView and its subclasses
---@return int
function TableViewCell:getIdx () end
---* 
---@param uIdx int
---@return self
function TableViewCell:setIdx (uIdx) end
---* 
---@return self
function TableViewCell:create () end
---* 
---@return self
function TableViewCell:TableViewCell () end