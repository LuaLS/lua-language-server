---@meta

---@class cc.RepeatForever :cc.ActionInterval
local RepeatForever={ }
cc.RepeatForever=RepeatForever




---*  Sets the inner action.<br>
---* param action The inner action.
---@param action cc.ActionInterval
---@return self
function RepeatForever:setInnerAction (action) end
---*  initializes the action 
---@param action cc.ActionInterval
---@return boolean
function RepeatForever:initWithAction (action) end
---*  Gets the inner action.<br>
---* return The inner action.
---@return cc.ActionInterval
function RepeatForever:getInnerAction () end
---*  Creates the action.<br>
---* param action The action need to repeat forever.<br>
---* return An autoreleased RepeatForever object.
---@param action cc.ActionInterval
---@return self
function RepeatForever:create (action) end
---* 
---@param target cc.Node
---@return self
function RepeatForever:startWithTarget (target) end
---* 
---@return self
function RepeatForever:clone () end
---* 
---@return boolean
function RepeatForever:isDone () end
---* 
---@return self
function RepeatForever:reverse () end
---* param dt In seconds.
---@param dt float
---@return self
function RepeatForever:step (dt) end
---* 
---@return self
function RepeatForever:RepeatForever () end