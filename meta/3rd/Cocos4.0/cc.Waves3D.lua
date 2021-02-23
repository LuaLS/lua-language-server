---@meta

---@class cc.Waves3D :cc.Grid3DAction
local Waves3D={ }
cc.Waves3D=Waves3D




---* brief Set the amplitude rate of the effect.<br>
---* param amplitudeRate The value of amplitude rate will be set.
---@param amplitudeRate float
---@return self
function Waves3D:setAmplitudeRate (amplitudeRate) end
---* brief Initializes an action with duration, grid size, waves and amplitude.<br>
---* param duration Specify the duration of the Waves3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param waves Specify the waves count of the Waves3D action.<br>
---* param amplitude Specify the amplitude of the Waves3D action.<br>
---* return If the initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param waves unsigned_int
---@param amplitude float
---@return boolean
function Waves3D:initWithDuration (duration,gridSize,waves,amplitude) end
---* brief Get the amplitude of the effect.<br>
---* return Return the amplitude of the effect.
---@return float
function Waves3D:getAmplitude () end
---* brief Get the amplitude rate of the effect.<br>
---* return Return the amplitude rate of the effect.
---@return float
function Waves3D:getAmplitudeRate () end
---* brief Set the amplitude to the effect.<br>
---* param amplitude The value of amplitude will be set.
---@param amplitude float
---@return self
function Waves3D:setAmplitude (amplitude) end
---* brief Create an action with duration, grid size, waves and amplitude.<br>
---* param duration Specify the duration of the Waves3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param waves Specify the waves count of the Waves3D action.<br>
---* param amplitude Specify the amplitude of the Waves3D action.<br>
---* return If the creation success, return a pointer of Waves3D action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@param waves unsigned_int
---@param amplitude float
---@return self
function Waves3D:create (duration,gridSize,waves,amplitude) end
---* 
---@return self
function Waves3D:clone () end
---* 
---@param time float
---@return self
function Waves3D:update (time) end
---* 
---@return self
function Waves3D:Waves3D () end