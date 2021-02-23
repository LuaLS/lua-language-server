---@meta

---@class cc.TransitionSceneOriented :cc.TransitionScene
local TransitionSceneOriented={ }
cc.TransitionSceneOriented=TransitionSceneOriented




---*  initializes a transition with duration and incoming scene 
---@param t float
---@param scene cc.Scene
---@param orientation int
---@return boolean
function TransitionSceneOriented:initWithDuration (t,scene,orientation) end
---*  Creates a transition with duration, incoming scene and orientation.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* param orientation A given orientation: LeftOver, RightOver, UpOver, DownOver.<br>
---* return A autoreleased TransitionSceneOriented object.
---@param t float
---@param scene cc.Scene
---@param orientation int
---@return self
function TransitionSceneOriented:create (t,scene,orientation) end
---* 
---@return self
function TransitionSceneOriented:TransitionSceneOriented () end