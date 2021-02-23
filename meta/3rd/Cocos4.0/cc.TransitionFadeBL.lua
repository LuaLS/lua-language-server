---@meta

---@class cc.TransitionFadeBL :cc.TransitionFadeTR
local TransitionFadeBL={ }
cc.TransitionFadeBL=TransitionFadeBL




---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionFadeBL object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionFadeBL:create (t,scene) end
---* 
---@param size size_table
---@return cc.ActionInterval
function TransitionFadeBL:actionWithSize (size) end
---* 
---@return self
function TransitionFadeBL:TransitionFadeBL () end