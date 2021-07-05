---@meta

---@class cc.Twirl :cc.Grid3DAction
local Twirl={ }
cc.Twirl=Twirl




---* brief Set the amplitude rate of the effect.<br>
---* param amplitudeRate The value of amplitude rate will be set.
---@param amplitudeRate float
---@return self
function Twirl:setAmplitudeRate (amplitudeRate) end
---* brief Initializes the action with center position, number of twirls, amplitude, a grid size and duration.<br>
---* param duration Specify the duration of the Twirl action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param position Specify the center position of the twirl action.<br>
---* param twirls Specify the twirls count of the Twirl action.<br>
---* param amplitude Specify the amplitude of the Twirl action.<br>
---* return If the initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param position vec2_table
---@param twirls unsigned_int
---@param amplitude float
---@return boolean
function Twirl:initWithDuration (duration,gridSize,position,twirls,amplitude) end
---* brief Get the amplitude rate of the effect.<br>
---* return Return the amplitude rate of the effect.
---@return float
function Twirl:getAmplitudeRate () end
---* brief Set the amplitude to the effect.<br>
---* param amplitude The value of amplitude will be set.
---@param amplitude float
---@return self
function Twirl:setAmplitude (amplitude) end
---* brief Get the amplitude of the effect.<br>
---* return Return the amplitude of the effect.
---@return float
function Twirl:getAmplitude () end
---* brief Set the center position of twirl action.<br>
---* param position The center position of twirl action will be set.
---@param position vec2_table
---@return self
function Twirl:setPosition (position) end
---* brief Get the center position of twirl action.<br>
---* return The center position of twirl action.
---@return vec2_table
function Twirl:getPosition () end
---* brief Create the action with center position, number of twirls, amplitude, a grid size and duration.<br>
---* param duration Specify the duration of the Twirl action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param position Specify the center position of the twirl action.<br>
---* param twirls Specify the twirls count of the Twirl action.<br>
---* param amplitude Specify the amplitude of the Twirl action.<br>
---* return If the creation success, return a pointer of Twirl action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@param position vec2_table
---@param twirls unsigned_int
---@param amplitude float
---@return self
function Twirl:create (duration,gridSize,position,twirls,amplitude) end
---* 
---@return self
function Twirl:clone () end
---* 
---@param time float
---@return self
function Twirl:update (time) end
---* 
---@return self
function Twirl:Twirl () end