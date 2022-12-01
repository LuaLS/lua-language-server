---@meta

---@class cc.EventListenerPhysicsContactWithGroup :cc.EventListenerPhysicsContact
local EventListenerPhysicsContactWithGroup={ }
cc.EventListenerPhysicsContactWithGroup=EventListenerPhysicsContactWithGroup




---* 
---@param shapeA cc.PhysicsShape
---@param shapeB cc.PhysicsShape
---@return boolean
function EventListenerPhysicsContactWithGroup:hitTest (shapeA,shapeB) end
---*  Create the listener. 
---@param group int
---@return self
function EventListenerPhysicsContactWithGroup:create (group) end
---* 
---@return self
function EventListenerPhysicsContactWithGroup:clone () end