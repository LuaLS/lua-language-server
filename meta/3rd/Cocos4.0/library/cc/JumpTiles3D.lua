---@meta

---@class cc.JumpTiles3D :cc.TiledGrid3DAction
local JumpTiles3D={ }
cc.JumpTiles3D=JumpTiles3D




---* brief Set the amplitude rate of the effect.<br>
---* param amplitudeRate The value of amplitude rate will be set.
---@param amplitudeRate float
---@return self
function JumpTiles3D:setAmplitudeRate (amplitudeRate) end
---* brief Initializes the action with the number of jumps, the sin amplitude, the grid size and the duration.<br>
---* param duration Specify the duration of the JumpTiles3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param numberOfJumps Specify the jump tiles count.<br>
---* param amplitude Specify the amplitude of the JumpTiles3D action.<br>
---* return If the initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param numberOfJumps unsigned_int
---@param amplitude float
---@return boolean
function JumpTiles3D:initWithDuration (duration,gridSize,numberOfJumps,amplitude) end
---* brief Get the amplitude of the effect.<br>
---* return Return the amplitude of the effect.
---@return float
function JumpTiles3D:getAmplitude () end
---* brief Get the amplitude rate of the effect.<br>
---* return Return the amplitude rate of the effect.
---@return float
function JumpTiles3D:getAmplitudeRate () end
---* brief Set the amplitude to the effect.<br>
---* param amplitude The value of amplitude will be set.
---@param amplitude float
---@return self
function JumpTiles3D:setAmplitude (amplitude) end
---* brief Create the action with the number of jumps, the sin amplitude, the grid size and the duration.<br>
---* param duration Specify the duration of the JumpTiles3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param numberOfJumps Specify the jump tiles count.<br>
---* param amplitude Specify the amplitude of the JumpTiles3D action.<br>
---* return If the creation success, return a pointer of JumpTiles3D action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@param numberOfJumps unsigned_int
---@param amplitude float
---@return self
function JumpTiles3D:create (duration,gridSize,numberOfJumps,amplitude) end
---* 
---@return self
function JumpTiles3D:clone () end
---* 
---@param time float
---@return self
function JumpTiles3D:update (time) end
---* 
---@return self
function JumpTiles3D:JumpTiles3D () end