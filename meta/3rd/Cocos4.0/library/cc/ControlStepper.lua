---@meta

---@class cc.ControlStepper :cc.Control
local ControlStepper={ }
cc.ControlStepper=ControlStepper




---* 
---@return cc.Sprite
function ControlStepper:getMinusSprite () end
---* 
---@param value double
---@return self
function ControlStepper:setValue (value) end
---* 
---@param stepValue double
---@return self
function ControlStepper:setStepValue (stepValue) end
---* 
---@param minusSprite cc.Sprite
---@param plusSprite cc.Sprite
---@return boolean
function ControlStepper:initWithMinusSpriteAndPlusSprite (minusSprite,plusSprite) end
---*  Set the numeric value of the stepper. If send is true, the Control::EventType::VALUE_CHANGED is sent. 
---@param value double
---@param send boolean
---@return self
function ControlStepper:setValueWithSendingEvent (value,send) end
---* 
---@param maximumValue double
---@return self
function ControlStepper:setMaximumValue (maximumValue) end
---* 
---@return cc.Label
function ControlStepper:getMinusLabel () end
---* 
---@return cc.Label
function ControlStepper:getPlusLabel () end
---* 
---@param wraps boolean
---@return self
function ControlStepper:setWraps (wraps) end
---* 
---@param var cc.Label
---@return self
function ControlStepper:setMinusLabel (var) end
---*  Start the autorepeat increment/decrement. 
---@return self
function ControlStepper:startAutorepeat () end
---*  Update the layout of the stepper with the given touch location. 
---@param location vec2_table
---@return self
function ControlStepper:updateLayoutUsingTouchLocation (location) end
---* 
---@return boolean
function ControlStepper:isContinuous () end
---*  Stop the autorepeat. 
---@return self
function ControlStepper:stopAutorepeat () end
---* 
---@param minimumValue double
---@return self
function ControlStepper:setMinimumValue (minimumValue) end
---* 
---@param var cc.Label
---@return self
function ControlStepper:setPlusLabel (var) end
---* 
---@return double
function ControlStepper:getValue () end
---* 
---@return cc.Sprite
function ControlStepper:getPlusSprite () end
---* 
---@param var cc.Sprite
---@return self
function ControlStepper:setPlusSprite (var) end
---* 
---@param var cc.Sprite
---@return self
function ControlStepper:setMinusSprite (var) end
---* 
---@param minusSprite cc.Sprite
---@param plusSprite cc.Sprite
---@return self
function ControlStepper:create (minusSprite,plusSprite) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlStepper:onTouchMoved (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlStepper:onTouchEnded (pTouch,pEvent) end
---* 
---@param dt float
---@return self
function ControlStepper:update (dt) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return boolean
function ControlStepper:onTouchBegan (pTouch,pEvent) end
---* js ctor<br>
---* lua new
---@return self
function ControlStepper:ControlStepper () end