---@meta

---@class cc.GridBase :cc.Ref
local GridBase={ }
cc.GridBase=GridBase




---* Set the size of the grid.
---@param gridSize size_table
---@return self
function GridBase:setGridSize (gridSize) end
---* brief Set the effect grid rect.<br>
---* param rect The effect grid rect.
---@param rect rect_table
---@return self
function GridBase:setGridRect (rect) end
---* Interface, Calculate the vertices used for the blit.
---@return self
function GridBase:calculateVertexPoints () end
---* Interface, Reuse the grid vertices.
---@return self
function GridBase:reuse () end
---* Init and reset the status when render effects by using the grid.
---@return self
function GridBase:beforeDraw () end
---* brief Get the effect grid rect.<br>
---* return Return the effect grid rect.
---@return rect_table
function GridBase:getGridRect () end
---*  is texture flipped. 
---@return boolean
function GridBase:isTextureFlipped () end
---*  Size of the grid. 
---@return size_table
function GridBase:getGridSize () end
---* 
---@return self
function GridBase:afterBlit () end
---* Change projection to 2D for grabbing.
---@return self
function GridBase:set2DProjection () end
---*  Pixels between the grids. 
---@return vec2_table
function GridBase:getStep () end
---* Get the pixels between the grids.
---@param step vec2_table
---@return self
function GridBase:setStep (step) end
---* Set the texture flipped or not.
---@param flipped boolean
---@return self
function GridBase:setTextureFlipped (flipped) end
---* Interface used to blit the texture with grid to screen.
---@return self
function GridBase:blit () end
---* 
---@param active boolean
---@return self
function GridBase:setActive (active) end
---*  Get number of times that the grid will be reused. 
---@return int
function GridBase:getReuseGrid () end
---@overload fun(size_table:size_table,cc.Texture2D1:rect_table):self
---@overload fun(size_table:size_table):self
---@overload fun(size_table:size_table,cc.Texture2D:cc.Texture2D,boolean:boolean):self
---@overload fun(size_table:size_table,cc.Texture2D:cc.Texture2D,boolean:boolean,rect_table:rect_table):self
---@param gridSize size_table
---@param texture cc.Texture2D
---@param flipped boolean
---@param rect rect_table
---@return boolean
function GridBase:initWithSize (gridSize,texture,flipped,rect) end
---* Interface for custom action when before or after draw.<br>
---* js NA
---@return self
function GridBase:beforeBlit () end
---*  Set number of times that the grid will be reused. 
---@param reuseGrid int
---@return self
function GridBase:setReuseGrid (reuseGrid) end
---* Getter and setter of the active state of the grid.
---@return boolean
function GridBase:isActive () end
---* 
---@param target cc.Node
---@return self
function GridBase:afterDraw (target) end