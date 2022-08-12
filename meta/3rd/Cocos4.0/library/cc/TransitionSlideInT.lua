---@meta

---@class cc.TransitionSlideInT :cc.TransitionSlideInL
local TransitionSlideInT={ }
cc.TransitionSlideInT=TransitionSlideInT




---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionSlideInT object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionSlideInT:create (t,scene) end
---*  returns the action that will be performed by the incoming and outgoing scene 
---@return cc.ActionInterval
function TransitionSlideInT:action () end
---* 
---@return self
function TransitionSlideInT:TransitionSlideInT () end