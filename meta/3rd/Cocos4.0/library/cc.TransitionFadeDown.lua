---@meta

---@class cc.TransitionFadeDown :cc.TransitionFadeTR
local TransitionFadeDown={ }
cc.TransitionFadeDown=TransitionFadeDown




---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionFadeDown object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionFadeDown:create (t,scene) end
---* 
---@param size size_table
---@return cc.ActionInterval
function TransitionFadeDown:actionWithSize (size) end
---* 
---@return self
function TransitionFadeDown:TransitionFadeDown () end