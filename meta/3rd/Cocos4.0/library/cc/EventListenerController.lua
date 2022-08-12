---@meta

---@class cc.EventListenerController :cc.EventListener
local EventListenerController={ }
cc.EventListenerController=EventListenerController




---*  Create a controller event listener.<br>
---* return An autoreleased EventListenerController object.
---@return self
function EventListenerController:create () end
---* 
---@return self
function EventListenerController:clone () end
---* / Overrides
---@return boolean
function EventListenerController:checkAvailable () end