---@meta

---@class cc.SpotLight :cc.BaseLight
local SpotLight={ }
cc.SpotLight=SpotLight




---* Returns the range of point or spot light.<br>
---* return The range of the point or spot light.
---@return float
function SpotLight:getRange () end
---* Sets the Direction in parent.<br>
---* param dir The Direction in parent.
---@param dir vec3_table
---@return self
function SpotLight:setDirection (dir) end
---*  get cos innerAngle 
---@return float
function SpotLight:getCosInnerAngle () end
---* Returns the outer angle of the spot light (in radians).
---@return float
function SpotLight:getOuterAngle () end
---* Returns the inner angle the spot light (in radians).
---@return float
function SpotLight:getInnerAngle () end
---* Returns the Direction in parent.
---@return vec3_table
function SpotLight:getDirection () end
---*  get cos outAngle 
---@return float
function SpotLight:getCosOuterAngle () end
---* Sets the outer angle of a spot light (in radians).<br>
---* param outerAngle The angle of spot light (in radians).
---@param outerAngle float
---@return self
function SpotLight:setOuterAngle (outerAngle) end
---* Sets the inner angle of a spot light (in radians).<br>
---* param angle The angle of spot light (in radians).
---@param angle float
---@return self
function SpotLight:setInnerAngle (angle) end
---* Returns direction in world.
---@return vec3_table
function SpotLight:getDirectionInWorld () end
---* Sets the range of point or spot light.<br>
---* param range The range of point or spot light.
---@param range float
---@return self
function SpotLight:setRange (range) end
---* Creates a spot light.<br>
---* param direction The light's direction<br>
---* param position The light's position<br>
---* param color The light's color.<br>
---* param innerAngle The light's inner angle (in radians).<br>
---* param outerAngle The light's outer angle (in radians).<br>
---* param range The light's range.<br>
---* return The new spot light.
---@param direction vec3_table
---@param position vec3_table
---@param color color3b_table
---@param innerAngle float
---@param outerAngle float
---@param range float
---@return self
function SpotLight:create (direction,position,color,innerAngle,outerAngle,range) end
---* 
---@return int
function SpotLight:getLightType () end
---* 
---@return self
function SpotLight:SpotLight () end