---@meta

---@class cc.ControlSaturationBrightnessPicker :cc.Control
local ControlSaturationBrightnessPicker={ }
cc.ControlSaturationBrightnessPicker=ControlSaturationBrightnessPicker




---* 
---@return cc.Sprite
function ControlSaturationBrightnessPicker:getShadow () end
---* 
---@param target cc.Node
---@param pos vec2_table
---@return boolean
function ControlSaturationBrightnessPicker:initWithTargetAndPos (target,pos) end
---* 
---@return vec2_table
function ControlSaturationBrightnessPicker:getStartPos () end
---* 
---@return cc.Sprite
function ControlSaturationBrightnessPicker:getOverlay () end
---* 
---@return cc.Sprite
function ControlSaturationBrightnessPicker:getSlider () end
---* 
---@return cc.Sprite
function ControlSaturationBrightnessPicker:getBackground () end
---* 
---@return float
function ControlSaturationBrightnessPicker:getSaturation () end
---* 
---@return float
function ControlSaturationBrightnessPicker:getBrightness () end
---* 
---@param target cc.Node
---@param pos vec2_table
---@return self
function ControlSaturationBrightnessPicker:create (target,pos) end
---* 
---@param enabled boolean
---@return self
function ControlSaturationBrightnessPicker:setEnabled (enabled) end
---* js ctor
---@return self
function ControlSaturationBrightnessPicker:ControlSaturationBrightnessPicker () end