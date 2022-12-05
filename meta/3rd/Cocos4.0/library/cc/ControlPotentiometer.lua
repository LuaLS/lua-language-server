---@meta

---@class cc.ControlPotentiometer :cc.Control
local ControlPotentiometer={ }
cc.ControlPotentiometer=ControlPotentiometer




---* 
---@param var vec2_table
---@return self
function ControlPotentiometer:setPreviousLocation (var) end
---* 
---@param value float
---@return self
function ControlPotentiometer:setValue (value) end
---* 
---@return cc.ProgressTimer
function ControlPotentiometer:getProgressTimer () end
---* 
---@return float
function ControlPotentiometer:getMaximumValue () end
---*  Returns the angle in degree between line1 and line2. 
---@param beginLineA vec2_table
---@param endLineA vec2_table
---@param beginLineB vec2_table
---@param endLineB vec2_table
---@return float
function ControlPotentiometer:angleInDegreesBetweenLineFromPoint_toPoint_toLineFromPoint_toPoint (beginLineA,endLineA,beginLineB,endLineB) end
---*  Factorize the event dispatch into these methods. 
---@param location vec2_table
---@return self
function ControlPotentiometer:potentiometerBegan (location) end
---* 
---@param maximumValue float
---@return self
function ControlPotentiometer:setMaximumValue (maximumValue) end
---* 
---@return float
function ControlPotentiometer:getMinimumValue () end
---* 
---@param var cc.Sprite
---@return self
function ControlPotentiometer:setThumbSprite (var) end
---* 
---@return float
function ControlPotentiometer:getValue () end
---*  Returns the distance between the point1 and point2. 
---@param point1 vec2_table
---@param point2 vec2_table
---@return float
function ControlPotentiometer:distanceBetweenPointAndPoint (point1,point2) end
---* 
---@param location vec2_table
---@return self
function ControlPotentiometer:potentiometerEnded (location) end
---* 
---@return vec2_table
function ControlPotentiometer:getPreviousLocation () end
---* 
---@param var cc.ProgressTimer
---@return self
function ControlPotentiometer:setProgressTimer (var) end
---* 
---@param minimumValue float
---@return self
function ControlPotentiometer:setMinimumValue (minimumValue) end
---* 
---@return cc.Sprite
function ControlPotentiometer:getThumbSprite () end
---* Initializes a potentiometer with a track sprite and a progress bar.<br>
---* param trackSprite   Sprite, that is used as a background.<br>
---* param progressTimer ProgressTimer, that is used as a progress bar.
---@param trackSprite cc.Sprite
---@param progressTimer cc.ProgressTimer
---@param thumbSprite cc.Sprite
---@return boolean
function ControlPotentiometer:initWithTrackSprite_ProgressTimer_ThumbSprite (trackSprite,progressTimer,thumbSprite) end
---* 
---@param location vec2_table
---@return self
function ControlPotentiometer:potentiometerMoved (location) end
---* Creates potentiometer with a track filename and a progress filename.
---@param backgroundFile char
---@param progressFile char
---@param thumbFile char
---@return self
function ControlPotentiometer:create (backgroundFile,progressFile,thumbFile) end
---* 
---@param touch cc.Touch
---@return boolean
function ControlPotentiometer:isTouchInside (touch) end
---* 
---@param enabled boolean
---@return self
function ControlPotentiometer:setEnabled (enabled) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlPotentiometer:onTouchMoved (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return self
function ControlPotentiometer:onTouchEnded (pTouch,pEvent) end
---* 
---@param pTouch cc.Touch
---@param pEvent cc.Event
---@return boolean
function ControlPotentiometer:onTouchBegan (pTouch,pEvent) end
---* js ctor<br>
---* lua new
---@return self
function ControlPotentiometer:ControlPotentiometer () end