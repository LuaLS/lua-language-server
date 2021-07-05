---@meta

---@class cc.TransitionSlideInL :cc.TransitionScene@all parent class: TransitionScene,TransitionEaseScene
local TransitionSlideInL={ }
cc.TransitionSlideInL=TransitionSlideInL




---*  Returns the action that will be performed by the incoming and outgoing scene.<br>
---* return The action that will be performed by the incoming and outgoing scene.
---@return cc.ActionInterval
function TransitionSlideInL:action () end
---* 
---@param action cc.ActionInterval
---@return cc.ActionInterval
function TransitionSlideInL:easeActionWithAction (action) end
---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionSlideInL object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionSlideInL:create (t,scene) end
---* 
---@return self
function TransitionSlideInL:TransitionSlideInL () end