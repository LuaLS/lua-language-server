---@meta

---@class cc.PhysicsSprite3D :cc.Sprite3D
local PhysicsSprite3D={ }
cc.PhysicsSprite3D=PhysicsSprite3D




---*  synchronize node transformation to physics. 
---@return self
function PhysicsSprite3D:syncNodeToPhysics () end
---*  synchronize physics transformation to node. 
---@return self
function PhysicsSprite3D:syncPhysicsToNode () end
---*  Get the Physics3DObject. 
---@return cc.Physics3DObject
function PhysicsSprite3D:getPhysicsObj () end
---*  Set synchronization flag, see Physics3DComponent. 
---@param syncFlag int
---@return self
function PhysicsSprite3D:setSyncFlag (syncFlag) end
---* 
---@return self
function PhysicsSprite3D:PhysicsSprite3D () end