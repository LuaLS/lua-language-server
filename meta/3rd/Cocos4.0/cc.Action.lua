---@meta

---@class cc.Action :cc.Ref
local Action={ }
cc.Action=Action




---*  Called before the action start. It will also set the target. <br>
---* param target A certain target.
---@param target cc.Node
---@return self
function Action:startWithTarget (target) end
---* Set the original target, since target can be nil.<br>
---* Is the target that were used to run the action. Unless you are doing something complex, like ActionManager, you should NOT call this method.<br>
---* The target is 'assigned', it is not 'retained'.<br>
---* since v0.8.2<br>
---* param originalTarget Is 'assigned', it is not 'retained'.
---@param originalTarget cc.Node
---@return self
function Action:setOriginalTarget (originalTarget) end
---*  Returns a clone of action.<br>
---* return A clone action.
---@return self
function Action:clone () end
---*  Return a original Target. <br>
---* return A original Target.
---@return cc.Node
function Action:getOriginalTarget () end
---* Called after the action has finished. It will set the 'target' to nil.<br>
---* IMPORTANT: You should never call "Action::stop()" manually. Instead, use: "target->stopAction(action);".
---@return self
function Action:stop () end
---* Called once per frame. time a value between 0 and 1.<br>
---* For example:<br>
---* - 0 Means that the action just started.<br>
---* - 0.5 Means that the action is in the middle.<br>
---* - 1 Means that the action is over.<br>
---* param time A value between 0 and 1.
---@param time float
---@return self
function Action:update (time) end
---*  Return certain target.<br>
---* return A certain target.
---@return cc.Node
function Action:getTarget () end
---*  Returns a flag field that is used to group the actions easily.<br>
---* return A tag.
---@return unsigned_int
function Action:getFlags () end
---*  Called every frame with it's delta time, dt in seconds. DON'T override unless you know what you are doing. <br>
---* param dt In seconds.
---@param dt float
---@return self
function Action:step (dt) end
---*  Changes the tag that is used to identify the action easily. <br>
---* param tag Used to identify the action easily.
---@param tag int
---@return self
function Action:setTag (tag) end
---*  Changes the flag field that is used to group the actions easily.<br>
---* param flags Used to group the actions easily.
---@param flags unsigned_int
---@return self
function Action:setFlags (flags) end
---*  Returns a tag that is used to identify the action easily. <br>
---* return A tag.
---@return int
function Action:getTag () end
---*  The action will modify the target properties. <br>
---* param target A certain target.
---@param target cc.Node
---@return self
function Action:setTarget (target) end
---*  Return true if the action has finished. <br>
---* return Is true if the action has finished.
---@return boolean
function Action:isDone () end
---*  Returns a new action that performs the exact reverse of the action. <br>
---* return A new action that performs the exact reverse of the action.<br>
---* js NA
---@return self
function Action:reverse () end