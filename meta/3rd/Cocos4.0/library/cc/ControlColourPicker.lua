---@meta

---@class cc.ControlColourPicker :cc.Control
local ControlColourPicker={ }
cc.ControlColourPicker=ControlColourPicker




---* 
---@param sender cc.Ref
---@param controlEvent int
---@return self
function ControlColourPicker:hueSliderValueChanged (sender,controlEvent) end
---* 
---@return cc.ControlHuePicker
function ControlColourPicker:getHuePicker () end
---* 
---@return cc.ControlSaturationBrightnessPicker
function ControlColourPicker:getcolourPicker () end
---* 
---@param var cc.Sprite
---@return self
function ControlColourPicker:setBackground (var) end
---* 
---@param var cc.ControlSaturationBrightnessPicker
---@return self
function ControlColourPicker:setcolourPicker (var) end
---* 
---@param sender cc.Ref
---@param controlEvent int
---@return self
function ControlColourPicker:colourSliderValueChanged (sender,controlEvent) end
---* 
---@param var cc.ControlHuePicker
---@return self
function ControlColourPicker:setHuePicker (var) end
---* 
---@return cc.Sprite
function ControlColourPicker:getBackground () end
---* 
---@return self
function ControlColourPicker:create () end
---* 
---@param bEnabled boolean
---@return self
function ControlColourPicker:setEnabled (bEnabled) end
---* 
---@return boolean
function ControlColourPicker:init () end
---* 
---@param colorValue color3b_table
---@return self
function ControlColourPicker:setColor (colorValue) end
---* js ctor<br>
---* lua new
---@return self
function ControlColourPicker:ControlColourPicker () end