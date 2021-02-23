---@meta

---@class cc.FadeOutDownTiles :cc.FadeOutUpTiles
local FadeOutDownTiles={ }
cc.FadeOutDownTiles=FadeOutDownTiles




---* brief Create the action with the grid size and the duration.<br>
---* param duration Specify the duration of the FadeOutDownTiles action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* return If the creation success, return a pointer of FadeOutDownTiles action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@return self
function FadeOutDownTiles:create (duration,gridSize) end
---* 
---@return self
function FadeOutDownTiles:clone () end
---* 
---@param pos size_table
---@param time float
---@return float
function FadeOutDownTiles:testFunc (pos,time) end
---* 
---@return self
function FadeOutDownTiles:FadeOutDownTiles () end