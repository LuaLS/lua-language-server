---@meta

---@class cc.PointLight :cc.BaseLight
local PointLight={ }
cc.PointLight=PointLight




---*  get or set range 
---@return float
function PointLight:getRange () end
---* 
---@param range float
---@return point_table
function PointLight:setRange (range) end
---* Creates a point light.<br>
---* param position The light's position<br>
---* param color The light's color.<br>
---* param range The light's range.<br>
---* return The new point light.
---@param position vec3_table
---@param color color3b_table
---@param range float
---@return point_table
function PointLight:create (position,color,range) end
---* 
---@return int
function PointLight:getLightType () end
---* 
---@return point_table
function PointLight:PointLight () end