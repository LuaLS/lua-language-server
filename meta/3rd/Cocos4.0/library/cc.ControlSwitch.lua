---@meta

---@class cc.ControlSwitch :cc.Control
local ControlSwitch={ }
cc.ControlSwitch=ControlSwitch




---@overload fun(boolean:boolean):self
---@overload fun(boolean:boolean,boolean:boolean):self
---@param isOn boolean
---@param animated boolean
---@return self
function ControlSwitch:setOn (isOn,animated) end
---* 
---@param touch cc.Touch
---@return vec2_table
function ControlSwitch:locationFromTouch (touch) end
---* 
---@return boolean
function ControlSwitch:isOn () end
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Label:cc.Label,cc.Label:cc.Label):self
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite):self
---@param maskSprite cc.Sprite
---@param onSprite cc.Sprite
---@param offSprite cc.Sprite
---@param thumbSprite cc.Sprite
---@param onLabel cc.Label
---@param offLabel cc.Label
---@return boolean
function ControlSwitch:initWithMaskSprite (maskSprite,onSprite,offSprite,thumbSprite,onLabel,offLabel) end
---* 
---@return boolean
function ControlSwitch:hasMoved () end
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite):self
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Label:cc.Label,cc.Label:cc.Label):self
---@param maskSprite cc.Sprite
---@param onSprite cc.Sprite
---@param offSprite cc.Sprite
---@param thumbSprite cc.Sprite
---@param onLabel cc.Label
---@param offLabel cc.Label
---@return self
function ControlSwitch:create (maskSprite,onSprite,offSprite,thumbSprite,onLabel,offLabel) end
---* 
---@param enabled boolean
---@return self
function ControlSwitch:setEnabled (enabled) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlSwitch:onTouchMoved (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlSwitch:onTouchEnded (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlSwitch:onTouchCancelled (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return boolean
function ControlSwitch:onTouchBegan (pTouch,pEvent) end
---* js ctor<br>
---* lua new
---@return self
function ControlSwitch:ControlSwitch () end