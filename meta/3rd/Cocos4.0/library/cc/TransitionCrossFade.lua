---@meta

---@class cc.TransitionCrossFade :cc.TransitionScene
local TransitionCrossFade={ }
cc.TransitionCrossFade=TransitionCrossFade




---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionCrossFade object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionCrossFade:create (t,scene) end
---* lua NA
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function TransitionCrossFade:draw (renderer,transform,flags) end
---* 
---@return self
function TransitionCrossFade:TransitionCrossFade () end