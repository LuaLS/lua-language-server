---@meta

---@class cc.BaseLight :cc.Node
local BaseLight={ }
cc.BaseLight=BaseLight




---* light enabled getter and setter.
---@param enabled boolean
---@return self
function BaseLight:setEnabled (enabled) end
---*  intensity getter and setter 
---@return float
function BaseLight:getIntensity () end
---* 
---@return boolean
function BaseLight:isEnabled () end
---* Get the light type,light type MUST be one of LightType::DIRECTIONAL ,<br>
---* LightType::POINT, LightType::SPOT, LightType::AMBIENT.
---@return int
function BaseLight:getLightType () end
---* 
---@param flag int
---@return self
function BaseLight:setLightFlag (flag) end
---* 
---@param intensity float
---@return self
function BaseLight:setIntensity (intensity) end
---* light flag getter and setter
---@return int
function BaseLight:getLightFlag () end