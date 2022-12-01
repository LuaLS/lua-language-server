---@meta

---@class cc.PhysicsContact :cc.EventCustom
local PhysicsContact={ }
cc.PhysicsContact=PhysicsContact




---*  Get contact data. 
---@return cc.PhysicsContactData
function PhysicsContact:getContactData () end
---*  Get the event code 
---@return int
function PhysicsContact:getEventCode () end
---*  Get previous contact data 
---@return cc.PhysicsContactData
function PhysicsContact:getPreContactData () end
---*  Get contact shape A. 
---@return cc.PhysicsShape
function PhysicsContact:getShapeA () end
---*  Get contact shape B. 
---@return cc.PhysicsShape
function PhysicsContact:getShapeB () end