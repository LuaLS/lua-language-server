---@meta

---@class cc.Scheduler :cc.Ref
local Scheduler={ }
cc.Scheduler=Scheduler




---*  Modifies the time of all scheduled callbacks.<br>
---* You can use this property to create a 'slow motion' or 'fast forward' effect.<br>
---* Default is 1.0. To create a 'slow motion' effect, use values below 1.0.<br>
---* To create a 'fast forward' effect, use values higher than 1.0.<br>
---* since v0.8<br>
---* warning It will affect EVERY scheduled selector / action.
---@param timeScale float
---@return self
function Scheduler:setTimeScale (timeScale) end
---* Remove all pending functions queued to be performed with Scheduler::performFunctionInCocosThread<br>
---* Functions unscheduled in this manner will not be executed<br>
---* This function is thread safe<br>
---* since v3.14<br>
---* js NA
---@return self
function Scheduler:removeAllFunctionsToBePerformedInCocosThread () end
---* Gets the time scale of schedule callbacks.<br>
---* see Scheduler::setTimeScale()
---@return float
function Scheduler:getTimeScale () end
---* Constructor<br>
---* js ctor
---@return self
function Scheduler:Scheduler () end