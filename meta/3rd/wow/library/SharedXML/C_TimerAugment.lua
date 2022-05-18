---@meta
---@class Ticker
local TickerPrototype = {}

---[FrameXML](https://www.townlong-yak.com/framexml/live/C_TimerAugment.lua)
--- Creates and starts a ticker that calls callback every duration seconds for N iterations.
--- If iterations is nil, the ticker will loop until cancelled.
---@param duration number
---@param callback function
---@param iterations? number
---@return Ticker
function C_Timer.NewTicker(duration, callback, iterations) end

---[FrameXML](https://www.townlong-yak.com/framexml/live/C_TimerAugment.lua)
--- Creates and starts a cancellable timer that calls callback after duration seconds.
---@param duration number
---@param callback function
---@return Ticker
function C_Timer.NewTimer(duration, callback) end

--- Cancels a ticker or timer. May be safely called within the ticker's callback in which
--- case the ticker simply won't be started again.
--- Cancel is guaranteed to be idempotent.
function TickerPrototype:Cancel() end

---@return boolean
function TickerPrototype:IsCancelled() end
