---@meta

---@class cc.TransitionSlideInR :cc.TransitionSlideInL
local TransitionSlideInR={ }
cc.TransitionSlideInR=TransitionSlideInR




---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionSlideInR object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionSlideInR:create (t,scene) end
---*  Returns the action that will be performed by the incoming and outgoing scene. 
---@return cc.ActionInterval
function TransitionSlideInR:action () end
---* 
---@return self
function TransitionSlideInR:TransitionSlideInR () end