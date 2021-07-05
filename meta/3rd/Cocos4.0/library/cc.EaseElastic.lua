---@meta

---@class cc.EaseElastic :cc.ActionEase
local EaseElastic={ }
cc.EaseElastic=EaseElastic




---* brief Set period of the wave in radians.<br>
---* param fPeriod The value will be set.
---@param fPeriod float
---@return self
function EaseElastic:setPeriod (fPeriod) end
---* brief Initializes the action with the inner action and the period in radians.<br>
---* param action The pointer of the inner action.<br>
---* param period Period of the wave in radians. Default is 0.3.<br>
---* return Return true when the initialization success, otherwise return false.
---@param action cc.ActionInterval
---@param period float
---@return boolean
function EaseElastic:initWithAction (action,period) end
---* brief Get period of the wave in radians. Default value is 0.3.<br>
---* return Return the period of the wave in radians.
---@return float
function EaseElastic:getPeriod () end