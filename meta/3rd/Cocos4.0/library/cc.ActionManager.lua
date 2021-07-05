---@meta

---@class cc.ActionManager :cc.Ref
local ActionManager={ }
cc.ActionManager=ActionManager




---*  Gets an action given its tag an a target.<br>
---* param tag       The action's tag.<br>
---* param target    A certain target.<br>
---* return  The Action the with the given tag.
---@param tag int
---@param target cc.Node
---@return cc.Action
function ActionManager:getActionByTag (tag,target) end
---*  Removes an action given its tag and the target.<br>
---* param tag       The action's tag.<br>
---* param target    A certain target.
---@param tag int
---@param target cc.Node
---@return self
function ActionManager:removeActionByTag (tag,target) end
---*  Removes all actions matching at least one bit in flags and the target.<br>
---* param flags     The flag field to match the actions' flags based on bitwise AND.<br>
---* param target    A certain target.<br>
---* js NA
---@param flags unsigned_int
---@param target cc.Node
---@return self
function ActionManager:removeActionsByFlags (flags,target) end
---*  Removes all actions from all the targets.
---@return self
function ActionManager:removeAllActions () end
---*  Adds an action with a target. <br>
---* If the target is already present, then the action will be added to the existing target.<br>
---* If the target is not present, a new instance of this target will be created either paused or not, and the action will be added to the newly created target.<br>
---* When the target is paused, the queued actions won't be 'ticked'.<br>
---* param action    A certain action.<br>
---* param target    The target which need to be added an action.<br>
---* param paused    Is the target paused or not.
---@param action cc.Action
---@param target cc.Node
---@param paused boolean
---@return self
function ActionManager:addAction (action,target,paused) end
---*  Resumes the target. All queued actions will be resumed.<br>
---* param target    A certain target.
---@param target cc.Node
---@return self
function ActionManager:resumeTarget (target) end
---*  Returns the numbers of actions that are running in all targets.<br>
---* return  The numbers of actions that are running in all target.<br>
---* js NA
---@return int
function ActionManager:getNumberOfRunningActions () end
---*  Pauses the target: all running actions and newly added actions will be paused.<br>
---* param target    A certain target.
---@param target cc.Node
---@return self
function ActionManager:pauseTarget (target) end
---*  Returns the numbers of actions that are running in a certain target. <br>
---* Composable actions are counted as 1 action. Example:<br>
---* - If you are running 1 Sequence of 7 actions, it will return 1.<br>
---* - If you are running 7 Sequences of 2 actions, it will return 7.<br>
---* param target    A certain target.<br>
---* return  The numbers of actions that are running in a certain target.<br>
---* js NA
---@param target cc.Node
---@return int
function ActionManager:getNumberOfRunningActionsInTarget (target) end
---*  Removes all actions from a certain target.<br>
---* All the actions that belongs to the target will be removed.<br>
---* param target    A certain target.
---@param target cc.Node
---@return self
function ActionManager:removeAllActionsFromTarget (target) end
---*  Resume a set of targets (convenience function to reverse a pauseAllRunningActions call).<br>
---* param targetsToResume   A set of targets need to be resumed.
---@param targetsToResume array_table
---@return self
function ActionManager:resumeTargets (targetsToResume) end
---*  Removes an action given an action reference.<br>
---* param action    A certain target.
---@param action cc.Action
---@return self
function ActionManager:removeAction (action) end
---*  Pauses all running actions, returning a list of targets whose actions were paused.<br>
---* return  A list of targets whose actions were paused.
---@return array_table
function ActionManager:pauseAllRunningActions () end
---*  Main loop of ActionManager.<br>
---* param dt    In seconds.
---@param dt float
---@return self
function ActionManager:update (dt) end
---*  Removes all actions given its tag and the target.<br>
---* param tag       The actions' tag.<br>
---* param target    A certain target.<br>
---* js NA
---@param tag int
---@param target cc.Node
---@return self
function ActionManager:removeAllActionsByTag (tag,target) end
---*  Returns the numbers of actions that are running in a<br>
---* certain target with a specific tag.<br>
---* Like getNumberOfRunningActionsInTarget Composable actions<br>
---* are counted as 1 action. Example:<br>
---* - If you are running 1 Sequence of 7 actions, it will return 1.<br>
---* - If you are running 7 Sequences of 2 actions, it will return 7.<br>
---* param target    A certain target.<br>
---* param tag       Tag that will be searched.<br>
---* return  The numbers of actions that are running in a certain target<br>
---* with a specific tag.<br>
---* see getNumberOfRunningActionsInTarget<br>
---* js NA
---@param target cc.Node
---@param tag int
---@return unsigned_int
function ActionManager:getNumberOfRunningActionsInTargetByTag (target,tag) end
---* js ctor
---@return self
function ActionManager:ActionManager () end