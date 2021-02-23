---@meta

---@class cc.Ripple3D :cc.Grid3DAction
local Ripple3D={ }
cc.Ripple3D=Ripple3D




---* brief Set the amplitude rate of ripple effect.<br>
---* param fAmplitudeRate The amplitude rate of ripple effect.
---@param fAmplitudeRate float
---@return self
function Ripple3D:setAmplitudeRate (fAmplitudeRate) end
---* brief Initializes the action with center position, radius, number of waves, amplitude, a grid size and duration.<br>
---* param duration Specify the duration of the Ripple3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param position Specify the center position of the ripple effect.<br>
---* param radius Specify the radius of the ripple effect.<br>
---* param waves Specify the waves count of the ripple effect.<br>
---* param amplitude Specify the amplitude of the ripple effect.<br>
---* return If the initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param position vec2_table
---@param radius float
---@param waves unsigned_int
---@param amplitude float
---@return boolean
function Ripple3D:initWithDuration (duration,gridSize,position,radius,waves,amplitude) end
---* brief Get the amplitude rate of ripple effect.<br>
---* return The amplitude rate of ripple effect.
---@return float
function Ripple3D:getAmplitudeRate () end
---* brief Set the amplitude of ripple effect.<br>
---* param fAmplitude The amplitude of ripple effect.
---@param fAmplitude float
---@return self
function Ripple3D:setAmplitude (fAmplitude) end
---* brief Get the amplitude of ripple effect.<br>
---* return The amplitude of ripple effect.
---@return float
function Ripple3D:getAmplitude () end
---* brief Set the center position of ripple effect.<br>
---* param position The center position of ripple effect will be set.
---@param position vec2_table
---@return self
function Ripple3D:setPosition (position) end
---* brief Get the center position of ripple effect.<br>
---* return The center position of ripple effect.
---@return vec2_table
function Ripple3D:getPosition () end
---* brief Create the action with center position, radius, number of waves, amplitude, a grid size and duration.<br>
---* param duration Specify the duration of the Ripple3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param position Specify the center position of the ripple effect.<br>
---* param radius Specify the radius of the ripple effect.<br>
---* param waves Specify the waves count of the ripple effect.<br>
---* param amplitude Specify the amplitude of the ripple effect.<br>
---* return If the creation success, return a pointer of Ripple3D action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@param position vec2_table
---@param radius float
---@param waves unsigned_int
---@param amplitude float
---@return self
function Ripple3D:create (duration,gridSize,position,radius,waves,amplitude) end
---* 
---@return self
function Ripple3D:clone () end
---* 
---@param time float
---@return self
function Ripple3D:update (time) end
---* 
---@return self
function Ripple3D:Ripple3D () end