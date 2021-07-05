---@meta

---@class cc.EventListenerPhysicsContact :cc.EventListenerCustom
local EventListenerPhysicsContact={ }
cc.EventListenerPhysicsContact=EventListenerPhysicsContact




---*  Create the listener. 
---@return self
function EventListenerPhysicsContact:create () end
---*  Clone an object from this listener.
---@return self
function EventListenerPhysicsContact:clone () end
---*  Check the listener is available.<br>
---* return True if there's one available callback function at least, false if there's no one.
---@return boolean
function EventListenerPhysicsContact:checkAvailable () end