---@meta

---@class cc.EventListenerPhysicsContactWithBodies :cc.EventListenerPhysicsContact
local EventListenerPhysicsContactWithBodies={ }
cc.EventListenerPhysicsContactWithBodies=EventListenerPhysicsContactWithBodies




---* 
---@param shapeA cc.PhysicsShape
---@param shapeB cc.PhysicsShape
---@return boolean
function EventListenerPhysicsContactWithBodies:hitTest (shapeA,shapeB) end
---*  Create the listener. 
---@param bodyA cc.PhysicsBody
---@param bodyB cc.PhysicsBody
---@return self
function EventListenerPhysicsContactWithBodies:create (bodyA,bodyB) end
---* 
---@return self
function EventListenerPhysicsContactWithBodies:clone () end