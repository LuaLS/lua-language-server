---@meta

---@class cc.EventListenerPhysicsContactWithShapes :cc.EventListenerPhysicsContact
local EventListenerPhysicsContactWithShapes={ }
cc.EventListenerPhysicsContactWithShapes=EventListenerPhysicsContactWithShapes




---* 
---@param shapeA cc.PhysicsShape
---@param shapeB cc.PhysicsShape
---@return boolean
function EventListenerPhysicsContactWithShapes:hitTest (shapeA,shapeB) end
---*  Create the listener. 
---@param shapeA cc.PhysicsShape
---@param shapeB cc.PhysicsShape
---@return self
function EventListenerPhysicsContactWithShapes:create (shapeA,shapeB) end
---* 
---@return self
function EventListenerPhysicsContactWithShapes:clone () end