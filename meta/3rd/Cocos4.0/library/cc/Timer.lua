---@meta

---@class cc.Timer :cc.Ref
local Timer={ }
cc.Timer=Timer




---* 
---@param seconds float
---@param _repeat unsigned_int
---@param delay float
---@return self
function Timer:setupTimerWithInterval (seconds,_repeat,delay) end
---*  triggers the timer 
---@param dt float
---@return self
function Timer:update (dt) end
---* 
---@return boolean
function Timer:isAborted () end
---* 
---@return boolean
function Timer:isExhausted () end
---* 
---@param dt float
---@return self
function Timer:trigger (dt) end
---* 
---@return self
function Timer:cancel () end
---* 
---@return self
function Timer:setAborted () end