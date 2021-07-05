---@meta

---@class cc.ControlHuePicker :cc.Control
local ControlHuePicker={ }
cc.ControlHuePicker=ControlHuePicker




---* 
---@param target cc.Node
---@param pos vec2_table
---@return boolean
function ControlHuePicker:initWithTargetAndPos (target,pos) end
---* 
---@param val float
---@return self
function ControlHuePicker:setHue (val) end
---* 
---@return vec2_table
function ControlHuePicker:getStartPos () end
---* 
---@return float
function ControlHuePicker:getHue () end
---* 
---@return cc.Sprite
function ControlHuePicker:getSlider () end
---* 
---@param var cc.Sprite
---@return self
function ControlHuePicker:setBackground (var) end
---* 
---@param val float
---@return self
function ControlHuePicker:setHuePercentage (val) end
---* 
---@return cc.Sprite
function ControlHuePicker:getBackground () end
---* 
---@return float
function ControlHuePicker:getHuePercentage () end
---* 
---@param var cc.Sprite
---@return self
function ControlHuePicker:setSlider (var) end
---* 
---@param target cc.Node
---@param pos vec2_table
---@return self
function ControlHuePicker:create (target,pos) end
---* 
---@param enabled boolean
---@return self
function ControlHuePicker:setEnabled (enabled) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlHuePicker:onTouchMoved (pTouch,pEvent) end
---* 
---@param touch cc.Touch
---@param pEvent cc.Event
---@return boolean
function ControlHuePicker:onTouchBegan (touch,pEvent) end
---* js ctor
---@return self
function ControlHuePicker:ControlHuePicker () end