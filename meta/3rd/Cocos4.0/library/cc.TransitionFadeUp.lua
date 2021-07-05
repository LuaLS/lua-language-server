---@meta

---@class cc.TransitionFadeUp :cc.TransitionFadeTR
local TransitionFadeUp={ }
cc.TransitionFadeUp=TransitionFadeUp




---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionFadeUp object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionFadeUp:create (t,scene) end
---* 
---@param size size_table
---@return cc.ActionInterval
function TransitionFadeUp:actionWithSize (size) end
---* 
---@return self
function TransitionFadeUp:TransitionFadeUp () end