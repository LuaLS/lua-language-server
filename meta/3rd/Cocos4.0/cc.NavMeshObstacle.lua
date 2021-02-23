---@meta

---@class cc.NavMeshObstacle :cc.Component
local NavMeshObstacle={ }
cc.NavMeshObstacle=NavMeshObstacle




---* 
---@return int
function NavMeshObstacle:getSyncFlag () end
---* 
---@param radius float
---@param height float
---@return boolean
function NavMeshObstacle:initWith (radius,height) end
---*  synchronize parameter to obstacle. 
---@return self
function NavMeshObstacle:syncToObstacle () end
---*  synchronize parameter to node. 
---@return self
function NavMeshObstacle:syncToNode () end
---*  Get height of obstacle 
---@return float
function NavMeshObstacle:getHeight () end
---* synchronization between node and obstacle is time consuming, you can skip some synchronization using this function
---@param flag int
---@return self
function NavMeshObstacle:setSyncFlag (flag) end
---*  Get radius of obstacle 
---@return float
function NavMeshObstacle:getRadius () end
---* Create obstacle, shape is cylinder<br>
---* param radius The radius of obstacle.<br>
---* param height The height of obstacle.
---@param radius float
---@param height float
---@return self
function NavMeshObstacle:create (radius,height) end
---* 
---@return string
function NavMeshObstacle:getNavMeshObstacleComponentName () end
---* 
---@return self
function NavMeshObstacle:onEnter () end
---* 
---@return self
function NavMeshObstacle:onExit () end
---* 
---@return self
function NavMeshObstacle:NavMeshObstacle () end