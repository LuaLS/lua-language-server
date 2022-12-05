---@meta

---@class cc.ShuffleTiles :cc.TiledGrid3DAction
local ShuffleTiles={ }
cc.ShuffleTiles=ShuffleTiles




---* brief Initializes the action with grid size, random seed and duration.<br>
---* param duration Specify the duration of the ShuffleTiles action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param seed Specify the random seed.<br>
---* return If the Initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param seed unsigned_int
---@return boolean
function ShuffleTiles:initWithDuration (duration,gridSize,seed) end
---* 
---@param pos size_table
---@return size_table
function ShuffleTiles:getDelta (pos) end
---* brief Create the action with grid size, random seed and duration.<br>
---* param duration Specify the duration of the ShuffleTiles action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param seed Specify the random seed.<br>
---* return If the creation success, return a pointer of ShuffleTiles action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@param seed unsigned_int
---@return self
function ShuffleTiles:create (duration,gridSize,seed) end
---* 
---@param target cc.Node
---@return self
function ShuffleTiles:startWithTarget (target) end
---* 
---@return self
function ShuffleTiles:clone () end
---* 
---@param time float
---@return self
function ShuffleTiles:update (time) end
---* 
---@return self
function ShuffleTiles:ShuffleTiles () end