---@meta

---@class cc.Lens3D :cc.Grid3DAction
local Lens3D={ }
cc.Lens3D=Lens3D




---* brief Set whether lens is concave.<br>
---* param concave Whether lens is concave.
---@param concave boolean
---@return self
function Lens3D:setConcave (concave) end
---* brief Initializes the action with center position, radius, grid size and duration.<br>
---* param duration Specify the duration of the Lens3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param position Specify the center position of the lens effect.<br>
---* param radius Specify the radius of the lens effect.<br>
---* return If the initialization success, return true; otherwise, return false.
---@param duration float
---@param gridSize size_table
---@param position vec2_table
---@param radius float
---@return boolean
function Lens3D:initWithDuration (duration,gridSize,position,radius) end
---* brief Set the value of lens effect.<br>
---* param lensEffect The value of lens effect will be set.
---@param lensEffect float
---@return self
function Lens3D:setLensEffect (lensEffect) end
---* brief Get the value of lens effect. Default value is 0.7.<br>
---* return The value of lens effect.
---@return float
function Lens3D:getLensEffect () end
---* brief Set the center position of lens effect.<br>
---* param position The center position will be set.
---@param position vec2_table
---@return self
function Lens3D:setPosition (position) end
---* brief Get the center position of lens effect.<br>
---* return The center position of lens effect.
---@return vec2_table
function Lens3D:getPosition () end
---* brief Create the action with center position, radius, a grid size and duration.<br>
---* param duration Specify the duration of the Lens3D action. It's a value in seconds.<br>
---* param gridSize Specify the size of the grid.<br>
---* param position Specify the center position of the lens.<br>
---* param radius Specify the radius of the lens.<br>
---* return If the creation success, return a pointer of Lens3D action; otherwise, return nil.
---@param duration float
---@param gridSize size_table
---@param position vec2_table
---@param radius float
---@return self
function Lens3D:create (duration,gridSize,position,radius) end
---* 
---@return self
function Lens3D:clone () end
---* 
---@param time float
---@return self
function Lens3D:update (time) end
---* 
---@return self
function Lens3D:Lens3D () end