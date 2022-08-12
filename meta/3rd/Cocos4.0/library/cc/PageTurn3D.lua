---@meta

---@class cc.PageTurn3D :cc.Grid3DAction
local PageTurn3D={ }
cc.PageTurn3D=PageTurn3D




---* brief Create an action with duration, grid size.<br>
---* param duration Specify the duration of the PageTurn3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* return If the creation success, return a pointer of PageTurn3D action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@return self
function PageTurn3D:create (duration,gridSize) end
---* 
---@return self
function PageTurn3D:clone () end
---* js NA 
---@return cc.GridBase
function PageTurn3D:getGrid () end
---* 
---@param time float
---@return self
function PageTurn3D:update (time) end