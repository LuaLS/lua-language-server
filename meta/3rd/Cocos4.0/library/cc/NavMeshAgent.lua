---@meta

---@class cc.NavMeshAgent :cc.Component
local NavMeshAgent={ }
cc.NavMeshAgent=NavMeshAgent




---*  set maximal speed of agent 
---@param maxSpeed float
---@return self
function NavMeshAgent:setMaxSpeed (maxSpeed) end
---*  synchronize parameter to node. 
---@return self
function NavMeshAgent:syncToNode () end
---* Traverse OffMeshLink manually
---@return self
function NavMeshAgent:completeOffMeshLink () end
---*  get separation weight 
---@return float
function NavMeshAgent:getSeparationWeight () end
---* Set automatic Traverse OffMeshLink 
---@param isAuto boolean
---@return self
function NavMeshAgent:setAutoTraverseOffMeshLink (isAuto) end
---*  get current velocity 
---@return vec3_table
function NavMeshAgent:getCurrentVelocity () end
---*  synchronize parameter to agent. 
---@return self
function NavMeshAgent:syncToAgent () end
---* Check agent arrived OffMeshLink 
---@return boolean
function NavMeshAgent:isOnOffMeshLink () end
---*  set separation weight 
---@param weight float
---@return self
function NavMeshAgent:setSeparationWeight (weight) end
---*  pause movement 
---@return self
function NavMeshAgent:pause () end
---* 
---@return void
function NavMeshAgent:getUserData () end
---* Set automatic Orientation 
---@param isAuto boolean
---@return self
function NavMeshAgent:setAutoOrientation (isAuto) end
---*  get agent height 
---@return float
function NavMeshAgent:getHeight () end
---*  get maximal speed of agent 
---@return float
function NavMeshAgent:getMaxSpeed () end
---* Get current OffMeshLink information
---@return cc.OffMeshLinkData
function NavMeshAgent:getCurrentOffMeshLinkData () end
---*  get agent radius 
---@return float
function NavMeshAgent:getRadius () end
---* synchronization between node and agent is time consuming, you can skip some synchronization using this function
---@param flag int
---@return self
function NavMeshAgent:setSyncFlag (flag) end
---* 
---@return int
function NavMeshAgent:getSyncFlag () end
---*  resume movement 
---@return self
function NavMeshAgent:resume () end
---*  stop movement 
---@return self
function NavMeshAgent:stop () end
---*  set maximal acceleration of agent
---@param maxAcceleration float
---@return self
function NavMeshAgent:setMaxAcceleration (maxAcceleration) end
---* Set the reference axes of agent's orientation<br>
---* param rotRefAxes The value of reference axes in local coordinate system.
---@param rotRefAxes vec3_table
---@return self
function NavMeshAgent:setOrientationRefAxes (rotRefAxes) end
---*  get maximal acceleration of agent
---@return float
function NavMeshAgent:getMaxAcceleration () end
---*  set agent height 
---@param height float
---@return self
function NavMeshAgent:setHeight (height) end
---* 
---@param data void
---@return self
function NavMeshAgent:setUserData (data) end
---*  get obstacle avoidance type 
---@return unsigned_char
function NavMeshAgent:getObstacleAvoidanceType () end
---*  get current velocity 
---@return vec3_table
function NavMeshAgent:getVelocity () end
---*  set agent radius 
---@param radius float
---@return self
function NavMeshAgent:setRadius (radius) end
---*  set obstacle avoidance type 
---@param type unsigned_char
---@return self
function NavMeshAgent:setObstacleAvoidanceType (type) end
---* 
---@return string
function NavMeshAgent:getNavMeshAgentComponentName () end
---* Create agent<br>
---* param param The parameters of agent.
---@param param cc.NavMeshAgentParam
---@return self
function NavMeshAgent:create (param) end
---* 
---@return self
function NavMeshAgent:onEnter () end
---* 
---@return self
function NavMeshAgent:onExit () end
---* 
---@return self
function NavMeshAgent:NavMeshAgent () end