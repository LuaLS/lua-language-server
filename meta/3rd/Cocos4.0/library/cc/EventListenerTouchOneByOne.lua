---@meta

---@class cc.EventListenerTouchOneByOne :cc.EventListener
local EventListenerTouchOneByOne={ }
cc.EventListenerTouchOneByOne=EventListenerTouchOneByOne




---*  Is swall touches or not.<br>
---* return True if needs to swall touches.
---@return boolean
function EventListenerTouchOneByOne:isSwallowTouches () end
---*  Whether or not to swall touches.<br>
---* param needSwallow True if needs to swall touches.
---@param needSwallow boolean
---@return self
function EventListenerTouchOneByOne:setSwallowTouches (needSwallow) end
---* 
---@return boolean
function EventListenerTouchOneByOne:init () end
---* / Overrides
---@return self
function EventListenerTouchOneByOne:clone () end
---* 
---@return boolean
function EventListenerTouchOneByOne:checkAvailable () end
---* 
---@return self
function EventListenerTouchOneByOne:EventListenerTouchOneByOne () end