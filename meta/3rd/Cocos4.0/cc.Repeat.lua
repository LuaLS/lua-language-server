---@meta

---@class cc.Repeat :cc.ActionInterval
local Repeat={ }
cc.Repeat=Repeat




---*  Sets the inner action.<br>
---* param action The inner action.
---@param action cc.FiniteTimeAction
---@return self
function Repeat:setInnerAction (action) end
---*  initializes a Repeat action. Times is an unsigned integer between 1 and pow(2,30) 
---@param pAction cc.FiniteTimeAction
---@param times unsigned_int
---@return boolean
function Repeat:initWithAction (pAction,times) end
---*  Gets the inner action.<br>
---* return The inner action.
---@return cc.FiniteTimeAction
function Repeat:getInnerAction () end
---*  Creates a Repeat action. Times is an unsigned integer between 1 and pow(2,30).<br>
---* param action The action needs to repeat.<br>
---* param times The repeat times.<br>
---* return An autoreleased Repeat object.
---@param action cc.FiniteTimeAction
---@param times unsigned_int
---@return self
function Repeat:create (action,times) end
---* 
---@param target cc.Node
---@return self
function Repeat:startWithTarget (target) end
---* 
---@return self
function Repeat:reverse () end
---* 
---@return self
function Repeat:clone () end
---* 
---@return self
function Repeat:stop () end
---* param dt In seconds.
---@param dt float
---@return self
function Repeat:update (dt) end
---* 
---@return boolean
function Repeat:isDone () end
---* 
---@return self
function Repeat:Repeat () end