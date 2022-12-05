---@meta

---@class cc.AmbientLight :cc.BaseLight
local AmbientLight={ }
cc.AmbientLight=AmbientLight




---* Creates a ambient light.<br>
---* param color The light's color.<br>
---* return The new ambient light.
---@param color color3b_table
---@return self
function AmbientLight:create (color) end
---* 
---@return int
function AmbientLight:getLightType () end
---* 
---@return self
function AmbientLight:AmbientLight () end