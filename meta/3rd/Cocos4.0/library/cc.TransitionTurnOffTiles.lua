---@meta

---@class cc.TransitionTurnOffTiles :cc.TransitionScene@all parent class: TransitionScene,TransitionEaseScene
local TransitionTurnOffTiles={ }
cc.TransitionTurnOffTiles=TransitionTurnOffTiles




---* 
---@param action cc.ActionInterval
---@return cc.ActionInterval
function TransitionTurnOffTiles:easeActionWithAction (action) end
---*  Creates a transition with duration and incoming scene.<br>
---* param t Duration time, in seconds.<br>
---* param scene A given scene.<br>
---* return A autoreleased TransitionTurnOffTiles object.
---@param t float
---@param scene cc.Scene
---@return self
function TransitionTurnOffTiles:create (t,scene) end
---* js NA
---@param renderer cc.Renderer
---@param transform mat4_table
---@param flags unsigned_int
---@return self
function TransitionTurnOffTiles:draw (renderer,transform,flags) end
---* 
---@return self
function TransitionTurnOffTiles:TransitionTurnOffTiles () end