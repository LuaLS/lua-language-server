---@meta

---@class cc.ReuseGrid :cc.ActionInstant
local ReuseGrid={ }
cc.ReuseGrid=ReuseGrid




---* brief Initializes an action with the number of times that the current grid will be reused.<br>
---* param times Specify times the grid will be reused.<br>
---* return If the initialization success, return true; otherwise, return false.
---@param times int
---@return boolean
function ReuseGrid:initWithTimes (times) end
---* brief Create an action with the number of times that the current grid will be reused.<br>
---* param times Specify times the grid will be reused.<br>
---* return Return a pointer of ReuseGrid. When the creation failed, return nil.
---@param times int
---@return self
function ReuseGrid:create (times) end
---* 
---@param target cc.Node
---@return self
function ReuseGrid:startWithTarget (target) end
---* 
---@return self
function ReuseGrid:clone () end
---* 
---@return self
function ReuseGrid:reverse () end
---* 
---@return self
function ReuseGrid:ReuseGrid () end