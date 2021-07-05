---@meta

---@class cc.TurnOffTiles :cc.TiledGrid3DAction
local TurnOffTiles={ }
cc.TurnOffTiles=TurnOffTiles




---* brief Show the tile at specified position.<br>
---* param pos The position index of the tile should be shown.
---@param pos vec2_table
---@return self
function TurnOffTiles:turnOnTile (pos) end
---* brief Hide the tile at specified position.<br>
---* param pos The position index of the tile should be hide.
---@param pos vec2_table
---@return self
function TurnOffTiles:turnOffTile (pos) end
---* brief Initializes the action with grid size, random seed and duration.<br>
---* param duration Specify the duration of the TurnOffTiles action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param seed Specify the random seed.<br>
---* return If the Initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param seed unsigned_int
---@return boolean
function TurnOffTiles:initWithDuration (duration,gridSize,seed) end
---@overload fun(float:float,size_table:size_table,unsigned_int:unsigned_int):self
---@overload fun(float:float,size_table:size_table):self
---@param duration float
---@param gridSize size_table
---@param seed unsigned_int
---@return self
function TurnOffTiles:create (duration,gridSize,seed) end
---* 
---@param target cc.Node
---@return self
function TurnOffTiles:startWithTarget (target) end
---* 
---@return self
function TurnOffTiles:clone () end
---* 
---@param time float
---@return self
function TurnOffTiles:update (time) end
---* 
---@return self
function TurnOffTiles:TurnOffTiles () end