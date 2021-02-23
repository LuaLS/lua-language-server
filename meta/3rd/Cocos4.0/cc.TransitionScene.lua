---@meta

---@class cc.TransitionScene :cc.Scene
local TransitionScene={ }
cc.TransitionScene=TransitionScene




---* 
---@return cc.Scene
function TransitionScene:getInScene () end
---*  Called after the transition finishes.
---@return self
function TransitionScene:finish () end
---*  initializes a transition with duration and incoming scene 
---@param t float
---@param scene cc.Scene
---@return boolean
function TransitionScene:initWithDuration (t,scene) end
---* 
---@return float
function TransitionScene:getDuration () end
---*  Used by some transitions to hide the outer scene.
---@return self
function TransitionScene:hideOutShowIn () end
---*  Creates a base transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionScene object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionScene:create (t,scene) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function TransitionScene:draw (renderer,transform,flags) end
---* 
---@return self
function TransitionScene:cleanup () end
---* 
---@return self
function TransitionScene:TransitionScene () end