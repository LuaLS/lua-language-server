---@meta

---@class cc.TransitionSplitCols :cc.TransitionScene@all parent class: TransitionScene,TransitionEaseScene
local TransitionSplitCols={ }
cc.TransitionSplitCols=TransitionSplitCols




---*  Returns the action that will be performed.<br>
---* return The action that will be performed.
---@return cc.ActionInterval
function TransitionSplitCols:action () end
---* 
---@param action cc.ActionInterval
---@return cc.ActionInterval
function TransitionSplitCols:easeActionWithAction (action) end
---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionSplitCols object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionSplitCols:create (t,scene) end
---* 
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function TransitionSplitCols:draw (renderer,transform,flags) end
---* 
---@return self
function TransitionSplitCols:TransitionSplitCols () end