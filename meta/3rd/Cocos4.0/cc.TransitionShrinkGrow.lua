---@meta

---@class cc.TransitionShrinkGrow :cc.TransitionScene@all parent class: TransitionScene,TransitionEaseScene
local TransitionShrinkGrow={ }
cc.TransitionShrinkGrow=TransitionShrinkGrow




---* 
---@param action cc.ActionInterval
---@return cc.ActionInterval
function TransitionShrinkGrow:easeActionWithAction (action) end
---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionShrinkGrow object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionShrinkGrow:create (t,scene) end
---* 
---@return self
function TransitionShrinkGrow:TransitionShrinkGrow () end