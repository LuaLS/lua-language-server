---@meta

---@class cc.NodeGrid :cc.Node
local NodeGrid={ }
cc.NodeGrid=NodeGrid




---* brief Set the effect grid rect.<br>
---* param gridRect The effect grid rect.
---@param gridRect rect_table
---@return self
function NodeGrid:setGridRect (gridRect) end
---*  Set the Grid Target. <br>
---* param target A Node is used to set the Grid Target.
---@param target cc.Node
---@return self
function NodeGrid:setTarget (target) end
---* Changes a grid object that is used when applying effects.<br>
---* param grid  A Grid object that is used when applying effects.
---@param grid cc.GridBase
---@return self
function NodeGrid:setGrid (grid) end
---@overload fun():cc.GridBase
---@overload fun():cc.GridBase
---@return cc.GridBase
function NodeGrid:getGrid () end
---* brief Get the effect grid rect.<br>
---* return Return the effect grid rect.
---@return rect_table
function NodeGrid:getGridRect () end
---@overload fun(rect_table:rect_table):self
---@overload fun():self
---@param rect rect_table
---@return self
function NodeGrid:create (rect) end
---* 
---@param renderer cc.Renderer
---@param parentTransform mat4_table
---@param parentFlags unsigned_int
---@return self
function NodeGrid:visit (renderer,parentTransform,parentFlags) end
---* 
---@return self
function NodeGrid:NodeGrid () end