---@meta

---@class cc.PhysicsContactPostSolve 
local PhysicsContactPostSolve={ }
cc.PhysicsContactPostSolve=PhysicsContactPostSolve




---*  Get friction between two bodies.
---@return float
function PhysicsContactPostSolve:getFriction () end
---*  Get surface velocity between two bodies.
---@return vec2_table
function PhysicsContactPostSolve:getSurfaceVelocity () end
---*  Get restitution between two bodies.
---@return float
function PhysicsContactPostSolve:getRestitution () end