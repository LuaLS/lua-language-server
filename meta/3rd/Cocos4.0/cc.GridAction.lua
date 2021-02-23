---@meta

---@class cc.GridAction :cc.ActionInterval
local GridAction={ }
cc.GridAction=GridAction




---* brief Get the pointer of GridBase.<br>
---* return The pointer of GridBase.
---@return cc.GridBase
function GridAction:getGrid () end
---* brief Initializes the action with size and duration.<br>
---* param duration The duration of the GridAction. It's a value in seconds.<br>
---* param gridSize The size of the GridAction should be.<br>
---* return Return true when the initialization success, otherwise return false.
---@param duration float
---@param gridSize size_table
---@return boolean
function GridAction:initWithDuration (duration,gridSize) end
---* 
---@param target cc.Node
---@return self
function GridAction:startWithTarget (target) end
---* 
---@return self
function GridAction:clone () end
---* 
---@return self
function GridAction:reverse () end