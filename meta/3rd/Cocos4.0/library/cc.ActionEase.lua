---@meta

---@class cc.ActionEase :cc.ActionInterval
local ActionEase={ }
cc.ActionEase=ActionEase




---* brief Initializes the action.<br>
---* return Return true when the initialization success, otherwise return false.
---@param action cc.ActionInterval
---@return boolean
function ActionEase:initWithAction (action) end
---* brief Get the pointer of the inner action.<br>
---* return The pointer of the inner action.
---@return cc.ActionInterval
function ActionEase:getInnerAction () end
---* 
---@param target cc.Node
---@return self
function ActionEase:startWithTarget (target) end
---* 
---@return self
function ActionEase:stop () end
---* 
---@param time float
---@return self
function ActionEase:update (time) end