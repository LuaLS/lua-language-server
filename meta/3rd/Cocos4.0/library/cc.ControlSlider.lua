---@meta

---@class cc.ControlSlider :cc.Control
local ControlSlider={ }
cc.ControlSlider=ControlSlider




---* 
---@return float
function ControlSlider:getMaximumAllowedValue () end
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite):self
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite):self
---@param backgroundSprite cc.Sprite
---@param progressSprite cc.Sprite
---@param thumbSprite cc.Sprite
---@param selectedThumbSprite cc.Sprite
---@return boolean
function ControlSlider:initWithSprites (backgroundSprite,progressSprite,thumbSprite,selectedThumbSprite) end
---* 
---@return float
function ControlSlider:getMinimumAllowedValue () end
---* 
---@return float
function ControlSlider:getMaximumValue () end
---* 
---@return cc.Sprite
function ControlSlider:getSelectedThumbSprite () end
---* 
---@param var cc.Sprite
---@return self
function ControlSlider:setProgressSprite (var) end
---* 
---@param val float
---@return self
function ControlSlider:setMaximumValue (val) end
---* 
---@return float
function ControlSlider:getMinimumValue () end
---* 
---@param var cc.Sprite
---@return self
function ControlSlider:setThumbSprite (var) end
---* 
---@return float
function ControlSlider:getValue () end
---* 
---@return cc.Sprite
function ControlSlider:getBackgroundSprite () end
---* 
---@return cc.Sprite
function ControlSlider:getThumbSprite () end
---* 
---@param val float
---@return self
function ControlSlider:setValue (val) end
---* 
---@param touch cc.Touch
---@return vec2_table
function ControlSlider:locationFromTouch (touch) end
---* 
---@param val float
---@return self
function ControlSlider:setMinimumValue (val) end
---* 
---@param var float
---@return self
function ControlSlider:setMinimumAllowedValue (var) end
---* 
---@return cc.Sprite
function ControlSlider:getProgressSprite () end
---* 
---@param var cc.Sprite
---@return self
function ControlSlider:setSelectedThumbSprite (var) end
---* 
---@param var cc.Sprite
---@return self
function ControlSlider:setBackgroundSprite (var) end
---* 
---@param var float
---@return self
function ControlSlider:setMaximumAllowedValue (var) end
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite):self
---@overload fun(cc.Sprite0:char,cc.Sprite1:char,cc.Sprite2:char):self
---@overload fun(cc.Sprite0:char,cc.Sprite1:char,cc.Sprite2:char,cc.Sprite3:char):self
---@overload fun(cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite,cc.Sprite:cc.Sprite):self
---@param backgroundSprite cc.Sprite
---@param pogressSprite cc.Sprite
---@param thumbSprite cc.Sprite
---@param selectedThumbSprite cc.Sprite
---@return self
function ControlSlider:create (backgroundSprite,pogressSprite,thumbSprite,selectedThumbSprite) end
---* 
---@param touch cc.Touch
---@return boolean
function ControlSlider:isTouchInside (touch) end
---* 
---@param enabled boolean
---@return self
function ControlSlider:setEnabled (enabled) end
---* 
---@return self
function ControlSlider:needsLayout () end
---* js ctor<br>
---* lua new
---@return self
function ControlSlider:ControlSlider () end