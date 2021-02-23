---@meta

---@class cc.Physics3DWorld :cc.Ref
local Physics3DWorld={ }
cc.Physics3DWorld=Physics3DWorld




---*  set gravity for the physics world 
---@param gravity vec3_table
---@return self
function Physics3DWorld:setGravity (gravity) end
---*  Simulate one frame. 
---@param dt float
---@return self
function Physics3DWorld:stepSimulate (dt) end
---* 
---@return boolean
function Physics3DWorld:needCollisionChecking () end
---* 
---@return self
function Physics3DWorld:collisionChecking () end
---* 
---@return self
function Physics3DWorld:setGhostPairCallback () end
---*  Remove all Physics3DObjects. 
---@return self
function Physics3DWorld:removeAllPhysics3DObjects () end
---*  Check debug drawing is enabled. 
---@return boolean
function Physics3DWorld:isDebugDrawEnabled () end
---*  Remove all Physics3DConstraint. 
---@return self
function Physics3DWorld:removeAllPhysics3DConstraints () end
---*  get current gravity 
---@return vec3_table
function Physics3DWorld:getGravity () end
---*  Remove a Physics3DConstraint. 
---@param constraint cc.Physics3DConstraint
---@return self
function Physics3DWorld:removePhysics3DConstraint (constraint) end
---*  Add a Physics3DObject. 
---@param physicsObj cc.Physics3DObject
---@return self
function Physics3DWorld:addPhysics3DObject (physicsObj) end
---*  Enable or disable debug drawing. 
---@param enableDebugDraw boolean
---@return self
function Physics3DWorld:setDebugDrawEnable (enableDebugDraw) end
---*  Remove a Physics3DObject. 
---@param physicsObj cc.Physics3DObject
---@return self
function Physics3DWorld:removePhysics3DObject (physicsObj) end
---*  Add a Physics3DConstraint. 
---@param constraint cc.Physics3DConstraint
---@param disableCollisionsBetweenLinkedObjs boolean
---@return self
function Physics3DWorld:addPhysics3DConstraint (constraint,disableCollisionsBetweenLinkedObjs) end
---*  Internal method, the updater of debug drawing, need called each frame. 
---@param renderer cc.Renderer
---@return self
function Physics3DWorld:debugDraw (renderer) end
---* 
---@return self
function Physics3DWorld:Physics3DWorld () end